module L = Libmacaroons

let valid = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn"

let valid_deser () =
  (match (L.Macaroon.deserialize valid) with
  | Ok m -> Alcotest.(check bool) "Should be valid" true (L.Macaroon.valid m)
  | Error _e -> Alcotest.fail "Problem deserializing")


let invalid_deser () =
  let str = "aGVsbG8gdGhlcmUK" in
  match L.Macaroon.deserialize str with
  | Ok _ -> Alcotest.fail "Should not deserialize"
  | Error e -> match e with
    | `Invalid -> ()
    | _ -> Alcotest.fail" Should be invalid"


let macaroon_getters () =
  let m = Utils.unwrap_ok @@ L.Macaroon.deserialize valid in
  Alcotest.(check string) "Should have correct location" "http://example.org/" (L.Macaroon.location m);
  Alcotest.(check string) "Should have correct identifier" "keyid" (L.Macaroon.identifier m);
  Alcotest.(check int) "Should have signature" 32 (String.length (L.Macaroon.signature m))


let v =
  let open Alcotest in
  "serializer", [
    test_case "Valid deserialization" `Quick valid_deser;
    test_case "Invalid deserialization" `Quick invalid_deser;
    test_case "Location accessor" `Quick macaroon_getters;
  ]
