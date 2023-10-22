(* TOOD: encapsulate in module? *)

type hash = string

type blob = {
  hash : hash;
  contents : string;
}
