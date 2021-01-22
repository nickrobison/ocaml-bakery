
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
end
