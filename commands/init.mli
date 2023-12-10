(* init.mli *)

(** The [init] module is responsible for initializing a new Got version-control
    system repository in a given directory. *)

type empty_command = unit -> string
(** [empty_command] is a type for commands that do not return any value. *)

val run : string list -> empty_command
(** [run] initializes a new Got version-control system repository in the given
    directory.
    @param args
      A list of string arguments, where the first element is the base directory
      in which to initialize the repository.
    @raise Failure
      if a Got version-control system already exists in the specified directory.
    @return
      A command that, when executed, returns a confirmation message indicating
      the initialization of the repository. *)
