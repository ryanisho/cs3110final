open Blob

(* TODO: encapsulate in module? *)

type t = {
  timestamp : string;
  message : string;
  parent : Filesystem.filename option;
  changes : (Filesystem.filename * Hash.t) list;
}

(* TODO: add helper methods to read/write commits to/from the .got directory *)

let retrieve_latest_commit_filename () : Filesystem.filename option =
  let commit_filenames =
    Array.to_list (Sys.readdir (Filesystem.Repo.commit_dir ()))
  in
  if List.length commit_filenames = 0 then None
  else Some (List.hd (List.rev (List.sort compare commit_filenames)))

let write_commit (stage : Stage.t) (message : string) : string =
  (* TODO: actually write blobs to disk *)
  let commit : t =
    {
      timestamp = string_of_int (int_of_float (Unix.time ()));
      message;
      parent = retrieve_latest_commit_filename ();
      (* TODO *)
      changes = [];
    }
  in
  (Filesystem.marshal_data_to_file : t -> string -> unit)
    commit commit.timestamp;
  Stage.marshal_from_filenames_to_stage_file [];
  commit.timestamp
