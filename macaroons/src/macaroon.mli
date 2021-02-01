type t [@@deriving eq, show]

type macaroon_format = | V1 | V2 | V2J

val create: id:string -> location:string -> string -> t

val identifier: t -> string

val location: t -> string

val signature: t -> string

val signature_raw: t -> Cstruct.t

val num_caveats: t -> int

val add_first_party_caveat: t -> Caveat.t -> t

val serialize: t -> macaroon_format -> string

val deserialize: string -> t
