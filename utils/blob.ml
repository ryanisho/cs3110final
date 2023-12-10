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
  let blob_path = blob_dir ^ blob.hash in
  Filesystem.marshal_data_to_file blob.contents blob_path

let write_blobs files = List.iter write_blob files

(* Return an option for a blob with the hash; return None if no such blob
   exists *)
let get_blob hash =
  Sys.readdir (Filesystem.Repo.blob_dir ())
  |> Array.to_list
  |> List.find_opt (fun b -> b = hash)

(* Get the contents of a blob *)
let get_blob_contents hash =
  get_blob hash |> Option.get |> Filesystem.marshal_file_to_data |> fun c ->
  c.contents
