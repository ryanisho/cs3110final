let all_branches () : string =
  let metadata = Utils.Repo_metadata.read_from_file () in
  List.fold_left
    (fun acc (branch, timestamp) ->
      acc
      ^ (if branch = metadata.head then "(*) " else "    ")
      ^ branch ^ " -> " ^ timestamp ^ "\n")
    "" metadata.branches

let delete_branch (branch_name : string) =
  let metadata = Utils.Repo_metadata.read_from_file () in
  if metadata.head = branch_name then
    failwith "Error: cannot delete current branch!"
  else if not (List.mem_assoc branch_name metadata.branches) then
    failwith ("Cannot delete branch " ^ branch_name)
  else
    Utils.Repo_metadata.write_to_file
      {
        head = metadata.head;
        branches = List.remove_assoc branch_name metadata.branches;
      }

let run = function
  | [ "-D"; branch_name ] ->
      delete_branch branch_name;
      "Deleted branch " ^ branch_name
  | [] ->
      let s = all_branches () in
      String.sub s 0 (String.length s - 1)
  | _ -> "Usage: git branch [-D <branch>]"
