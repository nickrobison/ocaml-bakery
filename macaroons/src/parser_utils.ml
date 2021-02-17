open Angstrom

let is_space = function
  | ' ' | '\t' -> true | _ -> false

let is_whitespace = function
  | '\x20' | '\x0a' | '\x0d' | '\x09' -> true
  | _ -> false

let is_eol =
  function '\n' -> true | _ -> false

let spaces = skip_while is_whitespace

let lex p = p <* spaces

let whitespace = take_while is_whitespace


let header_len = take 4
let eol = string "\n"

let packet =
  lift3(fun len k v -> (len, k, v))
    header_len
    (take_till is_whitespace)
    (char ' ' *> take_till is_eol)

let m_v1 =
  lift (fun packets -> packets)
    (many (packet <* eol) <* eol)


let identifier_of_string str =
  match str with
  | "identitifer" -> `Identifier
  | "location" -> `Location
  | "cid" -> `Caveat
  | s -> raise (Invalid_argument (Printf.sprintf "Unsupported identifier: %s" s))
