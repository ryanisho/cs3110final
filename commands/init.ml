open Utils

module Init : Command.EmptyCommand = struct
  let run () : string =
    if Sys.file_exists ".got" then
      raise
        (Failure
           "A Got version-control system already exists in the current \
            directory.")
    else
      let () = Sys.mkdir ".got" 0o755 in
      "Initialized empty repository."
end
