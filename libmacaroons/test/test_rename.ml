module L = Libmacaroons

let valid_deser () =
 let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" in
  match (L.Macaroon.deserialize str) with
  | Ok m -> Alcotest.(check bool) "Should be valid" true (L.Macaroon.valid m)
  | Error _e -> Alcotest.fail "Problem deserializing"

let invalid_deser () =
  let str = "aGVsbG8gdGhlcmUK" in
  match L.Macaroon.deserialize str with
  | Ok _ -> Alcotest.fail "Should not deserialize"
  | Error e -> match e with
    | INVALID -> ()
    | _ -> Alcotest.fail" Should be invalid"


let v =
  let open Alcotest in
  "serializer", [
    test_case "Valid deserialization" `Quick valid_deser;
    test_case "Invalid deserialization" `Quick invalid_deser;
  ]
