let check_tracked files =
  let rec check_tracked' files =
    match files with
    | [] -> ()
    | f :: tl ->
        if List.mem f (Utils.Track.get_tracked_files ()) then check_tracked' tl
        else
          raise
            (Utils.Filesystem.File_not_found
               ("pathspec " ^ f ^ " does not exist."))
  in
  check_tracked' files

let remove files =
  Utils.Stage.remove_files_from_stage files;
  Utils.Filesystem.remove_files files;
  List.map (fun s -> "rm " ^ s) files |> String.concat "\n"

let rec run (files : string list) =
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
