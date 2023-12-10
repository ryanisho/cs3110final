let check_tracked files =
  List.iter
    (fun f ->
      if not (List.mem f (Utils.Track.get_tracked_files ())) then
        raise
          (Utils.Filesystem.File_not_found
             ("fatal: pathspec '" ^ f ^ "' did not match any files")))
    files

let remove files =
  Utils.Filesystem.remove_files files;
  Utils.Stage.remove_files_from_stage files;
  List.map (fun s -> "rm " ^ s) files |> String.concat "\n"

let rec run : Command.argumented_command =
 fun files ->
  try
    Utils.Filesystem.got_initialized "rm";
    check_tracked files;
    match files with
    | [] -> "fatal: No pathspec given. Which files should I remove?"
    | _ -> remove files
  with
  | Utils.Filesystem.File_not_found msg -> msg
  | Utils.Filesystem.Got_initialized msg -> msg
  | _ ->
      (* Handle other exceptions *)
      Unix.sleepf 1.5;
      run files
