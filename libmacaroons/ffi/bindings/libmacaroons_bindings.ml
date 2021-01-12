
module M(F: Ctypes.FOREIGN) =
struct

  let foreign = F.foreign

  let const x = x

  module C = struct
    include Ctypes
    let (@->) = F.(@->)
    let returning = F.returning
  end

  module Base64 = struct

    let b64_ntop = foreign "b64_ntop"C.(string @-> string_opt @-> returning int)

    let b64_pton = foreign "b64_pton"
        C.(const (ptr uchar)
         @-> ptr uchar
         @-> size_t
         @-> returning int)
  end


end
