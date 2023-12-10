(* rm.ml *)

(** This module is responsible for removing files from the version control
    system. *)

val check_tracked : string list -> unit
(** [check_tracked] checks if the files listed are tracked. Raise an exception
    if not *)

val remove : string list -> string
(** [remove files] removes the given list of files from the stage. Returns a
    string summarizing the actions taken. *)

val run : string list -> string
(** [run files] executes the rm command with the given list of files. Returns a
    string describing the outcome. *)
