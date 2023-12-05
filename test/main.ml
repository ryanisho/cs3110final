open OUnit2
open Commands

(* helper test functions *)
let test_add files _ = 
  let result = Commands.Add.run files in
  assert_equal ("Added " ^ String.concat " " files) result

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

(* test suite driver *)
let tests = List.flatten [  
    add;
  ]
let suite = "got test suite" >::: tests
let _ = run_test_tt_main suite

