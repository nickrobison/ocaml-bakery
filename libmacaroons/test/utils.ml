open Libmacaroons

(** Unwrap a Result and assert that it's Ok. Otherwise, fail with return code*)
let unwrap_ok = function
  | Ok r -> r
  | Error e -> Alcotest.failf "Unexpected failure: %s" (Utils.return_code_to_message e)

(** Alcotest check function that verifies a Polymorphic variant matches what's expected*)
let expect_variant msg l r =
  Alcotest.(check string) msg (Utils.return_code_to_message l) (Utils.return_code_to_message r)

(** Fail a test with a nice error message from the resulting return code*)
let fail_return_code e =
  Alcotest.failf "Failed with return code: %s" (Utils.return_code_to_message e)

(** Helper function for adding a caveat to a verifier*)
let add_caveat v caveat =
  match Verifier.satisfy_exact v caveat with
  | Ok _-> ()
  | Error e -> Alcotest.failf "Could not add caveat: %s" (Utils.return_code_to_message e)


(** Assert that the result of a macaroon verification is unauthorized*)
let assert_unauthorized = function
  | Ok _ -> Alcotest.fail "Should be unauthorized"
  | Error e -> expect_variant "Should be unauthorized" `Not_Authorized e

(** Helper function to deserialize a macaroon and verify it with the default root key*)
let verify_macaroon v str k =
  let m = unwrap_ok @@ Macaroon.deserialize str in
  Verifier.verify v m k

(** Assert that the result of a macaroon verification is authorized*)
let assert_authorized = function
  | Ok _ -> ()
  | Error e -> fail_return_code e

(** Run libmacaroons verification test*)
let verifier_test m caveats fn =
  let v = List.fold_left (fun v c -> add_caveat v c; v) (Verifier.create ()) caveats in
  fn (verify_macaroon v m "this is the key")
