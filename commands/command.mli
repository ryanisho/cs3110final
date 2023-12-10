(* command.mli *)

(** Commands are a function that returns an output. The output will be printed
    out in `main.ml`. *)

type argumented_command = string list -> string
(** [argumented_command args] is the output of the command with arguments
    [args]. *)

type empty_command = unit -> string
(** [empty_command ()] is the output of the command with no arguments. *)
