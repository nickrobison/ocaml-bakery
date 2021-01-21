type return_code = Success | OOM | INVALID | NOT_AUTHORIZED

module M(F: Ctypes.TYPE): sig

  val return_code: return_code F.typ
end
