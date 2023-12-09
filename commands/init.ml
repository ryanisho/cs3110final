let run : string list -> Command.empty_command =
 fun args ->
  let base_dir =
    match args with
    | [] -> "."
    | base_dir :: _ -> base_dir
  in
  let got_dir = Utils.Filesystem.Repo.got_dir ~base_dir () in
  if Sys.file_exists got_dir then
    raise
      (Failure "A Got version-control system already exists in the directory.")
  else Sys.mkdir got_dir 0o755;
  Sys.mkdir (Utils.Filesystem.Repo.blob_dir ~base_dir ()) 0o755;
  Sys.mkdir (Utils.Filesystem.Repo.commit_dir ~base_dir ()) 0o755;
  Sys.mkdir (Utils.Filesystem.Repo.branch_dir ~base_dir ()) 0o755;
  Sys.mkdir (Utils.Filesystem.Repo.log_dir ~base_dir ()) 0o755;
  Utils.Filesystem.make_stage ();
  fun () -> "Initialized empty repository in " ^ Sys.getcwd () ^ base_dir
(* May need to fix this pathing *)
