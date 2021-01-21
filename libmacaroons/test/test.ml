open Alcotest

let () =
  run "Unit tests" [
    "base64", [
      test_case "Base64" `Quick Test_b64.v
    ];
    Test_serialize.v;
    Test_verifier.v;
  ]
