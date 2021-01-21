module L = Libmacaroons


let unwrap_ok = function
  | Ok r -> r
  | Error _e -> Alcotest.fail "Unexpected failure"

(** Simple test of a Macaroon with an exact caveat verified with the correct root key and verifier *)
let caveat_v1_1 () =
  let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" in
  let _m = unwrap_ok @@ L.Macaroon.deserialize str in
  ()


let v =
  let open Alcotest in
  "verifier", [
    test_case "caveat_v1_1" `Quick caveat_v1_1;
  ]
