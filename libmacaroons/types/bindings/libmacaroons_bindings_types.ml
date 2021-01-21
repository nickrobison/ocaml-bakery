type return_code = Success | OOM | INVALID | NOT_AUTHORIZED

module M(F: Ctypes.TYPE) = struct

  let success= F.constant "MACAROON_SUCCESS" F.int64_t
  let oom = F.constant "MACAROON_OUT_OF_MEMORY" F.int64_t
  let invalid = F.constant "MACAROON_INVALID" F.int64_t
  let unauthorized = F.constant "MACAROON_NOT_AUTHORIZED" F.int64_t

  let return_code = F.enum "macaroon_returncode" [
      Success, success;
      OOM, oom;
      INVALID, invalid;
      NOT_AUTHORIZED, unauthorized;
    ] ~unexpected:(fun code -> raise (Invalid_argument (Printf.sprintf "Unexpected error code %d" (Int64.to_int code))))
end
