type t = string [@@deriving eq, show]


let create predicate = predicate

let size t =
  String.length t

let to_cstruct t =
  Cstruct.of_string t

let to_bytes t =
  Bytes.of_string t

let to_string t = t
