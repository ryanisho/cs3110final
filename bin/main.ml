let () =
  let args = List.tl (Array.to_list Sys.argv) in
  let output =
    match args with
    | "init" :: _ -> Commands.Init.run ()
    | "add" :: files -> Commands.Add.run files
    | "commit" :: args -> Commands.Commit.run args
    | "log" :: _ -> Commands.Log.run ()
    | [] -> "Usage: got [init | add (file) | commit (message) | log]"
    | _ -> "Command not supported!"
  in
  print_endline output
