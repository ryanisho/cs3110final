let union lst1 lst2 =
  List.fold_left
    (fun acc x -> if List.mem x acc then acc else x :: acc)
    lst1 lst2

let get_tracked_files () =
  let staged = Stage.get_staged_files () in
  let committed = Commit.fetch_latest_commit_files () in
  union staged committed

let get_tracked_hashes () =
  let staged_hashes = Stage.get_staged_hashes () in
  let committed_hahes = Commit.fetch_latest_commit_hashes () in
  union staged_hashes committed_hahes

let get_tracked_file_hash_pairs () =
  let staged_file_hash = Stage.get_staged_name_hash_pairs () in
  let committed_file_hash = Commit.fetch_latest_commit_file_hash_pairs () in
  union staged_file_hash committed_file_hash

let untrack_file file = failwith "TODO"
