module Make(C: Macaroon_intf.C): sig
  include Macaroon_intf.M with type c = C.t
end
