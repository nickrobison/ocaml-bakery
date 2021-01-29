open Bakery_macaroons

let t1 () =
  let m = Macaroon.create ~id:"we used our secret key" ~location:"http://mybank/" "this is our super secret key; only we should know it" in
  Alcotest.(check string) "Should have correct ID" "we used our secret key" (Macaroon.identifier m);
  Alcotest.(check string) "Should have correct location" "http://mybank/" (Macaroon.location m);
  Alcotest.(check string) "Should have correct signature" "e3d9e02908526c4c0039ae15114115d97fdd68bf2ba379b342aaf0f617d0552f" (Macaroon.signature m)



let v =
  let open Alcotest in
  "readme", [
    test_case "readme" `Quick t1;
  ]
