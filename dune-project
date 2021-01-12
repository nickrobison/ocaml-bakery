(lang dune 2.7)
(name bakery)
(version 0.1.0)

(generate_opam_files true)

(source (github nickrobison-usds/ocaml-bakery))
(license MIT)
(authors "Nick Robison")
(maintainers "nicholas.a.robison@omb.eop.gov")

(package
  (name bakery)
  (synopsis "")
  (depends
    (dune (> 1.5))
    (alcotest :with_test)
    (crowbar :with_test)
    (ocaml (> 4.07))))

(package
  (name libmacaroons)
  (synopsis "OCaml bindings to libmacaroons")
  (depends
    ctypes
    (base64 :with_test)))
