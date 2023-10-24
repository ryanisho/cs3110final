module Add : Command.ArgCommand = struct
  let run files =
    match files with
    | [] -> "No file added."
    | _ ->
        Utils.Stage.marshal_from_filenames_to_stage_file files;
        "Added " ^ String.concat " " files
end
