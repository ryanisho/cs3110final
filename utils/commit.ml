open Blob

(* TODO: encapsulate in module? *)

type t = {
  timestamp : string;
  message : string;
  parent : Filesystem.filename option;
  changes : Stage.t; (* changes : (Filesystem.filename * Hash.t) list; *)
}

(* TODO: add helper methods to read/write commits to/from the .got directory *)

let retrieve_latest_commit_filename () : Filesystem.filename option =
  let commit_filenames =
    Array.to_list (Sys.readdir (Filesystem.Repo.commit_dir ()))
  in
  if List.length commit_filenames = 0 then None
  else Some (List.hd (List.rev (List.sort compare commit_filenames)))

let write_commit (stage : Stage.t) (message : string) : string =
  (* TODO: actually write blobs to disk (probably in Add) *)
  let commit : t =
    {
      timestamp = string_of_int (int_of_float (Unix.time ()));
      message;
      parent = retrieve_latest_commit_filename ();
      changes =
        stage
        (* stage |> List.map (fun (file_metadata : Stage.file_metadata) ->
           (file_metadata.name, file_metadata.hash)); *);
    }
  in
  (Filesystem.marshal_data_to_file : t -> string -> unit)
    commit
    (Filesystem.Repo.commit_dir () ^ commit.timestamp);
  Stage.marshal_from_filenames_to_stage_file [];
  commit.timestamp
