open OUnit2
open Commands

(* helper test functions *)
let test_run_no_files _ =
  let result = Commands.Add.run [] in
  assert_equal "No file added." result

(* main test suite *)
let tests = [
  "test suite for 'run' function" >::: [
    "test with no files" >:: test_run_no_files;
  ]
]

(* test suite driver *)
let suite = "got test suite" >::: tests
let _ = run_test_tt_main suite
