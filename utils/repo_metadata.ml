(* repo_metadata.ml *)

(** This module contains functions for working with repository metadata. *)

type t = {
  head : Filesystem.filename;
  branches : (string * Filesystem.filename) list;
}
(** Type for repo metadata object. *)

(** Write repo metadata. *)
let write_to_file (m : t) =
  Filesystem.marshal_data_to_file m (Filesystem.Repo.metadata_file ())

(** Get repo metadata. *)
let read_from_file () : t =
  Filesystem.marshal_file_to_data (Filesystem.Repo.metadata_file ())

(** Make initial commit. *)
let empty (initial_commit_timestamp : Filesystem.filename) =
  { head = "master"; branches = [ ("master", initial_commit_timestamp) ] }
