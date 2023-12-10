type t = {
  hash : Hash.t;
  contents : string;
}

let make_blob file =
  let file_path = Filesystem.Repo.root () ^ file in
  {
    hash = Hash.hash_file file_path;
    contents = Filesystem.string_of_file file_path;
  }

(* Write blob to blob directory *)
let write_blob blob =
  let blob_path = Filesystem.Repo.blob_dir () ^ blob.hash in
  Filesystem.string_to_file blob_path blob.contents

let write_blobs blobs = List.iter write_blob blobs

(* Get the contents of a blob *)
let get_blob_contents hash =
  let blob_path = Filesystem.Repo.blob_dir () ^ hash in
  Filesystem.string_of_file blob_path
