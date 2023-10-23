(* Can't use Sha256.t because it's an abstract data type, causing issues with
   marshalling. *)
type t = string

let hash_string (s : string) : t = Sha256.to_hex (Sha256.string s)

let hash_file (filename : string) : t =
  hash_string (filename ^ "\n" ^ Filesystem.string_of_file filename)
