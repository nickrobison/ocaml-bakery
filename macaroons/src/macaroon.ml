module Cstruct = struct
  include Cstruct

  let pp f t =
    Fmt.pf f "%s" (Cstruct.to_string t)
end

module Make(C: Macaroon_intf.C): Macaroon_intf.M with type c = C.t = struct

  type c = C.t

  let equal_c = C.equal
  let pp_c = C.pp

  type t = {
    id: string;
    location: string;
    caveats: c list;
    signature: Cstruct.t;
  } [@@deriving eq, show]

  type macaroon_format = | V1 | V2 | V2J

  type identifier = | Location of string | Identifier of string | Signature of Cstruct.t | Cid of string

  (*Serializer stuff*)

  (** Encode package length. Stolen from: https://github.com/nojb/ocaml-macaroons/blob/712150ec551e0d3b0c8c4b90ee05fed41fe501bc/lib/macaroons.ml#L125*)
  let w_int n =
    let p s o =
      let digits = "0123456789abcdef" in
      let c i =
        let x = ((n lsr (4*(3-i))) land 0xF) in
        digits.[x]
      in
      Bytes.set s (o + 0) (c 0);
      Bytes.set s (0 + 1) (c 1);
      Bytes.set s (0 + 2) (c 2);
      Bytes.set s (0 + 3) (c 3)
    in
    p

  let get_buffer_size t =
    let id_len = 6 + String.length "identifier" + String.length t.id in
    let loc_len = 6 + String.length "location" + String.length t.location in
    id_len + loc_len

  let write_packet t k v =
    let len = 6 + String.length k + Bytes.length v in
    let header = Bytes.create 4 in
    let v' = w_int len in
    v' header 0;
    let open Faraday in
    write_bytes t header;
    write_string t k;
    write_char t ' ';
    write_bytes t v;
    write_char t '\n'

  let write_caveats t caveats =
    (* I think this can probably be optimized a lot better, seems like a ton of allocations*)
    List.iter (fun c -> write_packet t "cid" (C.to_bytes c)) caveats


  let serialize m =
    let open Faraday in
    let t = create (get_buffer_size m) in
    write_packet t "location" (Bytes.of_string m.location);
    write_packet t "identifier" (Bytes.of_string m.id);
    write_caveats t m.caveats;
    write_packet t "signature" (Cstruct.to_bytes m.signature);
    serialize_to_string t

  (* Parser stuff *)

  let parse_packet packet =
    match packet with
    | _, k, v ->
      match k with
      | "identifier" -> (Identifier v)
      | "location" -> (Location v)
      | "signature" -> (Signature (Cstruct.of_string v))
      | "cid" -> (Cid v)
      | _s -> raise (Invalid_argument "note")

  let make_from_packets packets =
    List.fold_left (fun acc p ->
        match p with
        | Location l -> {acc with location = l}
        | Signature s -> {acc with signature = s}
        | Identifier i -> {acc with id = i}
        | Cid s -> {acc with caveats = acc.caveats @ [(C.create s)]}
      ) {
      id = "";
      location = "";
      caveats = [];
      signature = Cstruct.empty;
    } packets

  let deserialize_raw str =
    print_endline str;
    (* This is gross, but until my angstrom skills get better, I'm not sure how to have a terminating byte*)
    let str = str ^ "\n" in
    match Angstrom.(parse_string ~consume:All Parser_utils.m_v1 str) with
    | Ok s -> let packets = List.map parse_packet s in
      Ok (make_from_packets packets)
    | Error err -> Error err

  let b64_encode = Base64.encode_exn ?alphabet:(Some Base64.uri_safe_alphabet) ~pad:false

  let b64_decode = Base64.decode_exn ~alphabet:Base64.uri_safe_alphabet ~pad:false

  let create ~id ~location key =
    let key' = Cstruct.of_string key
               |> Crypto.derive_key in
    {
      id;
      location;
      caveats = [];
      signature = (Crypto.hmac key' (Cstruct.of_string id));
    }

  let identifier t =
    t.id

  let location t =
    t.location

  let signature_raw t =
    t.signature

  let signature {signature; _} =
    let h = Hex.of_cstruct signature in
    match h with
    | `Hex s -> s

  let num_caveats t = List.length t.caveats

  let add_first_party_caveat t cav =
    let module H = Nocrypto.Hash.SHA256 in
    let b = C.to_cstruct cav in
    let signature = Crypto.hmac t.signature b in
    {t with caveats = t.caveats @ [cav]; signature}

  let caveats t =
    t.caveats

  let serialize t format =
    match format with
    | V1 -> serialize t |> b64_encode
    | _ -> raise (Invalid_argument "Cannot serialize to this, yet")

  let deserialize str =
    b64_decode str
    (*TODO: We don't always need to decode twice, so we shouldn't*)
    |> b64_decode
    |> deserialize_raw

  let valid t =
    (* A valid macaroon must have an ID and a signature*)
    t.id <> "" && not (Cstruct.is_empty t.signature)

end
