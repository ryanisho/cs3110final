(* log.mli *)

(** [commit_to_log_entry commit] converts a commit into a log entry string. *)
val commit_to_log_entry : Utils.Commit.t -> string

(** [run ()] executes the log command and returns a string representing the commit log. *)
val run : unit -> string
