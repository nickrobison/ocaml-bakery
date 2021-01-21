let v () =
  let input = "aGVsbG8gdGhlcmUK" in
  let res = Libmacaroons.Base64.decode input in
  Alcotest.(check int) "Should be equal" 12 (Ctypes.CArray.length res);
  Alcotest.(check string) "Should be equal" input (Libmacaroons.Base64.encode res)
