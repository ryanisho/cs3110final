(* Stage module for handling the staging area in the repository. *)

(* Type for file metadata, including the filename, hash, and contents. *)
type file_metadata = {
  name : Filesystem.filename;
  hash : Hash.t;
  contents : string;
}

(* AF: A file_metadata represents the metadata of a file in the repository, 
   where 'name' is the filename, 'hash' is the hash of the file's contents, and 
   'contents' is the actual contents of the file. *)

(* RI: The 'name' field of a file_metadata must be a valid filename within the 
   filesystem. The 'hash' field must be a valid hash of the file's contents. The 
   'contents' field must be the contents of the file. The 'hash' field must 
   match the hash of the 'contents' field. *)

(* Type for the staging area, which is a list of file metadata. *)
type t = file_metadata list

(* AF: A 't' represents the staging area of the repository, which is a list of 
   file metadata. Each element in the list represents the metadata of a file 
   that is currently staged for the next commit. *)

(* RI: The list of file metadata in a 't' must not contain any duplicates, i.e., 
   there must not be two elements with the same 'name' field. Each 
   'file_metadata' in the list must satisfy the RI for 'file_metadata'. *)

(* Reads the stage file and returns its contents as a list of file metadata.
   If the stage file is empty or does not exist, returns an empty list. *)
val marshal_from_stage_file : unit -> t

(* Given a list of filenames, checks that all the files exist, updates their 
   metadata in the stage file if they are already there, or adds their metadata 
   to the stage file if they are not. Raises an exception if any of the files do 
   not exist. *)
val marshal_from_filenames_to_stage_file : string list -> unit