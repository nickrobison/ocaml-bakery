module Make(C: Sig.Caveat)(M: Sig.Macaroon with type c = C.t)(V: Sig.Verifier with type m = M.t) = struct

  module Utils = Utils.Make(C)(M)(V)

  (** Simple test of a macaroon with no caveats verified with the correct root key*)
  let root_v1_1 () =
    Utils.verifier_test "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeVpuTnBaMjVoZEhWeVpTQjgzdWVTVVJ4Ynh2VW9TRmdGMy1teVRuaGVLT0twa3dINTF4SEdDZU9POXdv" [] Utils.assert_authorized


  (** Simple test of a macaroon with no caveats verified with the incorrect root key*)
  let root_v1_2 () =
    let str = "TURBeU1XeHZZMkYwYVc5dUlHaDBkSEE2THk5bGVHRnRjR3hsTG05eVp5OEtNREF4Tldsa1pXNTBhV1pwWlhJZ2EyVjVhV1FLTURBeVpuTnBaMjVoZEhWeVpTQjgzdWVTVVJ4Ynh2VW9TRmdGMy1teVRuaGVLT0twa3dINTF4SEdDZU9POXdv" in
    let v = V.create () in
    Utils.assert_unauthorized (Utils.verify_macaroon v str "this is not the key")


  let v =
    let open Alcotest in
    "root_v1", [
      test_case "root_v1_1" `Quick root_v1_1;
      test_case "root_v1_2" `Quick root_v1_2;
    ]
end
