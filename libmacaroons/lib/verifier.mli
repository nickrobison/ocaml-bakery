type t

val create: unit -> t

val verify: t -> Macaroon.t -> string -> bool
