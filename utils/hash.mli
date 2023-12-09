(* Can't use Sha256.t because it's an abstract data type, causing issues with
   marshalling. *)
type t = string

(* Get the hash of a string. Used for file names and file contents *)
val hash_string : string -> t

(* Get the hashed contents of an entire file. *)
val hash_file : string -> t
