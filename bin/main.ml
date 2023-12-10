let () =
  let args = List.tl (Array.to_list Sys.argv) in
  let output =
    match args with
    | "init" :: rest -> Commands.Init.run rest
    | "add" :: files -> Commands.Add.run files
    | "rm" :: files -> Commands.Rm.run files
    | "commit" :: args -> Commands.Commit.run args
    | "log" :: _ -> Commands.Log.run ()
    | "status" :: _ -> Commands.Status.run ()
    | "reset" :: args -> Commands.Reset.run args
    | "branch" :: args -> Commands.Branch.run args
    | "checkout" :: args -> Commands.Checkout.run args
    (* | "merge" :: branch -> failwith "TODO" | "stash" :: _ -> failwith "TODO"
       | "diff" :: f -> failwith "TOOD" *)
    | [] ->
        "========================================================================\n"
        ^ "          ______                  _______               \
           _____         \n"
        ^ "         /\\    \\                 /::\\    \\             /\\    \
           \\         \n"
        ^ "        /::\\    \\               /::::\\    \\           /::\\    \
           \\        \n"
        ^ "       /::::\\    \\             /::::::\\    \\          \
           \\:::\\    \\       \n"
        ^ "      /::::::\\    \\           /::::::::\\    \\          \
           \\:::\\    \\      \n"
        ^ "     /:::/\\:::\\    \\         /:::/~~\\:::\\    \\          \
           \\:::\\    \\     \n"
        ^ "    /:::/  \\:::\\    \\       /:::/    \\:::\\    \\          \
           \\:::\\    \\    \n"
        ^ "   /:::/    \\:::\\    \\     /:::/    / \\:::\\    \\         \
           /::::\\    \\   \n"
        ^ "  /:::/    / \\:::\\    \\   /:::/____/   \\:::\\____\\       \
           /::::::\\    \\  \n"
        ^ " /:::/    /   \\:::\\ ___\\ |:::|    |     |:::|    |     \
           /:::/\\:::\\    \\ \n"
        ^ "/:::/____/  ___\\:::|    ||:::|____|     |:::|    |    /:::/  \
           \\:::\\____\\\n"
        ^ "\\:::\\    \\ /\\  /:::|____| \\:::\\    \\   /:::/    /    \
           /:::/    \\::/    /\n"
        ^ " \\:::\\    /::\\ \\::/    /   \\:::\\    \\ /:::/    /    /:::/    \
           / \\/____/ \n"
        ^ "  \\:::\\   \\:::\\ \\/____/     \\:::\\    /:::/    /    /:::/    \
           /          \n"
        ^ "   \\:::\\   \\:::\\____\\        \\:::\\__/:::/    /    /:::/    \
           /           \n"
        ^ "    \\:::\\  /:::/    /         \\::::::::/    /     \\::/    \
           /            \n"
        ^ "     \\:::\\/:::/    /           \\::::::/    /       \
           \\/____/             \n"
        ^ "      \\::::::/    /             \\::::/    \
           /                            \n"
        ^ "       \\::::/    /               \
           \\::/____/                             \n"
        ^ "        \\::/____/                 \
           ~~                                   \n"
        ^ "=========================================================================\n"
        ^ "Usage: got [init <path> | add <file> | commit -m <message> | log | \
           reset [--hard] <commit> | checkout [-b] <branch>] | branch [-D \
           <branch>]"
    | _ -> "Command not supported!"
  in
  print_endline output
