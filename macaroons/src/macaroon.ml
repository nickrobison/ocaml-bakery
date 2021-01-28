
type t = {
  id: string;
  location: string;
  caveats: string list;
  signature: string
}

let create id location =
  {
    id;
    location;
    caveats = [];
    signature = "";
  }
