open OUnit2
open Commands

(* helper test functions *)
let test_add file _ = 
  let result = Commands.Add.run [file] in
  if file = "" then
    assert_equal "No files added." result
  else
    assert_equal "File added." result

(* main test suite *)
let tests = [
  "test suite for 'add' function" >::: [
    (* I want to test adding no files *)
    "test with no files" >:: test_add "";
    "test with one file" >:: test_add "../test/text/one.txt"
  ];
]

(* test suite driver *)
let suite = "got test suite" >::: tests
let _ = run_test_tt_main suite

