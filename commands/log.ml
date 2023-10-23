module Log : Utils.Command.EmptyCommand = struct
  let commit_to_log_entry (commit : Utils.Commit.t) =
    commit.timestamp ^ " :: " ^ commit.message ^ "\n"

  let run () : string =
    let commit_history = Utils.Commit.get_full_commit_history () in
    commit_history |> List.map commit_to_log_entry |> List.fold_left ( ^ ) ""
end
