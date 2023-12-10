let commit_to_log_entry (commit : Utils.Commit.t) =
  "[" ^ commit.timestamp ^ "] " ^ commit.message ^ "\n"

let rec run : Command.empty_command =
 fun () ->
  try
    Utils.Filesystem.got_initialized "log";
    let commit_history = Utils.Commit.get_full_commit_history () in
    let output =
      commit_history |> List.map commit_to_log_entry |> List.fold_left ( ^ ) ""
    in
    String.sub output 0 (String.length output - 1)
  with
  | Utils.Filesystem.Got_initialized msg -> msg
  | _ ->
      (* Handle other exceptions *)
      Unix.sleepf 1.5;
      run ()
