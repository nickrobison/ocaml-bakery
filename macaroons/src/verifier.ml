type t = string list

let create () =
  []

(** This function attempts to match the given [cav] against [t] list of caveats.
    If it matches, that means the caveat is satisfied, so we invert the return optionally.
    A little confusing, but not too terrible*)
let match_caveat t cav =
  let cav = Caveat.to_string cav in
  match (List.find_opt (fun c -> String.equal cav c) t) with
  | Some _ -> None
  | None -> Some cav

let filter_opt = function
  | Some _ -> true
  | None -> false

let unwrap_opt = function
  | Some m -> m
  | None -> raise (Invalid_argument "Cannot have empty value")

let verify t macaroon key =
  let derived_key = Crypto.derive_key (Cstruct.of_string key) in
  let caveats = Macaroon.caveats macaroon in
  let failures = List.map (fun c -> match_caveat t c) caveats
                 |> List.filter filter_opt
                 |> List.map unwrap_opt in
  if List.length failures <> 0 then Error failures else
    begin
      (*Verify the signatures *)
      let signature_components = (Cstruct.of_string (Macaroon.identifier macaroon)) :: (List.map (fun c -> Caveat.to_cstruct c) caveats) in
      let computed_sig = List.fold_left (fun signature msg -> Crypto.hmac signature msg) derived_key signature_components in
      (* TODO: This needs to be safe equals *)
      match (Eqaf_cstruct.equal (Macaroon.signature_raw macaroon) computed_sig) with
      | true -> Ok ()
      | false -> Error ["signatures don't match"]
    end


let add_first_party_caveat t caveat =
  t @ [caveat]
