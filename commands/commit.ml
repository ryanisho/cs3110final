module Commit : Utils.Command.ArgCommand = struct
  let run (args : string list) : string =
    let stage = Utils.Stage.marshal_from_stage_file () in
    (* TEMP FIX: flatten all args into message *)
    (* TODO: fix Makefile to handle "" properly *)
    let message = List.fold_left (fun x y -> x ^ " " ^ y) "" args in
    let message = String.sub message 1 (String.length message - 1) in
    let timestamp = Utils.Commit.write_commit stage message in
    "Committed " ^ timestamp ^ " :: " ^ message
end
