(* blob.mli *)

(** Blobs are the basic unit of storage in the Git object model. They are
    immutable, and are identified by their SHA-1 hash. *)

type t = {
  hash : Hash.t;
  contents : string;
}
(** Type representing a blob. *)

val make_blob : string -> t
(** Create a blob from a file. *)

val write_blob : t -> unit
(** Write a blob to the blob directory. *)

val write_blobs : t list -> unit
(** Write multiple blobs to the blob directory. *)

(* val get_blob : string -> string option *)
(** Retrieve a blob by its hash. Returns an option type. *)

val get_blob_contents : string -> string
(** Get the contents of a blob. Raises Failure if no such blob exists. *)
