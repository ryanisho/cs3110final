open Utils

module Commit : Command.ArgCommand = struct
  let run (args : string list) : string = "Committed."
end
