(* checkout.ml *)

(** The [Checkout] module is responsible for checking out branches in the
    version control system *)

val run : Command.argumented_command
(** [run] handles the checkout operation based on the provided arguments.
    @param args A list of string arguments for the checkout command.
    @return A string indicating the result of the checkout operation. *)
