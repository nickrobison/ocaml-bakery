let prefix = "libmacaroons_c_stubs"

let prologue = "
  #include <macaroons.h>
  #include <base64.h>
"


let () =
  let generate_ml, generate_c = ref false, ref false in
  let () =
    Arg.(parse [( "-ml", Set generate_ml, "Generate ML");
                ("-c", Set generate_c, "Generate C")])
      (fun _ -> failwith "unexpected anonymous argument")
      "stubgen [-ml|-c]"
  in
  match !generate_ml, !generate_c with
  | false, false
  | true, true ->
    failwith "Exactly one of -ml and -c must be specified"
  | true, false ->
    Cstubs.write_ml Format.std_formatter ~prefix (module Libmacaroons_bindings.M)
  | false, true ->
    print_endline prologue;
    Cstubs.write_c Format.std_formatter ~prefix (module Libmacaroons_bindings.M)
