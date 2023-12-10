(* hash.mli *)

(** This module implements a simple hash function. *)

type t = string
(** The type of hash values. *)

val hash_string : string -> t
(** [hash_string s] hashes the string [s] and returns the hash value. *)

val hash_file : string -> t
(** [hash_file filename] reads the content of the file named [filename], hashes
    its content, and returns the hash value. *)
