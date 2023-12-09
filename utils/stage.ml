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
let get_tracked_files () =
  let metadata = marshal_from_stage_file () in
  List.map (fun m -> m.name) metadata

let rec update_metadata (file : string) (metadata : t) (modif : mode) : t =
  match (metadata, modif) with
  | data :: tl, _ ->
      if data.name = file then
        {
          data with
          hash = Hash.hash_file file;
          contents = Filesystem.string_of_file file;
          modification = modif;
        }
        :: tl
      else data :: update_metadata file tl modif
  | [], _ ->
      [
        {
          name = file;
          hash = Hash.hash_file file;
          contents = Filesystem.string_of_file file;
          modification = Create;
        };
      ]

(* Denote [file] as removed in [stage.msh] *)
(* @Ryan fix this path stuff *)
let remove_from_stage file =
  let metadata = marshal_from_stage_file () in
  let rec remove_from_stage' f m =
    match m with
    | [] -> raise (Failure ("Unable to remove " ^ f))
    | h :: t ->
        if f = h.name then { h with modification = Delete } :: t
        else remove_from_stage' f t
  in
  remove_from_stage' file metadata

(* Serialize the list of metadata, writing to [stage.msh] *)
let marshal_from_filenames_to_stage_file ?(base_dir = ".") files =
  let files = Filesystem.find_files files in
  let add_file_metadata files =
    let rec add_file_metadata' files acc =
      match files with
      | [] -> acc
      | f :: tl -> add_file_metadata' tl (update_metadata f acc Edit)
    in
    add_file_metadata' files (marshal_from_stage_file ())
  in
  let stage = add_file_metadata files in
  Filesystem.marshal_data_to_file stage
    (Filesystem.Repo.stage_file ~base_dir ())
