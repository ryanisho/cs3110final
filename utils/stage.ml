type file_metadata = {
  name : Filesystem.filename;
  hash : Hash.t;
  contents : string;
}

(* Accessible externally as Stage.t *)
type t = file_metadata list

(* Read data from [stage.msh] into a list of file_metadata *)
let marshal_from_stage_file () : t =
  let in_channel = open_in (Filesystem.Repo.stage_file ()) in
  try
    let metadata = (Marshal.from_channel in_channel : t) in
    close_in in_channel;
    metadata
  with End_of_file ->
    (* print_endline "There was an error while reading the stage file!"; *)
    close_in in_channel;
    []

(* Serialize the list of metadata, writing to [stage.msh] *)
let marshal_from_filenames_to_stage_file files =
  (* Check that all added files exist; raise exception if not *)
  let rec get_added_files files =
    match files with
    | [] -> []
    | file :: tl ->
      if Sys.file_exists (Filesystem.Repo.root () ^ file) then
        file :: get_added_files tl
      else raise (Failure (file ^ " does not exist"))
  in

  (* Given a file and list of file_metadata, update the file's metadata if it is
     already in the list; otherwise add its metadata to the list *)
  let rec update_metadata (file : string) (metadata : t) : t =
    match metadata with
    | data :: tl ->
      if data.name = file then
        {
          name = file;
          hash = Hash.hash_file file;
          contents = Filesystem.string_of_file file;
        }
        :: update_metadata file tl
      else data :: update_metadata file tl
    | [] ->
      [
        {
          name = file;
          hash = Hash.hash_file file;
          contents = Filesystem.string_of_file file;
        };
      ]
  in

  let add_file_metadata files =
    let rec add_file_metadata_helper files metadata =
      match files with
      | [] -> metadata
      | h :: tl -> add_file_metadata_helper tl (update_metadata h metadata)
    in
    add_file_metadata_helper files (marshal_from_stage_file ())
  in
  (* add_file_metadata requires the file to exist first *)
  Filesystem.marshal_data_to_file [] (Filesystem.Repo.stage_file ());
  let stage = add_file_metadata (get_added_files files) in
  Filesystem.marshal_data_to_file stage (Filesystem.Repo.stage_file ())
