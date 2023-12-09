let red = "\027[31m"
let green = "\027[32m"
let reset = "\027[0m"
let set_color text color = color ^ text ^ reset

let get_commited () =
  let committed =
    Utils.Stage.get_tracked_files () |> List.map (fun s -> "\t" ^ s)
  in
  match committed with
  | [] -> ""
  | _ ->
      "Changes to be committed: \n"
      ^ set_color (String.concat "\n" committed) green

let get_untracked () =
  let files = Utils.Filesystem.list_files () in
  let tracked = Utils.Stage.get_tracked_files () in
  let untracked =
    List.filter (fun f -> not (List.mem f tracked)) files
    |> List.map (fun s -> "\t" ^ s)
  in
  match untracked with
  | [] -> ""
  | _ -> "Untracked files: \n" ^ set_color (String.concat "\n" untracked) red

let run : Command.empty_command =
 fun () ->
  Utils.Filesystem.got_initialized "status";
  let commited = get_commited () in
  let untracked = get_untracked () in
  (* print_endline ("HI" ^ commited ^ untracked ^ "DONE") *)
  match (commited, untracked) with
  | "", "" -> "nothing to be committed, working tree clean"
  | c, "" -> c
  | "", u -> u
  | c, u -> c ^ "\n" ^ u
