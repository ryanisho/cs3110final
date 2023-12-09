(* A commit is described by a timestamp, message, parent commit (if applicable),
   amd a list of changes *)
type t = {
  timestamp : string;
  message : string;
  parent : Filesystem.filename option;
  merge_parent : Filesystem.filename option;
  changes : (Filesystem.filename * Hash.t) list;
}

(* Get all filnames of commits *)
val retrieve_all_commit_filenames : unit -> Filesystem.filename list

(* Get the latest commit filename *)
val retrieve_latest_commit_filename : unit -> Filesystem.filename option

(* Write a commit *)
val write_commit : Stage.t -> string -> string

(* Fetch commit *)
val fetch_commit : Filesystem.filename -> t

(* Get full commit history *)
val get_full_commit_history : unit -> t list
