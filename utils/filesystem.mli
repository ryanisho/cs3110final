exception File_not_found of string
exception Got_initialized of string

type filename = string

(** Types for [got] objects *)

(** Paths for [got] directories and files *)
module Repo : sig
  val root : ?base_dir:filename -> unit -> filename
  val got_dir : ?base_dir:filename -> unit -> filename
  val stage_file : ?base_dir:filename -> unit -> filename
  val commit_dir : ?base_dir:filename -> unit -> filename
  val blob_dir : ?base_dir:filename -> unit -> filename
  val metadata_file : ?base_dir:filename -> unit -> filename
  val log_dir : ?base_dir:filename -> unit -> filename
end

val got_initialized : string -> unit
(** Check if [got] repo has been initialized before running a command. If the
    repo is initialized and we call [init], raise a Failure. If the repo is
    uninitialized and we call a command besides [init], raise a Failure.
    Otherwise, return a unit *)

val make_empty_stage : unit -> unit
(** Create [stage.msh] with empty contents *)

val find_files : filename list -> filename list
(** Check that all listed files exist; raise a Faliure if not *)

val list_files : unit -> filename list
(** Recursively list all files in the repo *)

val remove_files : filename list -> unit
(** Remove listed files *)

val string_of_file : filename -> filename
(** Given a filename, return its contents as a string *)

val marshal_data_to_file : 'a -> filename -> unit
(** Send data to a file *)

val marshal_file_to_data : filename -> 'a
(** Get marshalled data from a file *)
