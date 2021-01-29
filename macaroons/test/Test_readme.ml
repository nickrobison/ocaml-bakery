open Bakery_macaroons

let t1 () =
  let m = Macaroon.create ~id:"we used our secret key" ~location:"http://mybank/" "this is our super secret key; only we should know it" in
  Alcotest.(check string) "Should have correct ID" "we used our secret key" (Macaroon.identifier m);
  Alcotest.(check string) "Should have correct location" "http://mybank/" (Macaroon.location m);
  Alcotest.(check int) "Should have no caveats" 0 (Macaroon.num_caveats m);
  Alcotest.(check string) "Should have correct signature" "e3d9e02908526c4c0039ae15114115d97fdd68bf2ba379b342aaf0f617d0552f" (Macaroon.signature m);

  let m2 = Macaroon.add_first_party_caveat m (Caveat.create "account = 3735928559") in
  Alcotest.(check int) "Should have a single caveat" 1 (Macaroon.num_caveats m2);
  Alcotest.(check string) "Should have new signature" "1efe4763f290dbce0c1d08477367e11f4eee456a64933cf662d79772dbb82128" (Macaroon.signature m2);

  (* Add 2 more caveats *)
  let cavs = List.map (fun s -> Caveat.create s) [
      "time < 2020-01-01T00:00";
      "email = alice@example.org";
    ] in
  let m3 = List.fold_left (fun m c -> Macaroon.add_first_party_caveat m c) m2 cavs in
  Alcotest.(check int) "Should have 3 caveats" 3 (Macaroon.num_caveats m3);
  Alcotest.(check string) "Should have updated signature" "ddf553e46083e55b8d71ab822be3d8fcf21d6bf19c40d617bb9fb438934474b6" (Macaroon.signature m3)



let v =
  let open Alcotest in
  "readme", [
    test_case "readme" `Quick t1;
  ]
