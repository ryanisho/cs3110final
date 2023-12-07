open OUnit2
open Commands

(* helper test functions *)
let test_add files _ = 
  let result = Commands.Add.run files in
  assert_equal ("Added " ^ String.concat " " files) result

let test_commit messages expected_message _ = 
  let result = Commands.Commit.run messages in
  let startswith_committed = String.sub result 0 9 = "Committed" in
  let contains_message = String.contains result ':' && String.sub 
                           result (String.index result ':' + 3) 
                           (String.length expected_message) = expected_message in
  assert_bool "Output does not start with 'Committed'" startswith_committed;
  assert_bool "Output does not contain the correct commit message" contains_message

let test_log expected_log_entries _ =
  let result = Commands.Log.run () in
  assert_equal expected_log_entries result ~printer:(fun x -> x)

(* Function to capture timestamp from commit *)
let commit_and_get_log_entry message =
  ignore (Commands.Commit.run [message]); (* Commit the message *)
  match Utils.Commit.retrieve_latest_commit_filename () with
  | Some filename ->
    let commit = Utils.Commit.fetch_commit filename in
    "[" ^ commit.timestamp ^ "] " ^ message (* Construct the log entry *)
  | None ->
    failwith "No commit found"

(* test cases *)
let add = [
  "test with no files" >:: (fun _ -> 
      let result = Commands.Add.run [] in
      assert_equal "No file added." result);
  "test with one file" >:: test_add ["../test/test/txt/apples.txt"];
  "test with multiple files" >:: test_add ["../test/test/txt/apples.txt";
                                           "../test/test/txt/loremipsum.txt"];
  "test with images" >:: test_add ["../test/test/img/james.png"];
  "test with multiple images" >:: test_add ["../test/test/img/james.png";
                                            "../test/test/img/chris.png"];
  "test with audio" >:: test_add ["../test/test/mp3/river.mp3"];
  "test with multiple audio" >:: test_add ["../test/test/mp3/river.mp3";
                                           "../test/test/mp3/walking.mp3"];
  "test with images and audio and text" >:: test_add ["../test/test/txt/apples.txt";
                                                      "../test/test/img/james.png";
                                                      "../test/test/mp3/river.mp3"];
]

let commit = [
  "test commit with no message" >:: test_commit [""] "";
  "test commit with simple message" >:: test_commit ["Initial commit"] 
    "Initial commit";
  "test commit with complex message" >:: test_commit 
    ["Added new feature with multiple fixes"] "Added new feature with multiple fixes";
  "test commit with special characters" >:: test_commit ["No special characters: !@#$%^&*()_+"] 
    "No special characters: !@#$%^&*()_+";
  "test commit with very long message" >:: test_commit [String.make 255 'a'] 
    (String.make 255 'a');
  "test commit with multiline message" >:: test_commit ["First line"; "Second line"] 
    "First line Second line";
  "test commit with empty message and no changes" >:: test_commit [""] "";
  "test commit with message but no changes" >:: test_commit ["Minor update"] 
    "Minor update";
  "test commit with escape characters in message" >:: test_commit 
    ["Fix line breaks\nand tabs\t"] "Fix line breaks\nand tabs\t";
  "test commit with excessively long message" >:: test_commit [String.make 1000 'b'] 
    (String.make 255 'b');  
  "test commit with invalid characters in message" >:: test_commit 
    ["Invalid char \255 here"] "Invalid char \255 here";
]

let log = [
  "test log with no commits" >:: (fun _ ->
      let log_entry = commit_and_get_log_entry "" in
      test_log log_entry ());
  "test log with one commit" >:: (fun _ ->
      let log_entry = commit_and_get_log_entry "Initial commit" in
      test_log log_entry ());
  (*Working progress*)
]

(* test suite driver *)
let tests = List.flatten [
    add;
    commit;
    log;
  ]
let suite = "got test suite" >::: tests
let _ = run_test_tt_main suite

