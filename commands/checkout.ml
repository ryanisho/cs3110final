let create_branch (branch_name : string) : unit =
  let metadata = Utils.Repo_metadata.read_from_file () in
  let current_commit_timestamp = List.assoc metadata.head metadata.branches in
  if List.mem_assoc branch_name metadata.branches then
    failwith "Error: branch already exists!"
  else
    Utils.Repo_metadata.write_to_file
      {
        head = branch_name;
        branches = (branch_name, current_commit_timestamp) :: metadata.branches;
      }

let switch_to_branch (branch_name : string) : unit =
  let metadata = Utils.Repo_metadata.read_from_file () in
  Utils.Commit.restore_working_dir_to (List.assoc branch_name metadata.branches);
  Utils.Repo_metadata.write_to_file
    { head = branch_name; branches = metadata.branches }

let run = function
  | [ "-b"; new_branch_name ] ->
      create_branch new_branch_name;
      "Created and switched to branch " ^ new_branch_name
  | [ branch_name ] ->
      switch_to_branch branch_name;
      "Switched to branch " ^ branch_name
  | _ -> "Usage: got checkout [-b] <branch>"
