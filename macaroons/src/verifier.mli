type t

val create: unit -> t

val add_first_party_caveat: t -> string -> t

val verify: t -> Macaroon.t -> string -> (unit, string list) result
