open Ctypes

module Macaroon: sig
  type t
end

val encode: Unsigned.uchar carray -> string

val decode: string -> Unsigned.uchar carray

val deserialize: string -> string
