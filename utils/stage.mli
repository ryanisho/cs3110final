(** This module defines the stage type and functions for interacting with the
    staging area. *)

type mode =
  | Create
  | Edit
  | Delete
  (** Define the mode type which represents the type of modification made to
      a file. *)

type file_metadata = {
  name : Filesystem.filename;
  hash : Hash.t;
  contents : string;
  modification : mode;
}
(** Define the file_metadata type which represents metadata about a file. *)

type t = file_metadata list
(** Accessible externally as Stage.t *)

val marshal_from_stage_file : unit -> t
(** Get file metadata from [stage.msh] *)

val get_staged_files : unit -> string list
(** Get tracked files. We combine results from the staging area with that of the
    previous commit (if applicable) *)

val update_metadata : string -> t -> mode -> t
(** Update a file's metadata with name and mode, updating contents and hash as
    well. If it is not in the present metadata, insert it into the metadata list *)

val add_files_to_stage : ?base_dir:string -> string list -> unit
(** Add files to stage *)

val remove_files_from_stage : ?base_dir:string -> string list -> unit
(** Remove files from staging area *)
