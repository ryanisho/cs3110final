(* Can't use Sha256.t because it's an abstract data type, causing issues with
   marshalling. *)
type t = string

let hash_string (s : string) = "dummy hash"

let hash_file (filename : string) : t =
  hash_string (filename ^ "\n" ^ Filesystem.string_of_file filename)
