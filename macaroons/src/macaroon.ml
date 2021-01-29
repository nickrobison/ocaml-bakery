
type t = {
  id: string;
  location: string;
  caveats: string list;
  signature: Cstruct.t;
}

let seq_to_int_str seq =
  Seq.map (fun c -> Char.code c) seq
  |> Seq.fold_left (fun str c -> str ^ " " ^ (Int.to_string c)) ""

let _cstr_to_int_str cstr =
    Cstruct.to_bytes cstr
    |> Bytes.to_seq
    |> seq_to_int_str

let macaroons_magic_key = Cstruct.of_string "macaroons-key-generator"

let _b64_encode = Base64.encode_exn ?alphabet:(Some Base64.uri_safe_alphabet)

let hmac key msg =
  Nocrypto.Hash.SHA256.hmac ~key msg

(* Derives a new root key from [macaroons_magic_key] *)
let derive_key = hmac macaroons_magic_key

let create ~id ~location key =
  let key' = Cstruct.of_string key
             |> derive_key in
  {
    id;
    location;
    caveats = [];
    signature = (hmac key' (Cstruct.of_string id));
  }

let identifier t =
  t.id

let location t =
  t.location

let signature {signature; _} =
  let h = Hex.of_cstruct signature in
  match h with
  | `Hex s -> s
