open Alcotest
open Libmacaroons

module T = Macaroons_tester.Tester.Make(Caveat)(Macaroon)(Verifier)

let () =
  run "Unit tests" [
    "base64", [
      test_case "Base64" `Quick Test_b64.v
    ];
    Test_verifier_v2.v;
    Test_root_v2.v;
    Test_serialize.v;
  ]
