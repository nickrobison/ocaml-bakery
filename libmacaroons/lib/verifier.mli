type t

val verify: t -> Macaroon.t -> string -> bool
