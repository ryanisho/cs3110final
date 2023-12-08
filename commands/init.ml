let run : Command.empty_command =
 fun () ->
  if Sys.file_exists (Utils.Filesystem.Repo.got_dir ()) then
    raise
      (Failure
         "A Got version-control system already exists in the current directory.")
  else Sys.mkdir (Utils.Filesystem.Repo.got_dir ()) 0o755;
  Sys.mkdir (Utils.Filesystem.Repo.blob_dir ()) 0o755;
  Sys.mkdir (Utils.Filesystem.Repo.commit_dir ()) 0o755;
  Sys.mkdir (Utils.Filesystem.Repo.branch_dir ()) 0o755;
  Sys.mkdir (Utils.Filesystem.Repo.log_dir ()) 0o755;
  Utils.Stage.marshal_from_filenames_to_stage_file [];
  "Initialized empty repository."
