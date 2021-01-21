module L = Libmacaroons


(** Simple test of a Macaroon with an exact caveat verified with the correct root key and verifier *)
let caveat_v1_1 () =
  let v = L.Verifier.create () in
  let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" in
  let m = unwrap_ok @@ L.Macaroon.deserialize str in
  Alcotest.(check bool) "Should be valid" true (L.Verifier.verify v m "this is the key")


let v =
  let open Alcotest in
  "verifier", [
    test_case "caveat_v1_1" `Quick caveat_v1_1;
  ]
