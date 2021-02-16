module ReturnCode: sig
  type t = [`Success | `Oom | `Invalid | `Not_Authorized | `E of string]
end

type return_code = SUCCESS | OOM | INVALID | NOT_AUTHORIZED

val string_of_return_code: return_code -> string

val return_code_of_string: string -> return_code

module MacaroonFormat: sig
  type t = [`Macaroon_V1 | `Macaroon_V2 | `Macaroon_V2J | `E of string]
end

type macaroon_format = MACAROON_V1 | MACAROON_V2 | MACAROON_V2J

val string_of_macaroon_format: macaroon_format -> string

val macaroon_format_of_string: string -> macaroon_format

module M(F: Ctypes.TYPE): sig

  val return_code: ReturnCode.t F.typ

  val macaroon_format: MacaroonFormat.t F.typ
end
