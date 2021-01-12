let v () =
  let input = "aGVsbG8gdGhlcmUK" in
  let res = Libmacaroons.decode input in
  Alcotest.(check int) "Should be equal" 12 (Ctypes.CArray.length res);
  Alcotest.(check string) "Should be equal" input (Libmacaroons.encode res)
