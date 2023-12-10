let all_branches () : string =
  let metadata = Utils.Repo_metadata.read_from_file () in
  List.fold_left
    (fun acc (branch, timestamp) ->
      acc
      ^ (if branch = metadata.head then "(*) " else "    ")
      ^ branch ^ " -> " ^ timestamp ^ "\n")
    "" metadata.branches

let run = function
  | [ "-D"; branch_name ] -> "Not implemented - Deleted branch " ^ branch_name
  | [] ->
      let s = all_branches () in
      String.sub s 0 (String.length s - 1)
  | _ -> "Usage: git branch [-D <branch>]"
