(* rm.mli *)

(** [is_tracked files] checks if the given list of files are tracked, and returns the list of tracked files. 
    Raises Failure if a file is not tracked. *)
val is_tracked : string list -> string list

(** [remove files] removes the given list of files from the stage. 
    Returns a string summarizing the actions taken. *)
val remove : string list -> string

(** [run files] executes the rm command with the given list of files. 
    Returns a string describing the outcome. *)
val run : string list -> string
