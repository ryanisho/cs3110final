(* blob.mli *)

(** Type representing a blob. *)
type t = {
  hash : Hash.t;
  contents : string;
}

(** Create a blob from a file. *)
val make_blob : string -> t

(** Write a blob to the blob directory. *)
val write_blob : string -> unit

(** Write multiple blobs to the blob directory. *)
val write_blobs : string list -> unit

(** Retrieve a blob by its hash. Returns an option type. *)
val get_blob : string -> string option

(** Get the contents of a blob. Raises Failure if no such blob exists. *)
val get_blob_contents : string -> string
