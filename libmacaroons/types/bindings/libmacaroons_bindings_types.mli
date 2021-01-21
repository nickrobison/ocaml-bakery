type return_code = Success | OOM | INVALID

module M(F: Ctypes.TYPE): sig

  val return_code: return_code F.typ
end
