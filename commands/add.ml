let rec run : Command.argumented_command =
  fun files ->
  Utils.Filesystem.got_initialized ();
  try
    match files with
    | [] -> "No file added."
    | _ ->
      Utils.Stage.add_files_to_stage files;
      "Added " ^ String.concat " " files
  with
  | _ ->
    (* Handle other exceptions *)
    Unix.sleepf 1.5; 
    run files

