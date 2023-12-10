let get_tracked_files () =
  let staged = Stage.get_staged_files () in
  let committed = Commit.fetch_latest_commit_files () in
  let union lst1 lst2 =
    List.fold_left
      (fun acc x -> if List.mem x acc then acc else x :: acc)
      lst1 lst2
  in
  union staged committed

let untrack_file file = failwith "TODO"
