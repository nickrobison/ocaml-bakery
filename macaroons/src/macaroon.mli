type t

val create: id:string -> location:string -> string -> t

val identifier: t -> string

val location: t -> string

val signature: t -> string
