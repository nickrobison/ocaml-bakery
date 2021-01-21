type return_code = Success | OOM

module M(F: Ctypes.TYPE) = struct

  let success= F.constant "MACAROON_SUCCESS" F.int64_t
  let oom = F.constant "MACAROON_OUT_OF_MEMORY" F.int64_t

  let return_code = F.enum "macaroon_returncode" [
      Success, success;
      OOM, oom;
    ] ~unexpected:(fun _ -> raise (Invalid_argument "unexpected error code"))
end
