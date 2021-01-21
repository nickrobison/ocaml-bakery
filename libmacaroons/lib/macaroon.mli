module M = Libmacaroons_ffi.M
module T = Libmacaroons_types.M

type t = M.Macaroon.t

val deserialize: string -> (t, T.return_code) result

val valid: t -> bool
