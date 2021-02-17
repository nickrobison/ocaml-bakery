open Ctypes
module T = Libmacaroons_types.M
module M = Libmacaroons_ffi.M

val encode: char carray -> string

val decode: string -> char carray

val deserialize: string -> (M.Macaroon.t, T.ReturnCode.t) result
