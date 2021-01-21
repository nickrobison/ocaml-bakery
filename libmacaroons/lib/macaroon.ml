open Ctypes
module M = Libmacaroons_ffi.M
module T = Libmacaroons_types.M

type t = M.Macaroon.t

let valid t =
  match M.validate t with
  | 0 -> true
  | _ -> false

let unwrap_string fn =
  let start = allocate (ptr char) (from_voidp char null) in
  let loc_sz = allocate size_t (Unsigned.Size_t.of_int 0) in
  fn start loc_sz;
  print_int (Unsigned.Size_t.to_int !@loc_sz);
  string_from_ptr !@start ~length:(Unsigned.Size_t.to_int !@loc_sz)

let deserialize str =
  let arry = Base64.decode str in
  let input_length = CArray.length arry |> Unsigned.Size_t.of_int in
  let ptr = CArray.start arry in
  let res = Utils.with_error_code @@ M.macaroon_deserialize ptr input_length in
  match res with
  | Ok m ->
    Gc.finalise (fun m -> M.destroy m) m;
    Ok m
  | Error e -> Error e

let location t =
  unwrap_string @@ M.location t

let identifier t =
    unwrap_string @@ M.identifier t

let signature t =
  unwrap_string @@ M.signature t
