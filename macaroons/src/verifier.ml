module Make(C: Macaroon_intf.C)(M: Macaroon_intf.M with type c = C.t): Macaroon_intf.V with type m = M.t = struct

  type t = string list

  type m = M.t

  let create () =
    []

  (** This function attempts to match the given [cav] against [t] list of caveats.
      If it matches, that means the caveat is satisfied, so we invert the return optionally.
      A little confusing, but not too terrible*)
  let match_caveat t cav =
    let cav = C.to_string cav in
    match (List.find_opt (fun c -> String.equal cav c) t) with
    | Some _ -> None
    | None -> Some cav

  let filter_opt = function
    | Some _ -> true
    | None -> false


  let unwrap_opt = function
    | Some m -> m
    | None -> raise (Invalid_argument "Cannot have empty value")

  let satisfy_exact t cav =
    Ok (t @ [cav])

  let verify t macaroon key =
    let derived_key = Crypto.derive_key (Cstruct.of_string key) in
    let caveats = M.caveats macaroon in
    let failures = List.map (fun c -> match_caveat t c) caveats
                   |> List.filter filter_opt
                   |> List.map unwrap_opt in
    if List.length failures <> 0 then Error `Not_authorized else
      begin
        (*Verify the signatures *)
        let signature_components = (Cstruct.of_string (M.identifier macaroon)) :: (List.map (fun c -> C.to_cstruct c) caveats) in
        let computed_sig = List.fold_left (fun signature msg -> Crypto.hmac signature msg) derived_key signature_components in
        match (Eqaf_cstruct.equal (M.signature_raw macaroon) computed_sig) with
        | true -> Ok ()
        | false -> Error `Not_authorized
      end
end
