open Utils
(* open Commit *)

module Init : Command.EmptyCommand = struct
  let run () : string =
    if Sys.file_exists ".got" then
      raise
        (Failure
           "A Got version-control system already exists in the current \
            directory.")
    else
      let () = Sys.mkdir (Constants.repo_root () ^ ".got") 0o755 in
      let () = Sys.mkdir (Constants.repo_root () ^ ".got/blobs") 0o755 in
      let () = Sys.mkdir (Constants.repo_root () ^ ".got/commits") 0o755 in
      let () =
        let out_channel =
          open_out (Constants.repo_root () ^ ".got/stage.msh")
        in
        output_string out_channel "";
        close_out out_channel
      in
      "Initialized empty repository."
end
