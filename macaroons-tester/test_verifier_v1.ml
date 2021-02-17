
module Make(C: Sig.Caveat)(M: Sig.Macaroon with type c = C.t)(V: Sig.Verifier with type m = M.t) = struct

  module Utils = Utils.Make(C)(M)(V)

  (** Simple test of a Macaroon with an exact caveat verified with the correct root key and verifier *)
  let caveat_v1_1 () =
    Utils.verifier_test "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" [
      "account = 3735928559"
    ] Utils.assert_authorized

  (** Simple test of a macaroon with an exact caveat verified with an incorrect root key and a verifier built for another context*)
  let caveat_v1_2 () =
    Utils.verifier_test "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" [
      "account = 0000000000"
    ] Utils.assert_unauthorized

  (** Simple test of a macaroon with an exact caveat verified with an incorrect root key and a verifier lacking the correct context*)
  let caveat_v1_3 () =
    Utils.verifier_test "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ESm1jMmxuYm1GMGRYSmxJUFZJQl9iY2J0LUl2dzl6QnJPQ0pXS2pZbE05djNNNXVtRjJYYVM5SloySENn" [] Utils.assert_unauthorized

  (** Simple test of a macaroon with two exact caveats verified with the correct root key and verifier*)
  let caveat_v1_4 () =
    Utils.verifier_test "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ERTFZMmxrSUhWelpYSWdQU0JoYkdsalpRb3dNREptYzJsbmJtRjBkWEpsSUV2cFo4MGVvTWF5YTY5cVNwVHVtd1d4V0liYUM2aGVqRUtwUEkwT0VsNzhDZw" [
      "account = 3735928559";
      "user = alice";
    ] Utils.assert_authorized

  (** Sinmple test of a macaroon with two exact caveats verified with the correct root key and and incomplete verifier*)
  let caveat_v1_5 () =
    Utils.verifier_test "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ERTFZMmxrSUhWelpYSWdQU0JoYkdsalpRb3dNREptYzJsbmJtRjBkWEpsSUV2cFo4MGVvTWF5YTY5cVNwVHVtd1d4V0liYUM2aGVqRUtwUEkwT0VsNzhDZw" [
      "account = 3735928559"
    ] Utils.assert_unauthorized

  (** Simple test of a macaroon with two exact caveats verified with the correct root key and an incomplete verifier*)
  let caveat_v1_6 () =
    Utils.verifier_test "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeFpHTnBaQ0JoWTJOdmRXNTBJRDBnTXpjek5Ua3lPRFUxT1Fvd01ERTFZMmxrSUhWelpYSWdQU0JoYkdsalpRb3dNREptYzJsbmJtRjBkWEpsSUV2cFo4MGVvTWF5YTY5cVNwVHVtd1d4V0liYUM2aGVqRUtwUEkwT0VsNzhDZw" [
      "user = alice"
    ] Utils.assert_unauthorized

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
end
