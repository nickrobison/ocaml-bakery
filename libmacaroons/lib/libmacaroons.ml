module T = Libmacaroons_ffi.M

let b64_to_string str =
  let output = None in
  let _ = T.Base64.b64_ntop str output in
  match output with
  | None -> ""
  | Some x -> x

let b64_of_string str =
  str
