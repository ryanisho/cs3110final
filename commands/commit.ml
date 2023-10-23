module Commit : Utils.Command.ArgCommand = struct
  let run (args : string list) : string =
    let stage = Utils.Stage.marshal_from_stage_file () in
    let message = List.hd args in
    let timestamp = Utils.Commit.write_commit stage message in
    "Committed " ^ timestamp ^ "."
end
