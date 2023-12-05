open OUnit2
open Commands

(* helper test functions *)
let test_add file _ = 
  let result = Commands.Add.run [file] in
  assert_equal ("Added " ^ file) result

(* test cases *)
let add = [
  "test with no files" >:: (fun _ -> 
      let result = Commands.Add.run [] in
      assert_equal "No file added." result);
  "test with one file" >:: test_add "../test/text/one.txt";
]

(* test suite driver *)
let tests = List.flatten [
    add;
  ]
let suite = "got test suite" >::: tests
let _ = run_test_tt_main suite

