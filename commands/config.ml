exception Invalid_flag of string

let usage_msg = "usage: make got config [<options>]"

let actions =
  [
    Printf.sprintf
      "%-20s set colors for [got status] with [tracked=color] or \
       [untracked=color]"
      "--set-color";
    Printf.sprintf "%-20s get color for [got status]" "--get-color";
    Printf.sprintf "%-20s get all colors for [got status]" "--get-all-colors";
  ]

let action_msg =
  "Action" ^ "\n" ^ String.concat "\n" (List.map (fun s -> "\t" ^ s) actions)

let config_msg = usage_msg ^ "\n\n" ^ action_msg

let rec run : Command.argumented_command =
 fun cmd ->
  try
    Utils.Filesystem.got_initialized "config";
    match cmd with
    | [] -> config_msg
    | argument :: tl -> (
        match argument with
        | "--set-color" -> failwith "TODO"
        | "--get-color" -> failwith "TODO"
        | "--get-all-colors" -> String.concat " " Utils.Colors.all_colors
        | _ -> raise (Invalid_flag "fatal: invalid option"))
  with
  | Utils.Filesystem.Got_initialized msg -> msg
  | _ ->
      (* Handle other exceptions *)
      Unix.sleepf 1.5;
      run cmd
