open Ctypes
module M = Libmacaroons_ffi.M
module T = Libmacaroons_types.M

let with_error_code fn =
  let errc = allocate T.return_code SUCCESS in
  let result = fn errc in
  match !@ errc with
  | SUCCESS -> Ok result
  | e -> Error e
