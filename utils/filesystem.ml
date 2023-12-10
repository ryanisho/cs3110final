type filename = string

module Repo = struct
  let root ?(base_dir = ".") () = base_dir ^ "/repo/"
  let got_dir ?(base_dir = ".") () = root ~base_dir () ^ ".got/"
  let stage_file ?(base_dir = ".") () = got_dir ~base_dir () ^ "stage.msh"
  let commit_dir ?(base_dir = ".") () = got_dir ~base_dir () ^ "commits/"
  let blob_dir ?(base_dir = ".") () = got_dir ~base_dir () ^ "blobs/"
  let metadata_file ?(base_dir = ".") () = got_dir ~base_dir () ^ "metadata.msh"
  let log_dir ?(base_dir = ".") () = got_dir ~base_dir () ^ "logs/"
end

(* Check if [.got] directory exists in the repo *)
let got_repo_exists () = Repo.got_dir () |> Sys.file_exists

let got_initialized cmd =
  match (cmd, got_repo_exists ()) with
  | "init", true ->
      raise
        (Failure "A Got version-control system already exists in the directory.")
  | "init", false -> ()
  | _, false -> raise (Failure "not a got repository")
  | _, true -> ()

let make_empty_stage () =
  let channel = open_out (Repo.stage_file ()) in
  output_string channel "";
  close_out channel

let rec find_files files =
  match files with
  | [] -> []
  | file :: tl ->
      if Sys.file_exists (Repo.root () ^ file) then file :: find_files tl
      else raise (Failure (file ^ " does not exist."))

let list_files () =
  let root = Repo.root () in
  let root_len = String.length root in
  let rec aux acc dirs =
    match dirs with
    | [] -> acc
    | dir :: tl ->
        let contents =
          Sys.readdir dir |> Array.to_list
          |> List.filter (fun s -> s.[0] <> '.')
          |> List.map (Filename.concat dir)
        in
        let dirs, files = List.partition Sys.is_directory contents in
        aux (files @ acc) (dirs @ tl)
  in
  aux [] [ root ]
  |> List.map (fun s -> String.sub s root_len (String.length s - root_len))
  |> List.sort compare

(* Wrapper to remove files using repo root *)
(* Probably need to fix this pathing *)
let rec remove_files files : unit =
  match files with
  | [] -> ()
  | file :: tl ->
      Sys.remove (Repo.root () ^ file);
      remove_files tl

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
