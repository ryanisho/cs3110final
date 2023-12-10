(* rm.mli *)

val check_tracked : string list -> unit

val remove : string list -> string
(** [remove files] removes the given list of files from the stage. Returns a
    string summarizing the actions taken. *)

val run : string list -> string
(** [run files] executes the rm command with the given list of files. Returns a
    string describing the outcome. *)
