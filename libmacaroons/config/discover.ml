module C = Configurator.V1

let () =
  let cstubs = ref "" in
  let args = Arg.["-cstubs", Set_string cstubs, "cstubs loc"] in
  C.main ~args ~name:"libmacaroons" (fun _ ->
      let cstubs_cflags = Printf.sprintf "-I%s" (Filename.dirname !cstubs) in
      C.Flags.write_lines "ctypes-cflags" [cstubs_cflags]
    )
