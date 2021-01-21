open Ctypes
module M = Libmacaroons_ffi.M

type t = M.Verifier.t

let create () =
  let v = M.verifier_create () in
  Gc.finalise (fun v -> M.verifier_destroy v) v;
  v

let verify t m key =
  let ms = allocate_n M.Macaroon.t ~count:0 in
  let ms_size = Unsigned.Size_t.of_int 0 in
  let key' = CArray.of_string key in
  let key_size = CArray.length key' |> Unsigned.Size_t.of_int in
  let res = Utils.with_error_code @@ M.verify_macaroon t m (CArray.start key') key_size ms ms_size in
  match res with
  | Ok s ->
    print_int s;
    true
  | Error _e -> false
