let run : Command.argumented_command =
 fun files ->
  match files with
  | [] -> "No file added."
  | _ ->
      Utils.Stage.add_files_to_stage files;
      "Added " ^ String.concat " " files
