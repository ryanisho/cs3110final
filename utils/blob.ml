(* TOOD: encapsulate in module? *)

type t = {
  hash : Hash.t;
  contents : string;
}

(* Write blob to blob directory *)
let write_blob blob =
  let blob_dir = Filesystem.Repo.blob_dir () in
  let blob_path = blob_dir ^ blob.hash in
  Filesystem.marshal_data_to_file blob blob_path

(* Return an option for a blob with the hash; return None if no such blob
   exists *)
let get_blob hash =
  Sys.readdir (Filesystem.Repo.blob_dir ())
  |> Array.to_list
  |> List.find_opt (fun b -> b = hash)

(* Get the contents of a blob; raise Failure if no such blob exists *)
let get_blob_contents hash =
  get_blob hash |> Option.get |> Filesystem.marshal_file_to_data
