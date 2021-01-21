open Ctypes
module M = Libmacaroons_ffi.M
module T = Libmacaroons_types.M

module Macaroon = struct
  type t = M.Macaroon.t

  let valid t =
    match M.validate t with
    | 0 -> true
    | _ -> false
end

let with_error_code fn =
  let errc = allocate T.return_code Success in
  let result = fn errc in
  match !@ errc with
  | Success -> Ok result
  | e -> Error e

let encode arry =
  let input_length  = CArray.length arry in
  let ret_buffer = allocate_n char ~count:(input_length * 2) in
  let ret_sz = Unsigned.Size_t.of_int (input_length * 2) in
  let res = M.Base64.b64_ntop (CArray.start arry) (Unsigned.Size_t.of_int input_length) ret_buffer ret_sz in
  string_from_ptr ret_buffer ~length:res

let decode str =
  let ret_sz = Unsigned.Size_t.of_int (String.length str) in
  let ret_buffer = allocate_n uchar ~count:(String.length str) in
  let res = M.Base64.b64_pton str ret_buffer ret_sz in
  CArray.from_ptr ret_buffer res

let deserialize str =
  let arry = decode str in
  let input_length = CArray.length arry |> Unsigned.Size_t.of_int in
  let ptr = CArray.start arry in
  let res = with_error_code @@ M.macaroon_deserialize ptr input_length in
  match res with
  | Ok m ->
    Gc.finalise (fun m -> M.destroy m) m;
    Ok m
  | Error e -> Error e
