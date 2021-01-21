open Ctypes

module T = Libmacaroons_types.M

module Macaroon: sig
  type t

  val valid: t -> bool
end

val encode: Unsigned.uchar carray -> string

val decode: string -> Unsigned.uchar carray

val deserialize: string -> (Macaroon.t, T.return_code) result
