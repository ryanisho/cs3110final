open Utils
(* open Commit *)

module Init : Command.EmptyCommand = struct
  let run () : string =
    if Sys.file_exists (Filesystem.Repo.got_dir ()) then
      raise
        (Failure
           "A Got version-control system already exists in the current \
            directory.")
    else Sys.mkdir (Filesystem.Repo.got_dir ()) 0o755;
    Sys.mkdir (Filesystem.Repo.blob_dir ()) 0o755;
    Sys.mkdir (Filesystem.Repo.commit_dir ()) 0o755;
    Stage.marshal_from_filenames_to_stage_file [];
    "Initialized empty repository."
end
