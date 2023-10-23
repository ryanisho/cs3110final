type file_metadata = {
  name : string;
  hash : Hash.t;
  contents : string;
}

let rec get_added_files files =
  match files with
  | [] -> []
  | file :: tl ->
      if Sys.file_exists (Fs.Repo.root () ^ file) then
        file :: get_added_files tl
      else raise (Failure (file ^ " does not exist"))

let get_staged_metadata () : file_metadata list =
  let in_channel = open_in (Fs.Repo.stage_file ()) in
  try
    let metadata = Marshal.from_channel in_channel in
    close_in in_channel;
    metadata
  with End_of_file ->
    close_in in_channel;
    []

let rec update_metadata (file : string) (metadata : file_metadata list) :
    file_metadata list =
  match metadata with
  | data :: t ->
      if data.name = file then
        {
          name = file;
          hash = Hash.hash file;
          contents = Fs.string_of_file file;
        }
        :: update_metadata file t
      else data :: update_metadata file t
  | [] ->
      [
        {
          name = file;
          hash = Hash.hash file;
          contents = Fs.string_of_file file;
        };
      ]

let add_file_metadata files =
  let rec add_file_metadata_helper files metadata =
    match files with
    | [] -> metadata
    | h :: t -> add_file_metadata_helper t (update_metadata h metadata)
  in
  add_file_metadata_helper files (get_staged_metadata ())

let marshal_to_stage files =
  let out_channel = open_out (Fs.Repo.stage_file ()) in
  Marshal.to_channel out_channel (add_file_metadata (get_added_files files)) [];
  close_out out_channel
