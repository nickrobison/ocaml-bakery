open Ctypes
module M = Libmacaroons_ffi.M
module T = Libmacaroons_types.M

type t = M.Macaroon.t

let valid t =
  match M.validate t with
  | 0 -> true
  | _ -> false

let with_error_code fn =
  let errc = allocate T.return_code Success in
  let result = fn errc in
  match !@ errc with
  | Success -> Ok result
  | e -> Error e


let deserialize str =
  let arry = Base64.decode str in
  let input_length = CArray.length arry |> Unsigned.Size_t.of_int in
  let ptr = CArray.start arry in
  let res = with_error_code @@ M.macaroon_deserialize ptr input_length in
  match res with
  | Ok m ->
    Gc.finalise (fun m -> M.destroy m) m;
    Ok m
  | Error e -> Error e
