module type ArgCommand = sig
  val run : string list -> string
end

module type EmptyCommand = sig
  val run : unit -> string
end

(* Commands have a run function that returns the output that should be printed
   out. The output will actually be printed out in `main.ml`. *)
