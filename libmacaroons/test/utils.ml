let unwrap_ok = function
  | Ok r -> r
  | Error e -> Alcotest.fail ("Unexpected failure" ^ (Libmacaroons.Utils.return_code_to_message e))
