open Utils

type file_metadata = {
  hash : int;
  contents : string;
}

module Add : Command.ArgCommand = struct
  let string_of_file file =
    if Sys.file_exists file then (
      let ic = open_in file in
      let buf = Buffer.create (in_channel_length ic) in
      try
        while true do
          let line = input_line ic in
          Buffer.add_string buf line
        done;
        assert false (* This line is not expected to be reached *)
      with
      | End_of_file ->
          close_in ic;
          Buffer.contents buf
      | e ->
          close_in ic;
          (* Make sure to close the input channel in case of any other
             exceptions *)
          raise e)
    else raise (Failure "File does not exist")

  let add stage file =
    if Sys.file_exists file then
      let out_channel = open_out stage in
      output_string out_channel
        (file ^ ", "
        ^ string_of_int (Utils.Hash.hash file)
        ^ ", " ^ string_of_file file)
    else raise (Failure "File does not exist")

  let run files =
    let stage = ".got/stage.txt" in
    match files with
    | [] -> "No file added!"
    | file :: t ->
        add stage file;
        "Added " ^ file
end
