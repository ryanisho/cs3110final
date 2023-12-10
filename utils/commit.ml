open Blob

type t = {
  timestamp : string;
  message : string;
  parent : Filesystem.filename option;
  merge_parent : Filesystem.filename option;
  changes : (Filesystem.filename * Hash.t * Stage.mode) list;
}

let retrieve_head_commit_filename () : Filesystem.filename option =
  let metadata = Repo_metadata.read_from_file () in
  List.assoc_opt metadata.head metadata.branches

let fetch_commit (timestamp : Filesystem.filename) : t =
  Filesystem.marshal_file_to_data (Filesystem.Repo.commit_dir () ^ timestamp)

let fetch_head_commit () =
  let commit_name = retrieve_head_commit_filename () in
  match commit_name with
  | Some c -> Some (fetch_commit c)
  | None -> None

let fetch_head_commit_changes () =
  let commit = fetch_head_commit () in
  match commit with
  | None -> []
  | Some c -> c.changes

let fetch_head_commit_files () =
  fetch_head_commit_changes () |> List.map (fun (name, hash, mode) -> name)

let join_changes stage =
  let prev_changes = fetch_head_commit_changes () in
  let curr_changes =
    List.map
      (fun (file_metadata : Stage.file_metadata) ->
        (file_metadata.name, file_metadata.hash, file_metadata.modification))
      stage
  in
  List.fold_left
    (fun acc (file, hash, mode) ->
      if List.exists (fun (prev_file, _, _) -> prev_file = file) acc then
        List.map
          (fun (prev_file, prev_hash, prev_mode) ->
            if prev_file = file then
              match mode with
              (* Spaghetti - fix later *)
              | Stage.Create | Stage.Edit ->
                  if prev_mode = Stage.Create then (file, hash, Stage.Edit)
                  else (file, hash, Stage.Create)
              | Stage.Delete -> (file, hash, mode)
            else (prev_file, prev_hash, prev_mode))
          acc
      else (file, hash, mode) :: acc)
    prev_changes curr_changes

let remove_deleted_files changes : (string * string * Stage.mode) list =
  List.filter (fun (_, _, mode) -> mode <> Stage.Delete) changes

let list_changes changes =
  List.map
    (fun (name, hash, mode) ->
      let prefix =
        match mode with
        | Stage.Create -> "create mode  "
        | Stage.Edit -> "edit mode    "
        | Stage.Delete -> "delete mode "
      in
      prefix ^ " " ^ name)
    changes
  |> String.concat "\n"

let write_commit (stage : Stage.t) (message : string) : string * string =
  let metadata = Repo_metadata.read_from_file () in
  let current_branch = metadata.head in
  let complete_changes = join_changes stage in
  let commit : t =
    {
      timestamp = string_of_int (int_of_float (Unix.time ()));
      message;
      parent = Some (List.assoc current_branch metadata.branches);
      merge_parent = None;
      changes = complete_changes |> remove_deleted_files;
    }
  in
  (Filesystem.marshal_data_to_file : t -> string -> unit)
    commit
    (Filesystem.Repo.commit_dir () ^ commit.timestamp);
  Filesystem.make_empty_stage ();
  (* Update metadata *)
  let metadata : Repo_metadata.t =
    {
      head = current_branch;
      branches =
        (current_branch, commit.timestamp)
        :: List.remove_assoc current_branch metadata.branches;
    }
  in
  Repo_metadata.write_to_file metadata;
  (commit.timestamp, complete_changes |> list_changes)

let write_initial_commit () : string * string =
  let commit : t =
    {
      timestamp = string_of_int (int_of_float (Unix.time ()));
      message = "Initial commit";
      parent = None;
      merge_parent = None;
      changes = [];
    }
  in
  (Filesystem.marshal_data_to_file : t -> string -> unit)
    commit
    (Filesystem.Repo.commit_dir () ^ commit.timestamp);
  (commit.timestamp, [] |> list_changes)

let get_commit_history_from_head () : t list =
  let rec helper (child_timestamp : Filesystem.filename) =
    let child_commit = fetch_commit child_timestamp in
    match child_commit.parent with
    | None -> [ child_commit ]
    | Some parent_timestamp -> child_commit :: helper parent_timestamp
  in
  match retrieve_head_commit_filename () with
  | None -> []
  | Some head_commit_filename -> helper head_commit_filename

let retrieve_all_commit_filenames () : Filesystem.filename list =
  Filesystem.Repo.commit_dir ()
  |> Sys.readdir |> Array.to_list |> List.sort compare

let clear_commit_history () =
  let commit_files = retrieve_all_commit_filenames () in
  List.iter
    (fun filename ->
      try Sys.remove (Filesystem.Repo.commit_dir () ^ filename)
      with Sys_error msg ->
        print_endline ("Failed to delete file " ^ filename ^ ": " ^ msg))
    commit_files
