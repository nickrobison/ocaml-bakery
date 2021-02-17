let valid = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn"



module Make(C: Sig.Caveat)(M: Sig.Macaroon with type c = C.t)(V: Sig.Verifier with type m = M.t) = struct

  let valid_deser () =
    (match (M.deserialize valid) with
     | Ok m -> Alcotest.(check bool) "Should be valid" true (M.valid m)
     | Error _e -> Alcotest.fail "Problem deserializing")


  let invalid_deser () =
    let str = "aGVsbG8gdGhlcmUK" in
    match M.deserialize str with
    | Ok _ -> Alcotest.fail "Should not deserialize"
    | Error e -> match e with
      | "Invalid Macaroon" -> ()
      | e -> Alcotest.failf "Should be invalid %s" e


  let macaroon_getters () =
    let deser = M.deserialize valid in
    match deser with
    | Ok m ->
      Alcotest.(check string) "Should have correct location" "http://example.org/" (M.location m);
      Alcotest.(check string) "Should have correct identifier" "keyid" (M.identifier m);
      Alcotest.(check int) "Should have signature" 64 (String.length (M.signature m))
    | Error e -> Alcotest.fail e

  let v =
    let open Alcotest in
    "serializer", [
      test_case "Valid deserialization" `Quick valid_deser;
      test_case "Invalid deserialization" `Quick invalid_deser;
      test_case "Test accessors" `Quick macaroon_getters;
    ]
end
