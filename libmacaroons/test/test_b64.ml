let v () =
  let b64 = Libmacaroons.b64_of_string "hello" in
  Alcotest.(check string) "Should roundtrip ok" b64 (Libmacaroons.b64_to_string b64)
