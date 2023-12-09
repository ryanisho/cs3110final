let is_tracked files =
  let rec is_tracked' files =
    match files with
    | [] -> []
    | f :: tl ->
        if List.mem f (Utils.Stage.get_tracked_files ()) then
          f :: is_tracked' tl
        else raise (Failure ("pathspec " ^ f ^ " does not exist."))
  in
  is_tracked' files

let remove files =
  Utils.Stage.remove_files_from_stage files;
  (* This will delete the files fr - uncomment when necssary *)
  (* Utils.Filesystem.remove_files files; *)
  List.map (fun s -> "rm " ^ s) files |> String.concat "\n"

let run : Command.argumented_command =
 fun files ->
  Utils.Filesystem.got_initialized "rm";
  let files = is_tracked files in
  match files with
  | [] -> "fatal: No pathspec given. Which files should I remove?"
  | _ -> remove files
