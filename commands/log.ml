module Log : Utils.Command.EmptyCommand = struct
  let commit_to_log_entry (commit : Utils.Commit.t) =
    "[" ^ commit.timestamp ^ "] " ^ commit.message ^ "\n"

  let run () : string =
    let commit_history = Utils.Commit.get_full_commit_history () in
    let output =
      commit_history |> List.map commit_to_log_entry |> List.fold_left ( ^ ) ""
    in
    String.sub output 0 (String.length output - 1)
end
