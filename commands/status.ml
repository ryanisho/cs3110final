let get_commited () =
  let committed = Utils.Stage.get_tracked_files () in
  match committed with
  | [] -> ""
  | _ -> "Changes to be committed: \n" ^ String.concat "\n" committed

let get_untracked () =
  let files = Utils.Filesystem.list_files () in
  let tracked = Utils.Stage.get_tracked_files () in
  let untracked = List.filter (fun f -> not (List.mem f tracked)) files in
  match untracked with
  | [] -> ""
  | _ -> "Untracked files: \n" ^ String.concat "\n" untracked

let run : Command.empty_command =
 fun () ->
  let commited = get_commited () in
  let untracked = get_untracked () in
  match (commited, untracked) with
  | "", "" -> "nothing to be committed, working tree clean"
  | c, "" -> c
  | "", u -> u
  | c, u -> c ^ "\n" ^ u
