let run : Command.argumented_command =
 fun files ->
  match files with
  | [] -> "Nothing specified, nothing added."
  | _ ->
      Utils.Stage.marshal_from_filenames_to_stage_file files;
      "add " ^ String.concat " " files
