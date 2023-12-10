(* commit.ml *)

(** The [Commit] module handles the commit operation in the version control system. *)

(** [run] handles the commit operation based on the provided arguments.
    It initializes the version control system if not already done, stages files, and creates a commit with a message.
    @param args A list of string arguments for the commit message.
    @return A string indicating the result of the commit operation, including the timestamp and the commit message, or an error message if the operation fails. *)
val run : Command.argumented_command
