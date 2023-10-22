open Blob

(* TODO: encapsulate in module? *)

type filename = string

type commit = {
  timestamp : string;
  message : string;
  parent : commit;
  changes : (filename * hash) list;
}
