(** Unwrap a Result and assert that it's Ok. Otherwise, fail with return code*)
let unwrap_ok = function
  | Ok r -> r
  | Error e -> Alcotest.failf "Unexpected failure: %s" e


