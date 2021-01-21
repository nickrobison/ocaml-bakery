module M = Libmacaroons_ffi.M

type t = M.Verifier.t

let verify _t _macaroon _key =
  true
