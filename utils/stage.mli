type mode =
  | Create
  | Edit
  | Delete

type file_metadata = {
  name : Filesystem.filename;
  hash : Hash.t;
  contents : string;
  modification : mode;
}

(* Accessible externally as Stage.t *)
type t = file_metadata list

(* Get file metadata from [stage.msh] *)
val marshal_from_stage_file : unit -> t

(* Get tracked files. We combine results from the staging area with that of the
   previous commit (if applicable) *)
val get_staged_files : unit -> string list

(* Update a file's metadata with name and mode, updating contents and hash as
   well. If it is not in the present metadata, insert it into the metadata
   list *)
val update_metadata : string -> t -> t

(* Add files to stage *)
val add_files_to_stage : ?base_dir:string -> string list -> unit

(* Remove files from staging area *)
val remove_files_from_stage : ?base_dir:string -> string list -> unit
