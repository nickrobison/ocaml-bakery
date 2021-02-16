type verifier_result = [`Not_authorized | `Invalid ]

module type Caveat = sig
  type t
  val create: string -> t
end

module type Verifier = sig
  type t

  type m

  val create: unit -> t

  val verify: t -> m -> string -> (unit, [> `Not_authorized | `Invalid]) result

  val satisfy_exact: t -> string -> (t, [> `Not_authorized | `Invalid]) result
end


module type Macaroon = sig
  type t

  type c

  type macaroon_format = | V1 | V2 | V2J

  val create: id:string -> location:string -> string -> t

  val identifier: t -> string

  val location: t -> string

  val num_caveats: t -> int

  val signature: t -> string

  val add_first_party_caveat: t -> c -> t

  val serialize: t -> macaroon_format -> string

  val deserialize: string -> (t, string) result

  val pp: Format.formatter -> t -> unit

  val equal: t -> t -> bool
end
