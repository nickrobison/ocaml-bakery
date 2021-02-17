
module Make (C: Sig.Caveat)(M: Sig.Macaroon with type c = C.t)(V: Sig.Verifier with type m = M.t) = struct

  module R = Readme_test.Make(C)(M)(V)
  module S = Test_serialize.Make(C)(M)(V)
  module R1 = Test_root_v1.Make(C)(M)(V)
  module V1 = Test_verifier_v1.Make(C)(M)(V)

  let simple_test () =
    Alcotest.(check string) "Pass" "Hello" "Hello"


  let v () =
    let open Alcotest in
    run "Macaroon Test Harness" [
      "simple", [
        test_case "Simple" `Quick simple_test
      ];
      R.v;
      (*S.v;*)
      R1.v;
      V1.v;
    ]
end

