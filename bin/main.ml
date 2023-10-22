open Commands

let () =
  let args = List.tl (Array.to_list Sys.argv) in
  let output =
    match args with
    | "init" :: _ -> Commands.Init.run ()
    | [] -> "Usage: got [init]"
    | _ -> "Command not supported!"
  in
  print_endline output
