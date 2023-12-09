(* status.mli *)

(** [set_color text color] sets the color of the given text using ANSI color codes. *)
val set_color : string -> string -> string

(** [get_commited ()] returns a string representing the changes to be committed. *)
val get_commited : unit -> string

(** [get_untracked ()] returns a string listing untracked files. *)
val get_untracked : unit -> string

(** [run ()] executes the status command and returns the status as a string. *)
val run : unit -> string
