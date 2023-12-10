(** [track] is an interface for the module containing tracking and untracking of files *)

val get_tracked_files : unit -> string list
(** [get_tracked_files] returns a list of files that are either staged or
    committed. It combines the files from both these sources, removing
    duplicates. *)

val untrack_file : string -> unit
(** [untrack_file] is a function intended to untrack a file. Currently, it is
    not implemented and raises a failure when called. *)
