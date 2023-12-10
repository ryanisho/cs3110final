let rec run (args : string list) =
  try
    Utils.Filesystem.got_initialized "commit";
    let stage = Utils.Stage.marshal_from_stage_file () in
    if List.length stage = 0 then "Nothing to commit, staging area is empty."
    else
      match args with
      | [ "-m"; message ] ->
          let timestamp, changes = Utils.Commit.write_commit stage message in
          "Committed " ^ timestamp ^ " :: " ^ message ^ "\n" ^ changes
      | _ -> "Usage: got commit -m <msg>"
  with
  | Utils.Filesystem.Got_initialized msg -> msg
  | _ ->
      Unix.sleepf 1.5;
      run args
