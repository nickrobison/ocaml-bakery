(* Test the Libmacaroons README *)

let key = "this is our super secret key; only we should know it"

module Make(C: Sig.Caveat)(M: Sig.Macaroon with type c = C.t)(V: Sig.Verifier with type m = M.t) = struct

  let macaroonTest = Alcotest.testable M.pp (fun l r -> M.equal l r)

  let t1 () =
    let m = M.create ~id:"we used our secret key" ~location:"http://mybank/" key in
    Alcotest.(check string) "Should have correct ID" "we used our secret key" (M.identifier m);
     Alcotest.(check string) "Should have correct location" "http://mybank/" (M.location m);
    Alcotest.(check int) "Should have no caveats" 0 (M.num_caveats m);
    (*Alcotest.(check string) "Should have correct signature" "e3d9e02908526c4c0039ae15114115d97fdd68bf2ba379b342aaf0f617d0552f" (M.signature m);*)
    Alcotest.(check string) "Should serialize with no caveats" "MDAxY2xvY2F0aW9uIGh0dHA6Ly9teWJhbmsvCjAwMjZpZGVudGlmaWVyIHdlIHVzZWQgb3VyIHNlY3JldCBrZXkKMDAyZnNpZ25hdHVyZSDj2eApCFJsTAA5rhURQRXZf91ovyujebNCqvD2F9BVLwo" (M.serialize m M.V1);
    Alcotest.(check macaroonTest) "Should deserialize with no caveats" m (Utils.unwrap_ok @@ (M.deserialize "MDAxY2xvY2F0aW9uIGh0dHA6Ly9teWJhbmsvCjAwMjZpZGVudGlmaWVyIHdlIHVzZWQgb3VyIHNlY3JldCBrZXkKMDAyZnNpZ25hdHVyZSDj2eApCFJsTAA5rhURQRXZf91ovyujebNCqvD2F9BVLwo"));

    let m2 = M.add_first_party_caveat m (C.create "account = 3735928559") in
    Alcotest.(check int) "Should have a single caveat" 1 (M.num_caveats m2);
    Alcotest.(check string) "Should have new signature" "1efe4763f290dbce0c1d08477367e11f4eee456a64933cf662d79772dbb82128" (M.signature m2);
    Alcotest.(check string) "Should serialize with a single caveat" "MDAxY2xvY2F0aW9uIGh0dHA6Ly9teWJhbmsvCjAwMjZpZGVudGlmaWVyIHdlIHVzZWQgb3VyIHNlY3JldCBrZXkKMDAxZGNpZCBhY2NvdW50ID0gMzczNTkyODU1OQowMDJmc2lnbmF0dXJlIB7-R2PykNvODB0IR3Nn4R9O7kVqZJM89mLXl3LbuCEoCg" (M.serialize m2 M.V1);
    Alcotest.(check macaroonTest) "Should deserialize with caveats" m2 (Utils.unwrap_ok @@ (M.deserialize "MDAxY2xvY2F0aW9uIGh0dHA6Ly9teWJhbmsvCjAwMjZpZGVudGlmaWVyIHdlIHVzZWQgb3VyIHNlY3JldCBrZXkKMDAxZGNpZCBhY2NvdW50ID0gMzczNTkyODU1OQowMDJmc2lnbmF0dXJlIB7-R2PykNvODB0IR3Nn4R9O7kVqZJM89mLXl3LbuCEoCg"));

    (* Add 2 more caveats *)
    let cavs = List.map (fun s -> C.create s) [
        "time < 2020-01-01T00:00";
        "email = alice@example.org";
      ] in
    let m3 = List.fold_left (fun m c -> M.add_first_party_caveat m c) m2 cavs in
    Alcotest.(check int) "Should have 3 caveats" 3 (M.num_caveats m3);
    Alcotest.(check string) "Should have updated signature" "ddf553e46083e55b8d71ab822be3d8fcf21d6bf19c40d617bb9fb438934474b6" (M.signature m3);
    Alcotest.(check macaroonTest) "Should round trip ok" m3 (Utils.unwrap_ok @@ M.deserialize (M.serialize m3 M.V1))


  let verifier_tests () =
    let m = M.create ~id:"we used our secret key" ~location:"http://mybank/" key
    and v = V.create () in
    (match (V.verify v m key) with
     | Ok _ -> ()
     | Error _e -> Alcotest.failf "Should be valid");
    let m2 = M.add_first_party_caveat m (C.create "account = 3735928559") in
    (  match (V.verify v m2 key) with
       | Ok _ -> Alcotest.fail "Should not be valid"
       | Error _ -> ());
    let v = V.satisfy_exact v "account = 3735928559" in
    match v with
    | Error _e -> Alcotest.failf "Cannot add exact caveat: %s" "error"
    | Ok v ->
      match (V.verify v m2 key) with
      | Ok _ -> ()
      | Error e -> match e with
        | `Not_authorized -> ()
        | _ -> Alcotest.fail "Incorrect failure type"

  let v =
    let open Alcotest in
    "readme", [
      test_case "readme" `Quick t1;
      test_case "verifier" `Quick verifier_tests;
    ]

end

