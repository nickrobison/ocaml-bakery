
(** Simple test of a macaroon with an exact caveat verified with the correct root key and verifier*)
let caveat_v2_1 () =
  Utils.verifier_test "AgETaHR0cDovL2V4YW1wbGUub3JnLwIFa2V5aWQAAhRhY2NvdW50ID0gMzczNTkyODU1OQAABiD1SAf23G7fiL8PcwazgiVio2JTPb9zObphdl2kvSWdhw" [
    "account = 3735928559"
  ] Utils.assert_authorized

(** Simple test of a macaroon with an exact caveat verified with an incorrect root key and verifier built for another context*)
let caveat_v2_2 () =
  Utils.verifier_test "AgETaHR0cDovL2V4YW1wbGUub3JnLwIFa2V5aWQAAhRhY2NvdW50ID0gMzczNTkyODU1OQAABiD1SAf23G7fiL8PcwazgiVio2JTPb9zObphdl2kvSWdhw" [
    "account = 0000000000";
  ] Utils.assert_unauthorized

(** Simple test of a macaroon with an exact caveat verified with the inicorrect root key and a verifier lacking the correct context*)
let caveat_v2_3 () =
  Utils.verifier_test "AgETaHR0cDovL2V4YW1wbGUub3JnLwIFa2V5aWQAAhRhY2NvdW50ID0gMzczNTkyODU1OQAABiD1SAf23G7fiL8PcwazgiVio2JTPb9zObphdl2kvSWdhw" [] Utils.assert_unauthorized

(** Simple test of a macaroon with two exact caveats verified with the correct root key and verifier*)
let caveat_v2_4 () =
  Utils.verifier_test "AgETaHR0cDovL2V4YW1wbGUub3JnLwIFa2V5aWQAAhRhY2NvdW50ID0gMzczNTkyODU1OQACDHVzZXIgPSBhbGljZQAABiBL6WfNHqDGsmuvakqU7psFsViG2guoXoxCqTyNDhJe_A" [
    "account = 3735928559";
    "user = alice"
  ] Utils.assert_authorized


(** Simple test of a macaroon with two exact caveats verified with the correct root key and incomplete verifier*)
let caveat_v2_5 () =
  Utils.verifier_test "AgETaHR0cDovL2V4YW1wbGUub3JnLwIFa2V5aWQAAhRhY2NvdW50ID0gMzczNTkyODU1OQACDHVzZXIgPSBhbGljZQAABiBL6WfNHqDGsmuvakqU7psFsViG2guoXoxCqTyNDhJe_A" [
    "account = 3735928559"
  ] Utils.assert_unauthorized

(** Simple test of a macaroon with two exact caveats verified with the correct root key and an incomplete verifier*)
let caveat_v2_6 () =
  Utils.verifier_test "AgETaHR0cDovL2V4YW1wbGUub3JnLwIFa2V5aWQAAhRhY2NvdW50ID0gMzczNTkyODU1OQACDHVzZXIgPSBhbGljZQAABiBL6WfNHqDGsmuvakqU7psFsViG2guoXoxCqTyNDhJe_A" [
    "user = alice"
  ] Utils.assert_unauthorized

let v =
  let open Alcotest in
  "verifier_v2", [
    test_case "caveat_v2_1" `Quick caveat_v2_1;
    test_case "caveat_v2_2" `Quick caveat_v2_2;
    test_case "caveat_v2_3" `Quick caveat_v2_3;
    test_case "caveat_v2_4" `Quick caveat_v2_4;
    test_case "caveat_v2_5" `Quick caveat_v2_5;
    test_case "caveat_v2_6" `Quick caveat_v2_6;
  ]
