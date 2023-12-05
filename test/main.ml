open OUnit2
open Commands

(* helper test functions *)
let test_add files _ = 
  let result = Commands.Add.run files in
  assert_equal ("Added " ^ String.concat " " files) result

let test_commit messages expected_message _ = 
  let result = Commands.Commit.run messages in
  let startswith_committed = String.sub result 0 9 = "Committed" in
  let contains_message = String.contains result ':' && String.sub result (String.index result ':' + 3) (String.length expected_message) = expected_message in
  assert_bool "Output does not start with 'Committed'" startswith_committed;
  assert_bool "Output does not contain the correct commit message" contains_message


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
  "test commit with simple message" >:: test_commit ["Initial commit"] "Initial commit";
  "test commit with complex message" >:: test_commit ["Added new feature with multiple fixes"] "Added new feature with multiple fixes";
  "test commit with special characters" >:: test_commit ["Fix: Handle the issue #123"] "Fix: Handle the issue #123";
  "test commit with very long message" >:: test_commit [String.make 255 'a'] (String.make 255 'a');
  "test commit with multiline message" >:: test_commit ["First line"; "Second line"] "First line Second line";
]

(* test suite driver *)
let tests = List.flatten [
    add;
    commit;
  ]
let suite = "got test suite" >::: tests
let _ = run_test_tt_main suite

