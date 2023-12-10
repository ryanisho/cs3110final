open Blob

type t = {
  timestamp : string;
  message : string;
  parent : Filesystem.filename option;
  merge_parent : Filesystem.filename option;
  changes : (Filesystem.filename * Hash.t) list;
}

let retrieve_all_commit_filenames () : Filesystem.filename list =
  Filesystem.Repo.commit_dir ()
  |> Sys.readdir |> Array.to_list |> List.sort compare

let retrieve_latest_commit_filename () : Filesystem.filename option =
  List.nth_opt (List.rev (retrieve_all_commit_filenames ())) 0

let fetch_commit (timestamp : Filesystem.filename) : t =
  Filesystem.marshal_file_to_data (Filesystem.Repo.commit_dir () ^ timestamp)

let fetch_latest_commit () =
  let commit_name = retrieve_latest_commit_filename () in
  match commit_name with
  | Some c -> Some (fetch_commit c)
  | None -> None

let fetch_latest_commit_changes () =
  let commit = fetch_latest_commit () in
  match commit with
  | None -> []
  | Some c -> c.changes

let fetch_latest_commit_files () =
  fetch_latest_commit_changes () |> List.map fst

let join_changes stage =
  let prev_changes = fetch_latest_commit_changes () in
  let curr_changes =
    List.map
      (fun (file_metadata : Stage.file_metadata) ->
         (file_metadata.name, file_metadata.hash))
      stage
  in
  List.fold_left
    (fun acc (file, hash) ->
       if List.exists (fun (prev_file, _) -> prev_file = file) prev_changes then
         List.map
           (fun (prev_file, prev_hash) ->
              if prev_file = file then (file, hash) else (prev_file, prev_hash))
           acc
       else (file, hash) :: acc)
    prev_changes curr_changes

let write_commit (stage : Stage.t) (message : string) : string =
  (* TODO: actually write blobs to disk (probably in Add) *)
  let commit : t =
    {
      timestamp = string_of_float (Unix.gettimeofday ());
      message;
      parent = retrieve_latest_commit_filename ();
      merge_parent = None;
      changes = join_changes stage;
    }
  in
  (Filesystem.marshal_data_to_file : t -> string -> unit)
    commit
    (Filesystem.Repo.commit_dir () ^ commit.timestamp);
  Filesystem.make_empty_stage ();
  commit.timestamp

let get_full_commit_history () : t list =
  retrieve_all_commit_filenames ()
  |> List.map fetch_commit
  |> List.sort (fun (c1 : t) (c2 : t) -> compare c1.timestamp c2.timestamp)
  |> List.rev

let clear_commit_history () =
  let commit_files = retrieve_all_commit_filenames () in
  List.iter (fun filename -> 
      try
        Sys.remove (Filesystem.Repo.commit_dir () ^ filename)
      with
      | Sys_error msg -> print_endline ("Failed to delete file " ^ filename ^ ": " ^ msg)
    ) commit_files

