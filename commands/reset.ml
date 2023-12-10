let reset_commit_history_to (timestamp : Utils.Filesystem.filename) =
  let commit_history = Utils.Commit.get_commit_history_from_head () in
  let commit =
    List.find
      (fun (c : Utils.Commit.t) -> c.timestamp = timestamp)
      commit_history
  in
  let metadata = Utils.Repo_metadata.read_from_file () in
  Utils.Repo_metadata.write_to_file
    {
      head = metadata.head;
      branches =
        (metadata.head, commit.timestamp)
        :: List.remove_assoc metadata.head metadata.branches;
    }

let run = function
  | [ "--hard"; timestamp ] -> (
      try
        Utils.Commit.restore_working_dir_to timestamp;
        reset_commit_history_to timestamp;
        "Reset repository and commit history to commit " ^ timestamp
      with _ ->
        "Error: could not reset repository and commit history to that commit!")
  | timestamp :: [] -> (
      try
        reset_commit_history_to timestamp;
        "Reset commit history to commit " ^ timestamp
      with _ -> "Error: could not reset commit history to that commit!")
  | _ -> "Usage: got reset [--hard] <timestamp>"
