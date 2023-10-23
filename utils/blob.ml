(* TOOD: encapsulate in module? *)

type t = {
  hash : Hash.t;
  contents : string;
}

(* TODO: add helpers to read/write blobs to/from .got directory *)
