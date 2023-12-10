let red = "\027[31m"
let green = "\027[32m"
let reset = "\027[0m"
let black = "\027[30m"
let gray = "\027[90m"
let bright_red = "\027[91m"
let bright_green = "\027[92m"
let bright_yellow = "\027[93m"
let bright_blue = "\027[94m"
let bright_magenta = "\027[95m"
let bright_cyan = "\027[96m"
let bright_white = "\027[97m"
let dark_gray = "\027[30;1m"
let light_red = "\027[31;1m"
let light_green = "\027[32;1m"
let light_yellow = "\027[33;1m"
let light_blue = "\027[34;1m"
let light_magenta = "\027[35;1m"
let light_cyan = "\027[36;1m"
let white = "\027[37;1m"
let set_color text color = color ^ text ^ reset

let get_commited () =
  let committed =
    Utils.Stage.get_staged_files () |> List.map (fun s -> "\t" ^ s)
  in
  match committed with
  | [] -> ""
  | _ ->
      "Changes to be committed: \n"
      ^ set_color (String.concat "\n" committed) green

let get_untracked () =
  let files = Utils.Filesystem.list_files () in
  let tracked = Utils.Track.get_tracked_files () in
  let untracked =
    List.filter (fun f -> not (List.mem f tracked)) files
    |> List.map (fun s -> "\t" ^ s)
  in
  match untracked with
  | [] -> ""
  | _ -> "Untracked files: \n" ^ set_color (String.concat "\n" untracked) red

let rec run : Command.empty_command =
 fun () ->
  try
    Utils.Filesystem.got_initialized "status";
    let commited = get_commited () in
    let untracked = get_untracked () in
    (* print_endline ("HI" ^ commited ^ untracked ^ "DONE") *)
    match (commited, untracked) with
    | "", "" -> "nothing to be committed, working tree clean"
    | c, "" -> c
    | "", u -> u
    | c, u -> c ^ "\n" ^ u
  with
  | Utils.Filesystem.Got_initialized msg -> msg
  | _ ->
      (* Handle other exceptions *)
      Unix.sleepf 1.5;
      run ()
