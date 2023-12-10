type t = {
  hash : Hash.t;
  contents : string;
}

let make_blob file =
  { hash = Hash.hash_file file; contents = Filesystem.string_of_file file }

(* Return a list of all blobs in the blob directory *)
(* Write blob to blob directory *)
let write_blob file =
  let blob = make_blob file in
  let blob_dir = Filesystem.Repo.blob_dir () in
  let blob_path = blob_dir ^ blob.hash ^ ".msh" in
  Filesystem.marshal_data_to_file blob.contents blob_path

let write_blobs files = List.iter write_blob files

(* Return an option for a blob with the hash; return None if no such blob
   exists *)
let get_blob hash =
  if Sys.file_exists (Filesystem.Repo.blob_dir () ^ hash ^ ".msh") then
    Filesystem.Repo.blob_dir () ^ hash ^ ".msh"
  else ""

(* Get the contents of a blob *)
let get_blob_contents hash =
  let blob = get_blob hash in
  Filesystem.marshal_file_to_data blob |> fun c -> c.contents

(* Put it in here or there will be a circular dependency *)
let populate_dir_from_hashes dir file_hash =
  let file_content =
    List.map (fun (f, h) -> (f, get_blob_contents h)) file_hash
  in
  List.iter
    (fun (file, content) ->
      let file_path = dir ^ file in
      let channel = open_out file_path in
      output_string channel content;
      close_out channel)
    file_content
