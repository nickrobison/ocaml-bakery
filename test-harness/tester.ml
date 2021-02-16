
module Make (C: Sig.Caveat)(M: Sig.Macaroon with type c = C.t)(V: Sig.Verifier with type m = M.t) = struct

  module R = Readme_test.Make(C)(M)(V)

  let simple_test () =
    Alcotest.(check string) "Pass" "Hello" "Hello"


  let v () =
    let open Alcotest in
    run "Macaroon Test Harness" [
      "simple", [
        test_case "Simple" `Quick simple_test
      ];
      R.v
    ]
end

