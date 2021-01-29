type t

val create: id:string -> location:string -> string -> t

val identifier: t -> string

val location: t -> string

val signature: t -> string

val num_caveats: t -> int

val add_first_party_caveat: t -> Caveat.t -> t
