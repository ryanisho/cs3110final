(* TOOD: encapsulate in module? *)

type hash = string

type blob = {
  hash : hash;
  contents : string;
}

(* TODO: add helpers to read/write blobs to/from .got directory *)
