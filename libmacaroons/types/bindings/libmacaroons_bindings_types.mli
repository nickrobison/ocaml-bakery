type return_code = SUCCESS | OOM | INVALID | NOT_AUTHORIZED

val string_of_return_code: return_code -> string

val return_code_of_string: string -> return_code

module M(F: Ctypes.TYPE): sig

  val return_code: return_code F.typ
end
