module Repo = struct
  let root () = "repo/"
  let got_dir () = root () ^ ".got/"
  let stage_file () = got_dir () ^ "stage.msh"
  let commit_dir () = got_dir () ^ "commits/"
  let blob_dir () = got_dir () ^ "blobs/"
end

let string_of_file file =
  let ic = open_in (Repo.root () ^ file) in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  Bytes.to_string s
