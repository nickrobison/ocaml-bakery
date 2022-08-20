open Bakery_macaroons

module M = Macaroon.Make(Caveat)

module V = Verifier.Make(Caveat)(M)

module T = Macaroons_tester.Tester.Make(Caveat)(M)(V)

let () =
let open Alcotest in
run "Unit tests" T.v
