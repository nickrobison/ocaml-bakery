let macaroons_magic_key = Cstruct.of_string "macaroons-key-generator"

let hmac key msg =
  Nocrypto.Hash.SHA256.hmac ~key msg

(* Derives a new root key from [macaroons_magic_key] *)
let derive_key = hmac macaroons_magic_key
