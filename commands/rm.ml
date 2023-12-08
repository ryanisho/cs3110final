let is_tracked file =
  let tracked_files = Utils.Stage.get_staged_files () in
  let rec is_tracked' f staged =
    match staged with
    | [] -> false
    | h :: t -> if h = f then true else is_tracked' f t
  in
  is_tracked' file tracked_files

let rec remove files =
  match files with
  | [] -> ()
  | file :: tl -> (
      Utils.Filesystem.remove_file file;
      match is_tracked file with
      | true ->
          Utils.Stage.remove_from_stage file;
          remove tl
      | false -> raise (Failure ("No reason to remove " ^ file ^ ".")))

let run : Command.argumented_command =
 fun files ->
  match files with
  | [] -> "fatal: No pathspec given. Which files should I remove?"
  (* This implementation does not remove the file locally *)
  | _ ->
      Utils.Filesystem.find_files files;
      remove files;
      String.concat "\n" (List.map (fun file -> "rm " ^ file) files)
