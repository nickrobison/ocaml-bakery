module L = Libmacaroons

module T = Libmacaroons_types

let add_caveat v caveat =
  match L.Verifier.satisfy_exact v caveat with
  | Ok _-> ()
  | Error e -> Alcotest.fail ("Could not add caveat" ^ L.Utils.return_code_to_message e)


(** Simple test of a Macaroon with an exact caveat verified with the correct root key and verifier *)
let caveat_v1_1 () =
  let v = L.Verifier.create () in
  add_caveat v "account = 3735928559";
  let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" in
  let m = Utils.unwrap_ok @@ L.Macaroon.deserialize str in
  match L.Verifier.verify v m "this is the key" with
  | Ok _ -> ()
  | Error _ -> Alcotest.fail "I failed with return code"


let caveat_v2_2 () =
  let v = L.Verifier.create () in
  add_caveat v "account = 0000000000";
  let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" in
  let m = Utils.unwrap_ok @@ L.Macaroon.deserialize str in
  match L.Verifier.verify v m "this is the key" with
  | Ok _ -> Alcotest.fail "Should be unauthorized"
  | Error _e -> ()


let v =
  let open Alcotest in
  "verifier", [
    test_case "caveat_v1_1" `Quick caveat_v1_1;
    test_case "caveat_v1_2" `Quick caveat_v2_2;
  ]
