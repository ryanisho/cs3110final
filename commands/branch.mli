(* branch.ml *)

(** The [Branch] module is responsible for listing and deleting branches in the
    version control system. *)

val run : Command.argumented_command
(** [run] handles the branch operation based on the provided arguments.
    @param args A list of string arguments for the branch command.
    @return A string indicating the result of the branch operation. *)
