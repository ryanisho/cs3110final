(* commit.mli *)

open Blob
open Filesystem

type t = {
  timestamp : string;
  message : string;
  parent : Filesystem.filename option;
  merge_parent : Filesystem.filename option;
  changes : (Filesystem.filename * Hash.t * Stage.mode) list;
}
(** Type representing a commit. *)

val join_changes :
  Stage.file_metadata list -> (filename * Hash.t * Stage.mode) list
(** Joins the changes in a list of file metadata into a list of changes. *)

(** Retrieves the stage of the commit. *)

val retrieve_all_commit_filenames : unit -> filename list
(** Retrieves a list of all commit filenames in the repository. *)

val retrieve_latest_commit_filename : unit -> filename option
(** Retrieves the filename of the latest commit, if any. *)

val write_commit : Stage.t -> string -> string * string
(** Writes a new commit with the given stage and message, and returns the
    timestamp. *)

val fetch_commit : filename -> t
(** Fetches a commit by its timestamp. *)

val list_changes : (filename * Hash.t * Stage.mode) list -> string
(** Lists the changes in a commit. *)

val fetch_latest_commit : unit -> t option
(** Fetches the latest commit. *)

val fetch_latest_commit_files : unit -> filename list
(** Fetches the files in the latest commit. *)

val fetch_latest_commit_changes : unit -> (filename * Hash.t * Stage.mode) list
(** Fetches the changes in the latest commit. *)

val get_full_commit_history : unit -> t list
(** Retrieves the full history of commits, sorted from the most recent to the
    oldest. *)

val clear_commit_history : unit -> unit
(** Clears the commit history. *)
