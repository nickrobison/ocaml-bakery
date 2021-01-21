open Ctypes
module M = Libmacaroons_ffi.M
module T = Libmacaroons_types.M

let with_error_code fn =
  let errc = allocate T.return_code Success in
  let result = fn errc in
  match !@ errc with
  | Success -> Ok result
  | e -> Error e
