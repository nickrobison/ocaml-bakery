module T = Libmacaroons_types.M
module M = Libmacaroons_ffi.M

type t

type m = Macaroon.t

val create: unit -> t

val verify: t -> m -> string -> (unit, [> `Invalid | `Not_authorized]) result

val satisfy_exact: t -> string -> (t, [> `Invalid | `Not_authorized]) result
