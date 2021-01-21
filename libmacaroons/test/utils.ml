let unwrap_ok = function
  | Ok r -> r
  | Error _e -> Alcotest.fail "Unexpected failure"
