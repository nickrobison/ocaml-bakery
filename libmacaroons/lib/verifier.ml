open Ctypes
module M = Libmacaroons_ffi.M
module T = Libmacaroons_types.M

type t = M.Verifier.t

type m = M.Macaroon.t


let create () =
  let v = M.verifier_create () in
  Gc.finalise (fun v -> M.verifier_destroy v) v;
  v

let verify t m key =
  let ms = allocate_n M.Macaroon.t ~count:0 in
  let ms_size = Unsigned.Size_t.of_int 0 in
  let key' = CArray.of_string key in
  let key_size = Unsigned.Size_t.of_int @@ String.length key in
  print_endline (Printf.sprintf "Key: `%s`. Size: %d" key (String.length key));
  let res = Utils.with_error_code @@ M.verify_macaroon t m (CArray.start key') key_size ms ms_size in
  match res with
  | Ok _ -> Ok ()
  | Error _e -> Error `Invalid

let satisfy_exact t caveat =
  let caveat' = CArray.of_string caveat in
  let caveat_size = Unsigned.Size_t.of_int @@ String.length caveat in
  let res = Utils.with_error_code @@ M.verify_add_exact t (CArray.start caveat') caveat_size in
  match res with
  | Ok _ -> Ok t
  | Error _e -> Error `Invalid
