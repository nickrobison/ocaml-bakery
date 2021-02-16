module Make(C: Macaroon_intf.C)(M: Macaroon_intf.M with type c = C.t): sig
  include Macaroon_intf.V with type m = M.t
end
