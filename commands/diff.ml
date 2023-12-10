let run_patdiff_and_capture_output dir1 dir2 =
  let command = Printf.sprintf "patdiff %s %s" dir1 dir2 in
  let process_in = Unix.open_process_in command in
  let output = ref "" in
  (try
     while true do
       output := !output ^ input_line process_in ^ "\n"
     done
   with End_of_file -> ());
  ignore (Unix.close_process_in process_in);
  !output

let rec run : Command.empty_command =
 fun () ->
  (* try *)
  Utils.Filesystem.got_initialized "diff";
  let tracked_file_hashes = Utils.Track.get_tracked_file_hash_pairs () in
  let committed_file_hashes =
    Utils.Commit.fetch_latest_commit_file_hash_pairs ()
  in
  let tracked_dir = Utils.Filesystem.make_temp_dir "tracked" in
  let committed_dir = Utils.Filesystem.make_temp_dir "committed" in
  Utils.Blob.populate_dir_from_hashes tracked_dir tracked_file_hashes;
  print_endline "1";
  Utils.Blob.populate_dir_from_hashes committed_dir committed_file_hashes;
  print_endline "2";
  let diff = run_patdiff_and_capture_output tracked_dir committed_dir in
  Sys.rmdir tracked_dir;
  Sys.rmdir committed_dir;
  diff

(* with | Utils.Filesystem.Got_initialized msg -> msg | exception of e -> "fuck
   you" *)
(* Handle other exceptions *)
(* Unix.sleepf 1.5; run () *)
