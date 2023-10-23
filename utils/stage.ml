type file_metadata = {
  name : string;
  hash : Hash.t;
  contents : string;
}

(* Accessible externally as Stage.t *)
type t = file_metadata list

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

let marshal_from_filenames_to_stage_file files =
  let rec get_added_files files =
    match files with
    | [] -> []
    | file :: tl ->
        if Sys.file_exists (Filesystem.Repo.root () ^ file) then
          file :: get_added_files tl
        else raise (Failure (file ^ " does not exist"))
  in

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
  let out_channel = open_out (Filesystem.Repo.stage_file ()) in
  Marshal.to_channel out_channel
    (add_file_metadata (get_added_files files) : t)
    [];
  close_out out_channel
