
(** Simple test of a macaroon with no caveats verified with the correct root key*)
let root_v2_1 () =
  Utils.verifier_test "AgETaHR0cDovL2V4YW1wbGUub3JnLwIFa2V5aWQAAAYgfN7nklEcW8b1KEhYBd_psk54XijiqZMB-dcRxgnjjvc" [] Utils.assert_authorized

(** Simple test of a macaroon with no caveats verified with an incorrect root key*)
let root_v2_2 () =
  let str = "AgETaHR0cDovL2V4YW1wbGUub3JnLwIFa2V5aWQAAAYgfN7nklEcW8b1KEhYBd_psk54XijiqZMB-dcRxgnjjvc" in
  let v = Libmacaroons.Verifier.create () in
  Utils.assert_unauthorized (Utils.verify_macaroon v str "this is not the root key")

let v =
  let open Alcotest in
  "root_v2", [
    test_case "root_v2_1" `Quick root_v2_1;
    test_case "root_v2_2" `Quick root_v2_2;
  ]
