module C = Configurator.V1

let ocamlopt_lines c =
  let cflags =
    try C.ocaml_config_var_exn c "ocamlopt_cflags"
    with _ -> "-O3 -fno-strict-aliasing -fwrapv" in
  let cflags = cflags ^ " -msse4.1" in
  C.Flags.extract_blank_separated_words cflags

let libutil_lines c =
  let system = C.ocaml_config_var_exn c "system" in
  match system with
  | "macosx" -> ["-DHAVE_OSX_LIBUTIL_H"]
  | "linux" -> ["-DHAVE_BSD_LIBUTIL_H"]
  | s -> raise (Invalid_argument (Printf.sprintf "Unsupported system: %s" s))

let () =
  let cstubs = ref "" in
  let args = Arg.["-cstubs", Set_string cstubs, "cstubs loc"] in
  C.main ~args ~name:"libmacaroons" (fun c ->
      let cstubs_cflags = Printf.sprintf "-I%s" (Filename.dirname !cstubs) in
      let lines = ocamlopt_lines c @ libutil_lines c in
      C.Flags.write_lines "cflags" lines;
      C.Flags.write_lines "ctypes-cflags" [cstubs_cflags]
    )
