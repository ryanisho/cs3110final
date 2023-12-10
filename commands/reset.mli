(* reset.ml *)

(** The [Reset] module is responsible for resetting the working directory to
    some previous state in the version control system. *)

val run : Command.argumented_command
(** [run arg] executes the reset command and returns a string representing the
    result. *)
