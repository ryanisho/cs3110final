let rec run : string list -> Command.empty_command =
 fun args () ->
  try
    Utils.Filesystem.got_initialized "init";
    let base_dir =
      match args with
      | [] -> "."
      | base_dir :: _ -> base_dir
    in
    let got_dir = Utils.Filesystem.Repo.got_dir ~base_dir () in
    Sys.mkdir got_dir 0o755;
    Sys.mkdir (Utils.Filesystem.Repo.blob_dir ~base_dir ()) 0o755;
    Sys.mkdir (Utils.Filesystem.Repo.commit_dir ~base_dir ()) 0o755;
    Sys.mkdir (Utils.Filesystem.Repo.branch_dir ~base_dir ()) 0o755;
    Sys.mkdir (Utils.Filesystem.Repo.log_dir ~base_dir ()) 0o755;
    Utils.Filesystem.make_empty_stage ();
    "Initialized empty repository in " ^ Sys.getcwd () ^ base_dir
    (* May need to fix this pathing *)
  with
  | Utils.Filesystem.Got_initialized msg -> msg
  | _ ->
      (* Handle other exceptions *)
      Unix.sleepf 1.5;
      run args ()
