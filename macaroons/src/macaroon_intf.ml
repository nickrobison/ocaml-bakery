module type C = sig
  type t
  val create: string -> t

  val to_cstruct: t -> Cstruct.t

  val to_bytes: t -> Bytes.t

  val to_string: t -> string

  val pp: Format.formatter -> t -> unit

  val equal: t -> t -> bool

end

module type M = sig
  type t

  type c

  type macaroon_format = | V1 | V2 | V2J

  val create: id:string -> location:string -> string -> t

  val identifier: t -> string

  val location: t -> string

  val num_caveats: t -> int

  val signature: t -> string

  val signature_raw: t -> Cstruct.t

  val add_first_party_caveat: t -> c -> t

  val caveats: t -> c list

  val serialize: t -> macaroon_format -> string

  val deserialize: string -> t

  val pp: Format.formatter -> t -> unit

  val equal: t -> t -> bool
end

module type V = sig
  type t

  type m

  val create: unit -> t

  val verify: t -> m -> string -> (unit, string list) result

  val satisfy_exact: t -> string -> (unit, string) result

  val add_first_party_caveat: t -> string -> t

end

