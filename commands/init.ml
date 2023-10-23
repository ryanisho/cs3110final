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
      let () = Sys.mkdir (Fs.Repo.got_dir ()) 0o755 in
      let () = Sys.mkdir (Fs.Repo.blob_dir ()) 0o755 in
      let () = Sys.mkdir (Fs.Repo.commit_dir ()) 0o755 in
      let () =
        let out_channel = open_out (Fs.Repo.stage_file ()) in
        output_string out_channel "";
        close_out out_channel
      in
      "Initialized empty repository."
end
