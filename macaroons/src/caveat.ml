type t = string


let create predicate = predicate

let to_cstruct t =
  Cstruct.of_string t
