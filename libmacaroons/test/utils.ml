open Libmacaroons

let unwrap_ok = function
  | Ok r -> r
  | Error e -> Alcotest.fail ("Unexpected failure" ^ (Utils.return_code_to_message e))

let expect_variant msg l r =
  Alcotest.(check string) msg (Utils.return_code_to_message l) (Utils.return_code_to_message r)

let fail_return_code e =
  Alcotest.fail (Printf.sprintf "Failed with return code: %s" (Utils.return_code_to_message e))
