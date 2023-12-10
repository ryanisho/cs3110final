let rec run : Command.argumented_command =
 fun args ->
  try
    Utils.Filesystem.got_initialized "commit";
    let stage = Utils.Stage.marshal_from_stage_file () in
    if List.length stage = 0 then "Nothing to commit, staging area is empty."
    else
      (* TEMP FIX: flatten all args into message *)
      (* TODO: fix Makefile to handle "" properly *)
      let message = List.fold_left (fun x y -> x ^ " " ^ y) "" args in
      let message = String.sub message 1 (String.length message - 1) in
      let timestamp, changes = Utils.Commit.write_commit stage message in
      "Committed " ^ timestamp ^ " :: " ^ message ^ "\n" ^ changes
  with
  | Utils.Filesystem.Got_initialized msg -> msg
  | _ ->
      Unix.sleepf 1.5;
      run args
