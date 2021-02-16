
module ReturnCode = struct
  type t = [`Success | `Oom | `Invalid | `Not_Authorized | `E of string]
end



type return_code = SUCCESS | OOM | INVALID | NOT_AUTHORIZED

let return_code_of_string = function
  | "Success" -> SUCCESS
  | "Out of Memory" -> OOM
  | "Invalid" -> INVALID
  | "Not Authorized" -> NOT_AUTHORIZED
  | s -> raise (Invalid_argument (Printf.sprintf "Unexpected return code: %s" s))

let string_of_return_code = function
  | SUCCESS -> "Success"
  | OOM -> "Out of Memory"
  | INVALID -> "Invalid"
  | NOT_AUTHORIZED -> "Not Authorized"

module MacaroonFormat = struct
  type t = [`Macaroon_V1 | `Macaroon_V2 | `Macaroon_V2J | `E of string]
end

type macaroon_format = MACAROON_V1 | MACAROON_V2 | MACAROON_V2J

let macaroon_format_of_string = function
  | "Macaroon_V1" -> MACAROON_V1
  | "Macaroon_V2" -> MACAROON_V2
  | "Macaroon_V2J" -> MACAROON_V2J
  | s -> raise (Invalid_argument (Printf.sprintf "Unsupported format: %s" s))

let string_of_macaroon_format = function
  | MACAROON_V1 -> "Macaroon_V1"
  | MACAROON_V2 -> "Macaroon_V2"
  | MACAROON_V2J -> "Macaroon_V2J"


module M(F: Ctypes.TYPE) = struct

  let enum typedef vals =
    F.enum ~unexpected:(fun i -> `E (Printf.sprintf "Unexpected error code: %d" (Int64.to_int i))) typedef
      (List.map (fun (a,b) -> a, (F.constant ("MACAROON_"^b) F.int64_t)) vals)

  let return_code: ReturnCode.t F.typ =
    enum "macaroon_returncode" [
      `Success, "SUCCESS";
      `Oom, "OUT_OF_MEMORY";
      `Invalid, "INVALID";
      `Not_Authorized, "NOT_AUTHORIZED";
    ]

  let macaroon_format: MacaroonFormat.t F.typ =
    enum "macaroon_format" [
      `Macaroon_V1, "V1";
      `Macaroon_V2, "V2";
      `Macaroon_V2J, "V2J";
    ]
end
