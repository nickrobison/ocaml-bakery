open Bakery_macaroons

let key = "this is our super secret key; only we should know it"

let macaroonTest = Alcotest.testable Macaroon.pp (fun l r -> Macaroon.equal l r)

let t1 () =
  let m = Macaroon.create ~id:"we used our secret key" ~location:"http://mybank/" key in
  Alcotest.(check string) "Should have correct ID" "we used our secret key" (Macaroon.identifier m);
  Alcotest.(check string) "Should have correct location" "http://mybank/" (Macaroon.location m);
  Alcotest.(check int) "Should have no caveats" 0 (Macaroon.num_caveats m);
  Alcotest.(check string) "Should have correct signature" "e3d9e02908526c4c0039ae15114115d97fdd68bf2ba379b342aaf0f617d0552f" (Macaroon.signature m);
  Alcotest.(check string) "Should serialize with no caveats" "MDAxY2xvY2F0aW9uIGh0dHA6Ly9teWJhbmsvCjAwMjZpZGVudGlmaWVyIHdlIHVzZWQgb3VyIHNlY3JldCBrZXkKMDAyZnNpZ25hdHVyZSDj2eApCFJsTAA5rhURQRXZf91ovyujebNCqvD2F9BVLwo" (Macaroon.serialize m Macaroon.V1);
  Alcotest.(check macaroonTest) "Should deserialize with no caveats" m (Macaroon.deserialize "MDAxY2xvY2F0aW9uIGh0dHA6Ly9teWJhbmsvCjAwMjZpZGVudGlmaWVyIHdlIHVzZWQgb3VyIHNlY3JldCBrZXkKMDAyZnNpZ25hdHVyZSDj2eApCFJsTAA5rhURQRXZf91ovyujebNCqvD2F9BVLwo");

  let m2 = Macaroon.add_first_party_caveat m (Caveat.create "account = 3735928559") in
  Alcotest.(check int) "Should have a single caveat" 1 (Macaroon.num_caveats m2);
  Alcotest.(check string) "Should have new signature" "1efe4763f290dbce0c1d08477367e11f4eee456a64933cf662d79772dbb82128" (Macaroon.signature m2);
  Alcotest.(check string) "Should serialize with a single caveat" "MDAxY2xvY2F0aW9uIGh0dHA6Ly9teWJhbmsvCjAwMjZpZGVudGlmaWVyIHdlIHVzZWQgb3VyIHNlY3JldCBrZXkKMDAxZGNpZCBhY2NvdW50ID0gMzczNTkyODU1OQowMDJmc2lnbmF0dXJlIB7-R2PykNvODB0IR3Nn4R9O7kVqZJM89mLXl3LbuCEoCg" (Macaroon.serialize m2 Macaroon.V1);
  Alcotest.(check macaroonTest) "Should deserialize with caveats" m2 (Macaroon.deserialize "MDAxY2xvY2F0aW9uIGh0dHA6Ly9teWJhbmsvCjAwMjZpZGVudGlmaWVyIHdlIHVzZWQgb3VyIHNlY3JldCBrZXkKMDAxZGNpZCBhY2NvdW50ID0gMzczNTkyODU1OQowMDJmc2lnbmF0dXJlIB7-R2PykNvODB0IR3Nn4R9O7kVqZJM89mLXl3LbuCEoCg");

  (* Add 2 more caveats *)
  let cavs = List.map (fun s -> Caveat.create s) [
      "time < 2020-01-01T00:00";
      "email = alice@example.org";
    ] in
  let m3 = List.fold_left (fun m c -> Macaroon.add_first_party_caveat m c) m2 cavs in
  Alcotest.(check int) "Should have 3 caveats" 3 (Macaroon.num_caveats m3);
  Alcotest.(check string) "Should have updated signature" "ddf553e46083e55b8d71ab822be3d8fcf21d6bf19c40d617bb9fb438934474b6" (Macaroon.signature m3);
  Alcotest.(check macaroonTest) "Should round trip ok" m3 (Macaroon.deserialize (Macaroon.serialize m3 Macaroon.V1))


let verifier_tests () =
  let m = Macaroon.create ~id:"we used our secret key" ~location:"http://mybank/" key
  and v = Verifier.create () in
  (match (Verifier.verify v m key) with
   | Ok _ -> ()
   | Error _e -> Alcotest.failf "Should be valid");
  let m2 = Macaroon.add_first_party_caveat m (Caveat.create "account = 3735928559") in
  (  match (Verifier.verify v m2 key) with
     | Ok _ -> Alcotest.fail "Should not be valid"
     | Error _ -> ());
  let v = Verifier.add_first_party_caveat v "account = 3735928559" in
  match (Verifier.verify v m2 key) with
  | Ok _ -> ()
  | Error e -> Alcotest.(check (list string)) "Should have correct failure message" [] e

let v =
  let open Alcotest in
  "readme", [
    test_case "readme" `Quick t1;
    test_case "verifier" `Quick verifier_tests;
  ]
