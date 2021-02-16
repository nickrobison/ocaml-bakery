open Ctypes
module M = Libmacaroons_ffi.M
module T = Libmacaroons_types.M

type t = M.Macaroon.t

type c = Caveat.t

type macaroon_format = | V1 | V2 | V2J

let create ~id ~location key =
  let loc = CArray.of_string location in
  let id' = CArray.of_string id in
  let key' = CArray.of_string key in
  let res = Utils.with_error_code @@ M.macaroon_create
      (CArray.start loc)
      (CArray.length loc |> Unsigned.Size_t.of_int)
      (CArray.start key')
      (CArray.length key' |> Unsigned.Size_t.of_int)
      (CArray.start id')
      (CArray.length id' |> Unsigned.Size_t.of_int)
  in
  match res with
  | Ok m -> m
  | Error _e -> raise (Invalid_argument "Cannot create")

let valid t =
  match M.validate t with
  | 0 -> true
  | _ -> false

let unwrap_string fn =
  let start = allocate (ptr char) (from_voidp char null) in
  let loc_sz = allocate size_t (Unsigned.Size_t.of_int 0) in
  fn start loc_sz;
  string_from_ptr !@start ~length:((Unsigned.Size_t.to_int !@loc_sz) - 1)

let deserialize str =
  let arry = Base64.decode str in
  let input_length = CArray.length arry |> Unsigned.Size_t.of_int in
  let ptr = CArray.start arry in
  let res = Utils.with_error_code @@ M.macaroon_deserialize ptr input_length in
  match res with
  | Ok m ->
    Gc.finalise (fun m -> M.destroy m) m;
    Ok m
  | Error e -> Error (Utils.return_code_to_message e)

let location t =
  unwrap_string @@ M.location t

let identifier t =
  unwrap_string @@ M.identifier t

let signature t =
  let start = allocate (ptr char) (from_voidp char null) in
  let sz = allocate size_t (Unsigned.Size_t.of_int 0) in
  M.signature t start sz;
  let arry = CArray.make char ((Unsigned.Size_t.to_int !@sz) * 2) in
  M.bin2hex !@start !@sz (CArray.start arry);
  string_from_ptr (CArray.start arry) ~length:(CArray.length arry)

let pp _fmt _t =
  ()

let equal _lhs _rhs =
  true

let num_caveats _t = 0

let add_first_party_caveat t _cav = t

let serialize t format =
  let fmt = match format with
    | V1 -> `Macaroon_V1
    | V2 -> `Macaroon_V2
    | V2J -> `Macaroon_V2J
  in
  let sz_hint = M.macaroon_serialize_size_hint t fmt in
  let start = allocate_n char ~count:(Unsigned.Size_t.to_int sz_hint) in
  let serialized = Utils.with_error_code @@ M.macaroon_serialize t fmt start sz_hint in
  match serialized with
  | Ok sz -> string_from_ptr start ~length:(Unsigned.Size_t.to_int sz)
  | Error _e -> raise (Invalid_argument "bad")

