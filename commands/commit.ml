open Utils

module Commit : Command.ArgCommand = struct
  let files_in_stage () =
    let stage = ".got/stage.json" in
    let in_channel = open_in stage in
    try
      let _ = input_line in_channel in
      close_in in_channel
    with
    | End_of_file -> raise (Failure "No changes added to the commit")
    | _ -> ()

  let add_blobs files =
    match files with
    | [] -> "FOO"
    | h :: t -> "FUCK"

  let add_commits files = "FUCK"

  let clean_stage () =
    let stage_path = ".got/stage" in
    let out_channel = open_out stage_path in
    output_string out_channel "";
    close_out out_channel

  let run args =
    (* let files = files_in_stage in *)
    let _ = clean_stage in
    "TODO"

  (* let commit msg = *)
end
