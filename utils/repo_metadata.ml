type t = {
  head : Filesystem.filename option;
  branches : (string * Filesystem.filename) list;
}

let write_to_file (m : t) =
  Filesystem.marshal_data_to_file m (Filesystem.Repo.metadata_file ())

let empty (initial_commit_timestamp : Filesystem.filename) =
  {
    head = Some initial_commit_timestamp;
    branches = [ ("master", initial_commit_timestamp) ];
  }
