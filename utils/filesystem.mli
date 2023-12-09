type filename = string

(* Paths for got directories and files *)
module Repo : sig
  val root : ?base_dir:filename -> unit -> filename
  val got_dir : ?base_dir:filename -> unit -> filename
  val stage_file : ?base_dir:filename -> unit -> filename
  val commit_dir : ?base_dir:filename -> unit -> filename
  val blob_dir : ?base_dir:filename -> unit -> filename
  val branch_dir : ?base_dir:filename -> unit -> filename
  val log_dir : ?base_dir:filename -> unit -> filename
end

(* Check if got repo has been initialized before running a command. If the repo
   is initialized and we call [init], raise a Failure. If the repo is
   uninitialized and we call a command besides [init], raise a Failure.
   Otherwise, return a unit *)
val got_initialized : string -> unit

(* Create [stage.msh] with empty contents *)
val make_empty_stage : unit -> unit

(* Check that all listed files exist; raise a Faliure if not *)
val find_files : filename list -> filename list

(* Recursively list all files in the repo *)
val list_files : unit -> filename list

(* Remove listed files *)
val remove_files : filename list -> unit

(* Given a filename, return its contents as a string *)
val string_of_file : filename -> filename

(* Send data to a file *)
val marshal_data_to_file : 'a -> filename -> unit

(* Get marshalled data from a file *)
val marshal_file_to_data : filename -> 'a
