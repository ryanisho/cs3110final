(* log.mli *)

(** [log message] is a function that logs the given [message] to the console. 
        It is used for debugging and tracking the flow of the program. *)

val commit_to_log_entry : Utils.Commit.t -> string
(** [commit_to_log_entry commit] converts a commit into a log entry string. *)

val run : unit -> string
(** [run ()] executes the log command and returns a string representing the
    commit log. *)
