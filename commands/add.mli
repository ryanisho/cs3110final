(* add.ml *)

(** The [Add] module is responsible for adding files to the staging area in the
    version control system. *)

val run : Command.argumented_command
(** [run] adds the specified files to the staging area.
    @param files A list of string arguments representing the files to be added.
    @return
      A string message indicating the outcome of the
      operation:
      - If no files are provided, it returns a message indicating that no file
        was added.
      - If files are provided, it adds them to the staging area and returns a
        message listing the added files.
    @raise Any
      exceptions are caught within the function, and it may internally retry the
      operation. *)
