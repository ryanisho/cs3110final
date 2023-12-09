open Blob

type t = {
  timestamp : string;
  message : string;
  parent : Filesystem.filename option;
  changes : (Filesystem.filename * Hash.t) list;
}

let retrieve_all_commit_filenames () : Filesystem.filename list =
  Filesystem.Repo.commit_dir ()
  |> Sys.readdir |> Array.to_list |> List.sort compare

let retrieve_latest_commit_filename () : Filesystem.filename option =
  List.nth_opt (List.rev (retrieve_all_commit_filenames ())) 0

let write_commit (stage : Stage.t) (message : string) : string =
  (* TODO: actually write blobs to disk (probably in Add) *)
  let commit : t =
    {
      timestamp = string_of_int (int_of_float (Unix.time ()));
      message;
      parent = retrieve_latest_commit_filename ();
      changes =
        stage
        |> List.map (fun (file_metadata : Stage.file_metadata) ->
               (file_metadata.name, file_metadata.hash));
    }
  in
  (Filesystem.marshal_data_to_file : t -> string -> unit)
    commit
    (Filesystem.Repo.commit_dir () ^ commit.timestamp);
  Stage.add_files_to_stage [];
  commit.timestamp

let fetch_commit (timestamp : Filesystem.filename) : t =
  Filesystem.marshal_file_to_data (Filesystem.Repo.commit_dir () ^ timestamp)

let get_full_commit_history () : t list =
  retrieve_all_commit_filenames ()
  |> List.map fetch_commit
  |> List.sort (fun (c1 : t) (c2 : t) -> compare c2.timestamp c1.timestamp)
  |> List.rev
