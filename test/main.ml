open OUnit2
open Commands

(* helper test functions *)

(* main test suite *)
let tests = [
  (* tests go here *)
]

(* test suite driver *)
let suite = "suite" >::: tests
let () = run_test_tt_main suite
