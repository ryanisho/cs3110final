open Utils

module Add : Command.ArgCommand = struct
  let run files =
    match files with
    | [] -> "No file added."
    | _ ->
        let _ = Stage.marshal_to_stage files in
        "Added " ^ String.concat " " files
end
