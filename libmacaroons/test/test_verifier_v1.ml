module L = Libmacaroons

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
  | Error e -> Utils.fail_return_code e


(** Simple test of a macaroon with an exact caveat verified with an incorrect root key and a verifier built for another context*)
let caveat_v1_2 () =
  let v = L.Verifier.create () in
  add_caveat v "account = 0000000000";
  let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" in
  let m = Utils.unwrap_ok @@ L.Macaroon.deserialize str in
  match L.Verifier.verify v m "this is the key" with
  | Ok _ -> Alcotest.fail "Should be unauthorized"
  | Error e -> Utils.expect_variant "Should be unauthorized" `Not_Authorized e


(** Simple test of a macaroon with an exact caveat verified with an incorrect root key and a verifier lacking the correct context*)
let caveat_v1_3 () =
  let v = L.Verifier.create () in
  let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" in
  let m = Utils.unwrap_ok @@ L.Macaroon.deserialize str in
  match L.Verifier.verify v m "this is the key" with
  | Ok _ -> Alcotest.fail "Should be unauthorized"
  | Error e -> Utils.expect_variant "Should be unauthorized" `Not_Authorized e

(** Simple test of a macaroon with two exact caveats verified with the correct root key and verifier*)
let caveat_v1_4 () =
  let v = L.Verifier.create () in
  add_caveat v "account = 3735928559";
  add_caveat v "user = alice";
  let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ERTFZMmxrSUhWelpYSWdQU0JoYkdsalpRb3dNREptYzJsbmJtRjBkWEpsSUV2cFo4MGVvTWF5YTY5cVNwVHVtd1d4V0liYUM2aGVqRUtwUEkwT0VsNzhDZw" in
  let m = Utils.unwrap_ok @@ L.Macaroon.deserialize str in
  match L.Verifier.verify v m "this is the key" with
  | Ok _ -> ()
  | Error e -> Utils.fail_return_code e

(** Sinmple test of a macaroon with two exact caveats verified with the correct root key and and incomplete verifier*)
let caveat_v1_5 () =
  let v = L.Verifier.create () in
  add_caveat v "account = 3735928559";
  let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ERTFZMmxrSUhWelpYSWdQU0JoYkdsalpRb3dNREptYzJsbmJtRjBkWEpsSUV2cFo4MGVvTWF5YTY5cVNwVHVtd1d4V0liYUM2aGVqRUtwUEkwT0VsNzhDZw" in
  let m = Utils.unwrap_ok @@ L.Macaroon.deserialize str in
  match L.Verifier.verify v m "this is the key" with
  | Ok _ -> Alcotest.fail "Should be unauthorized"
  | Error e -> Utils.expect_variant "Should be unauthorized" `Not_Authorized e

(** Simple test of a macaroon with two exact caveats verified with the correct root key and an incomplete verifier*)
let caveat_v1_6 () =
  let v = L.Verifier.create () in
  add_caveat v "user = alice";
  let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ERTFZMmxrSUhWelpYSWdQU0JoYkdsalpRb3dNREptYzJsbmJtRjBkWEpsSUV2cFo4MGVvTWF5YTY5cVNwVHVtd1d4V0liYUM2aGVqRUtwUEkwT0VsNzhDZw" in
  let m = Utils.unwrap_ok @@ L.Macaroon.deserialize str in
  match L.Verifier.verify v m "this is the key" with
  | Ok _ -> Alcotest.fail "Should be unauthorized"
  | Error e -> Utils.expect_variant "Should be unauthorized" `Not_Authorized e



let v =
  let open Alcotest in
  "verifier_v1", [
    test_case "caveat_v1_1" `Quick caveat_v1_1;
    test_case "caveat_v1_2" `Quick caveat_v1_2;
    test_case "caveat_v1_3" `Quick caveat_v1_3;
    test_case "caveat_v1_4" `Quick caveat_v1_4;
    test_case "caveat_v1_5" `Quick caveat_v1_5;
    test_case "caveat_v1_6" `Quick caveat_v1_6;
  ]
