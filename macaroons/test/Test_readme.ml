let t1 () =
  Alcotest.(check string) "Should be ok" "ok" "ok"

let v =
  let open Alcotest in
  "readme", [
    test_case "readme" `Quick t1;
  ]
