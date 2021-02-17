module M = Libmacaroons_ffi.M
module T = Libmacaroons_types.M

type t = M.Macaroon.t

type c = Caveat.t

type macaroon_format = | V1 | V2 | V2J

val create: id:string -> location:string -> string -> t

val deserialize: string -> (t, string) result

val valid: t -> bool

val location: t -> string

val identifier: t -> string

val add_first_party_caveat: t -> c -> t

val num_caveats: t -> int

val signature: t -> string

val equal: t -> t -> bool

val pp : Format.formatter -> t -> unit

val serialize: t -> macaroon_format -> string
