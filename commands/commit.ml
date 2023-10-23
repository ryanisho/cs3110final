open Utils

module Commit : Command.ArgCommand = struct
  let run (args : string list) : string =
    let stage = Stage.marshal_from_stage_file () in
    let () = print_endline (List.nth stage 0).contents in
    "Committed."
end
