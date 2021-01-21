open Ctypes

val encode: Unsigned.uchar carray -> string

val decode: string -> Unsigned.uchar carray
