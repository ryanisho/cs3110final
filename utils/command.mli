module type ArgCommand = sig
  val run : string list -> string
end

module type EmptyCommand = sig
  val run : unit -> string
end
