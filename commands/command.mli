type argumented_command = string list -> string
type empty_command = unit -> string

(* Commands are a function that returns an output. The output will be printed
   out in `main.ml`. *)
