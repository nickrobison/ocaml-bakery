open Alcotest
open Libmacaroons

module R = Macaroons_tester.Readme_test.Make(Caveat)(Macaroon)(Verifier)

let () =
  run "Unit tests" [
    "base64", [
      test_case "Base64" `Quick Test_b64.v
    ];
    Test_verifier_v2.v;
    Test_root_v2.v;
    Test_serialize.v;
    R.v;
  ]
