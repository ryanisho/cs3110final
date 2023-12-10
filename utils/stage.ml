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

(* Read data from [stage.msh] into a list of file_metadata *)
let marshal_from_stage_file () : t =
  let in_channel = open_in (Filesystem.Repo.stage_file ()) in
  try
    let metadata = (Marshal.from_channel in_channel : t) in
    close_in in_channel;
    metadata
  with End_of_file ->
    close_in in_channel;
    []

(* Get staged files *)
let get_staged_files () =
  let staged = marshal_from_stage_file () in
  List.map (fun m -> m.name) staged

let rec update_metadata (file : string) (metadata : t) : t =
  let file_path = Filesystem.Repo.root () ^ file in
  match metadata with
  | data :: tl ->
      if data.name = file then
        {
          data with
          hash = Hash.hash_file file_path;
          contents = Filesystem.string_of_file file_path;
          modification = Create;
        }
        :: tl
      else data :: update_metadata file tl
  | [] ->
      [
        {
          name = file;
          hash = Hash.hash_file file_path;
          contents = Filesystem.string_of_file file_path;
          modification = Create;
        };
      ]

let rec remove_metadata (file : string) (metadata : t) : t =
  match metadata with
  | data :: tl ->
      if data.name = file then
        { data with contents = ""; modification = Delete }
        :: remove_metadata file tl
      else data :: remove_metadata file tl
  | [] ->
      [
        {
          name = file;
          hash = Hash.hash_file (Filesystem.Repo.root () ^ file);
          contents = "";
          modification = Delete;
        };
      ]

(* Serialize the list of metadata, writing to [stage.msh] *)
let add_files_to_stage ?(base_dir = ".") files =
  let files = Filesystem.find_files files in
  let add_file_metadata files =
    let rec add_file_metadata' files acc =
      match files with
      | [] -> acc
      | f :: tl -> add_file_metadata' tl (update_metadata f acc)
    in
    add_file_metadata' files (marshal_from_stage_file ())
  in
  let stage = add_file_metadata files in
  Filesystem.marshal_data_to_file stage
    (Filesystem.Repo.stage_file ~base_dir ());
  let blobs = List.map Blob.make_blob files in
  Blob.write_blobs blobs

let remove_files_from_stage ?(base_dir = ".") files =
  let files = Filesystem.find_files files in
  let remove_file_metadata files =
    let rec remove_file_metadata' files acc =
      match files with
      | [] -> acc
      | f :: tl -> remove_file_metadata' tl (remove_metadata f acc)
    in
    remove_file_metadata' files (marshal_from_stage_file ())
  in
  let stage = remove_file_metadata files in
  Filesystem.marshal_data_to_file stage
    (Filesystem.Repo.stage_file ~base_dir ())
