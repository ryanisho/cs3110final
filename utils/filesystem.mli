(* Filesystem module for handling file operations in the repository. *)

(* Type alias for filenames. *)
type filename = string

(* Module for repository paths. *)
module Repo : sig
  (* AF: The root, got_dir, stage_file, commit_dir, and blob_dir functions 
     represent the paths to various directories and files within the repository. 
     The root function represents the root directory of the repository, 
     got_dir represents the .got directory inside the repository, 
     stage_file represents the stage file inside the .got directory, 
     commit_dir represents the commits directory inside the .got directory, 
     and blob_dir represents the blobs directory inside the .got directory. *)

  (* RI: The paths returned by root, got_dir, stage_file, commit_dir, and 
     blob_dir must be valid paths within the filesystem. *)

  (* Returns the root directory of the repository.
     This is the top-level directory that contains all other files and 
     directories in the repository. *)
  val root : unit -> string

  (* Returns the .got directory inside the repository.
     This is the directory that contains all Got-related files and directories, 
     such as the stage file and the commits directory. *)
  val got_dir : unit -> string

  (* Returns the path to the stage file inside the .got directory.
     The stage file is used to keep track of changes that are staged for the 
     next commit. *)
  val stage_file : unit -> string

  (* Returns the path to the commits directory inside the .got directory.
     The commits directory contains one file for each commit in the repository. 
     Each file contains the details of the corresponding commit. *)
  val commit_dir : unit -> string

  (* Returns the path to the blobs directory inside the .got directory.
     The blobs directory contains one file for each blob in the repository. Each 
     file contains the contents of the corresponding blob. *)
  val blob_dir : unit -> string
end

(* AF: The string_of_file function represents the contents of a file as a string.
   The marshal_data_to_file function represents a marshalled data structure as a 
   file. The marshal_file_to_data function represents a file as a marshalled data 
   structure.

   RI: The filename passed to string_of_file, marshal_data_to_file, and 
   marshal_file_to_data must be a valid filename within the filesystem. The data 
   passed to marshal_data_to_file must be a valid data structure that can be 
   marshalled. *)

(* Reads the contents of a file in the repository and returns it as a string.
   The file is read in binary mode, so it can contain any data. *)
val string_of_file : filename -> string

(* Writes a marshalled data structure to a file.
   The data structure is first marshalled (converted to a string), then written 
   to the file in binary mode. *)
val marshal_data_to_file : 'a -> filename -> unit

(* Reads a marshalled data structure from a file.
   The file is read in binary mode, then the data is unmarshalled (converted 
   back to a data structure). *)
val marshal_file_to_data : filename -> 'a