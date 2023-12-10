let red = "\027[31m"
let green = "\027[32m"
let reset = "\027[0m"
let black = "\027[30m"
let gray = "\027[90m"
let bright_red = "\027[91m"
let bright_green = "\027[92m"
let bright_yellow = "\027[93m"
let bright_blue = "\027[94m"
let bright_magenta = "\027[95m"
let bright_cyan = "\027[96m"
let bright_white = "\027[97m"
let dark_gray = "\027[30;1m"
let light_red = "\027[31;1m"
let light_green = "\027[32;1m"
let light_yellow = "\027[33;1m"
let light_blue = "\027[34;1m"
let light_magenta = "\027[35;1m"
let light_cyan = "\027[36;1m"
let white = "\027[37;1m"

let all_colors =
  [
    "red";
    "green";
    "reset";
    "black";
    "gray";
    "bright_red";
    "bright_green";
    "bright_yellow";
    "bright_blue";
    "bright_magenta";
    "bright_cyan";
    "bright_white";
    "dark_gray";
    "light_red";
    "light_green";
    "light_yellow";
    "light_blue";
    "light_magenta";
    "light_cyan";
    "white";
  ]

type color_settings = {
  untracked : string;
  tracked : string;
}

let default_color = { untracked = red; tracked = green }

let get_colors () =
  let colors : color_settings =
    Filesystem.marshal_file_to_data (Filesystem.Repo.config_file ())
  in
  (colors.untracked, colors.tracked)
