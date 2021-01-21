open Alcotest

let () =
  run "Unit tests" [
    "base64", [
      test_case "Base64" `Quick Test_b64.v
    ];
      "verifier", [
      test_case "Verifier" `Quick Test_verifier.v
    ]
  ]
