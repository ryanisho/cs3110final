open Blob

(* TODO: encapsulate in module? *)

type filename = string

type t = {
  timestamp : string;
  message : string;
  parent : t option;
  changes : (filename * Hash.t) list;
}

(* TODO: add helper methods to read/write commits to/from the .got directory *)
