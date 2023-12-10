(* status.mli *)

(** [status.ml] provides functions for getting the status of the current
    repository. *)

val set_color : string -> string -> string
(** [set_color text color] sets the color of the given text using ANSI color
    codes. *)

val get_commited : unit -> string
(** [get_commited ()] returns a string representing the changes to be committed. *)

val get_untracked : unit -> string
(** [get_untracked ()] returns a string listing untracked files. *)

val run : unit -> string
(** [run ()] executes the status command and returns the status as a string. *)
