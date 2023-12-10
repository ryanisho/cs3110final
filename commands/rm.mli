(* rm.mli *)

(**  [rm files] removes the given list of files from the stage. Returns a
     string summarizing the actions taken. *)

val is_tracked : string list -> string list
(** [is_tracked files] checks if the given list of files are tracked, and
    returns the list of tracked files. Raises Failure if a file is not tracked. *)

val remove : string list -> string
(** [remove files] removes the given list of files from the stage. Returns a
    string summarizing the actions taken. *)

val run : string list -> string
(** [run files] executes the rm command with the given list of files. Returns a
    string describing the outcome. *)
