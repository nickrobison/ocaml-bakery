module T = Libmacaroons_types.M

module M(F: Ctypes.FOREIGN) =
struct

  let foreign = F.foreign

  let const x = x

  module C = struct
    include Ctypes
    let (@->) = F.(@->)
    let returning = F.returning
  end

  module Macaroon = struct
    type t = unit C.ptr
    let t: t C.typ = C.ptr C.void
  end

  module Verifier = struct
    type t = unit C.ptr
    let t: t C.typ = C.ptr C.void
  end

  module Base64 = struct

    let b64_ntop = foreign "b64_ntop"
        C.(const (ptr char) @-> size_t @-> ptr char @-> size_t @-> returning int)

    let b64_pton = foreign "b64_pton"
        C.(const string
           @-> ptr char
           @-> size_t
           @-> returning int)
  end

  (* Macaroon management methods *)

  let macaroon_create =
    foreign "macaroon_create" C.(ptr char @-> size_t @-> ptr char @-> size_t @-> ptr char @-> size_t @-> ptr T.return_code @-> returning Macaroon.t)

  let destroy =
    foreign "macaroon_destroy" C.(Macaroon.t @-> returning void)

  let validate =
    foreign "macaroon_validate" C.(Macaroon.t @-> returning int)

  let location =
    foreign "macaroon_location" C.(Macaroon.t @-> ptr (ptr char) @-> ptr size_t @-> returning void)

  let identifier =
    foreign "macaroon_identifier" C.(Macaroon.t @-> ptr (ptr char) @-> ptr size_t @-> returning void)

  let signature = foreign "macaroon_signature" C.(Macaroon.t @-> ptr (ptr char) @-> ptr size_t @-> returning void)

  (* Verifier methods *)

  let verifier_create =
    foreign "macaroon_verifier_create" C.(void @-> returning Verifier.t)

  let verifier_destroy =
    foreign "macaroon_verifier_destroy" C.(Verifier.t @-> returning void)

  let macaroon_equal =
    foreign "macaroon_cmp" C.(Macaroon.t @-> Macaroon.t @-> returning int)

  let macaroon_inspect_size =
    foreign "macaroon_inspect_size_hint" C.(Macaroon.t @-> returning size_t)

  let macaroon_inspect =
    foreign "macaroon_inspect" C.(Macaroon.t @-> ptr char @-> size_t @-> ptr T.return_code @-> returning int)

  let verify_macaroon =
    foreign "macaroon_verify" C.(const Verifier.t @-> const Macaroon.t @-> const (ptr char) @-> size_t @-> ptr Macaroon.t @-> size_t @-> (ptr T.return_code) @-> returning int)

  let verify_add_exact =
    foreign "macaroon_verifier_satisfy_exact" C.(Verifier.t @-> const (ptr char) @-> size_t @-> (ptr T.return_code) @-> returning int)


  (* Serialize/Deserialize *)
  let macaroon_deserialize =
    foreign "macaroon_deserialize" C.(const (ptr char) @-> size_t @-> (ptr T.return_code) @-> returning Macaroon.t)

  let macaroon_serialize_size_hint =
    foreign "macaroon_serialize_size_hint" C.(const Macaroon.t @-> T.macaroon_format @-> returning size_t)

  let macaroon_serialize =
    foreign "macaroon_serialize" C.(const Macaroon.t @-> T.macaroon_format @-> (ptr char) @-> size_t @-> ptr T.return_code @-> returning size_t)

  let bin2hex =
    foreign "macaroon_bin2hex" C.(const (ptr char) @-> size_t @-> ptr char @-> returning void)

  let hex2bin =
    foreign "macaroon_hex2bin" C.(const (ptr char) @-> size_t @-> ptr char @-> returning void)

end
