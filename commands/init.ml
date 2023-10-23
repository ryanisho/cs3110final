open Utils
(* open Commit *)

module Init : Command.EmptyCommand = struct
  let run () : string =
    if Sys.file_exists (Filesystem.Repo.got_dir ()) then
      raise
        (Failure
           "A Got version-control system already exists in the current \
            directory.")
<<<<<<< HEAD
    else Sys.mkdir (Filesystem.Repo.got_dir ()) 0o755;
    Sys.mkdir (Filesystem.Repo.blob_dir ()) 0o755;
    Sys.mkdir (Filesystem.Repo.commit_dir ()) 0o755;
    Stage.marshal_from_filenames_to_stage_file [];
    "Initialized empty repository."
=======
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
>>>>>>> 81e06c601635e685d54c9a34863fa172b7b6a95d
end
