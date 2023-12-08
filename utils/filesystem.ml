type filename = string

module Repo = struct
  let root ?(base_dir = ".") () = base_dir ^ "/repo/"
  let got_dir ?(base_dir = ".") () = root ~base_dir () ^ ".got/"
  let stage_file ?(base_dir = ".") () = got_dir ~base_dir () ^ "stage.msh"
  let commit_dir ?(base_dir = ".") () = got_dir ~base_dir () ^ "commits/"
  let blob_dir ?(base_dir = ".") () = got_dir ~base_dir () ^ "blobs/"
end

let string_of_file file =
  let ic = open_in (Repo.root () ^ file) in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  Bytes.to_string s

(* TODO: use this function in Stage *)
(* TODO: make module around marshal and parameterize module on datatype? *)
let marshal_data_to_file (data : 'a) (full_path : filename) : unit =
  let out_channel = open_out full_path in
  Marshal.to_channel out_channel (data : 'a) [];
  close_out out_channel

let marshal_file_to_data (full_path : filename) : 'a =
  let in_channel = open_in full_path in
  let data = Marshal.from_channel in_channel in
  close_in in_channel;
  data
