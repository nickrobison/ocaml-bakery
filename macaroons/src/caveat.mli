type t [@@deriving eq, show]

val create: string -> t

val size: t -> int

val to_cstruct: t -> Cstruct.t

val to_bytes: t -> Bytes.t

val to_string: t -> string
