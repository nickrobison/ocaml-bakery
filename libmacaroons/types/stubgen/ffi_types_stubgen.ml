let prefix = "libmacaroons_stub"

let prologue = "
#include <macaroons.h>
"

let () =
  print_endline prologue;
  Cstubs.Types.write_c Format.std_formatter (module Libmacaroons_bindings_types.M)
