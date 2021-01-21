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

  module Base64 = struct

    let b64_ntop = foreign "b64_ntop"
        C.(const (ptr uchar) @-> size_t @-> ptr char @-> size_t @-> returning int)

    let b64_pton = foreign "b64_pton"
        C.(const string
         @-> ptr uchar
         @-> size_t
         @-> returning int)
  end

  let macaroon_deserialize =
    foreign "macaroon_deserialize" C.(const (ptr uchar) @-> size_t @-> (ptr T.return_code) @-> returning Macaroon.t)


end
