open Ctypes
module T = Libmacaroons_types.M
module M = Libmacaroons_ffi.M

val encode: Unsigned.uchar carray -> string

val decode: string -> Unsigned.uchar carray

val deserialize: string -> (M.Macaroon.t, T.ReturnCode.t) result
