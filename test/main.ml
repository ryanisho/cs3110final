open OUnit2
open Commands
exception Got_initialized of string

(* helper test functions *)
let test_add files _ =
  Unix.sleepf 1.5;
  let result = Commands.Add.run files in
  assert_equal ("Added " ^ String.concat " " files) result

let test_commit messages expected_message _ =
  Unix.sleepf 1.5;
  let _ = Commands.Add.run [ "../test/test/docs/apples.txt" ] in
  let result = Commands.Commit.run messages in
  (* Printf.printf "Commit result: %s\n" result; *)
  let starts_with_committed = String.sub result 0 9 = "Committed" in
  let contains_message =
    String.contains result ':'
    && String.sub result
      (String.index result ':' + 3)
      (String.length expected_message)
       = expected_message
  in
  assert_equal true (starts_with_committed && contains_message)

let test_init_new _ =
  let _ = Unix.system "rm -rf ./repo/.got/" in
  let result = Commands.Init.run [] () in
  let result = String.sub result 0 28 in
  assert_equal result "Initialized empty repository";
  ()

let test_init_exists _ =
  let result = Commands.Init.run [] () in
  assert_equal result "fatal: a got version-control system already exists in the directory.";
  ()

let test_log expected_log_entries _ =
  let result = Commands.Log.run () in
  assert_equal expected_log_entries result ~printer:(fun x -> x)

(* Function to capture timestamp from commit *)
let commit_and_get_log_entry message =
  let _ = Commands.Add.run [ "../test/test/docs/apples.txt" ] in
  let _ = Commands.Commit.run [ message ] in
  match Utils.Commit.retrieve_latest_commit_filename () with
  | Some filename ->
    let commit = Utils.Commit.fetch_commit filename in
    "[" ^ commit.timestamp ^ "] " ^ message (* Construct the log entry *)
  | None -> failwith "No commit found"

let add =
  [
    (* no files *)
    ( "test with no files" >:: fun _ ->
          let result = Commands.Add.run [] in
          assert_equal "No file added." result );
    (* variation testing *)
    "test with one file" >:: test_add [ "../test/test/docs/apples.txt" ];
    "test with multiple files"
    >:: test_add
      [ "../test/test/docs/apples.txt"; "../test/test/docs/loremipsum.txt" ];
    "test with images" >:: test_add [ "../test/test/img/james.png" ];
    "test with multiple images"
    >:: test_add [ "../test/test/img/james.png"; "../test/test/img/chris.png" ];
    "test with audio" >:: test_add [ "../test/test/audio/river.mp3" ];
    "test with multiple audio"
    >:: test_add
      [ "../test/test/audio/river.mp3"; "../test/test/audio/walking.mp3" ];
    "test with images and audio and text"
    >:: test_add
      [
        "../test/test/docs/apples.txt";
        "../test/test/img/james.png";
        "../test/test/audio/river.mp3";
      ];
    (* extension variability testing *)
    (* Text Files *)
    "test with Markdown file" >:: test_add [ "../test/test/docs/document.md" ];
    "test with XML file" >:: test_add [ "../test/test/docs/data.xml" ];
    "test with JSON file" >:: test_add [ "../test/test/data/config.json" ];
    "test with CSV file" >:: test_add [ "../test/test/docs/data.csv" ];
    (* Image Files *)
    "test with JPEG image" >:: test_add [ "../test/test/img/cat.jpeg" ];
    (* "test with BMP image" >:: test_add [ "../test/test/img/flower.bmp" ]; *)
    "test with TIFF image" >:: test_add [ "../test/test/img/starfall.tiff" ];
    "test with GIF image" >:: test_add [ "../test/test/img/rubix.gif" ];
    "test with SVG image" >:: test_add [ "../test/test/img/compass.svg" ];
    (* Audio Files *)
    "test with WAV audio" >:: test_add [ "../test/test/audio/sample.wav" ];
    "test with AIFF audio" >:: test_add [ "../test/test/audio/sample1.aiff" ];
    "test with FLAC audio" >:: test_add [ "../test/test/audio/symphony.flac" ];
    "test with AAC audio" >:: test_add [ "../test/test/audio/sample2.aac" ];
    "test with OGG audio" >:: test_add [ "../test/test/audio/symphony6.ogg" ];
    (* Video Files *)
    "test with MP4 video" >:: test_add [ "../test/test/video/sample.mp4" ];
    "test with MOV video" >:: test_add [ "../test/test/video/sample1.mov" ];
    "test with WMV video" >:: test_add [ "../test/test/video/sample2.wmv" ];
    "test with FLV video" >:: test_add [ "../test/test/video/sample3.flv" ];
    "test with AVI video" >:: test_add [ "../test/test/video/sample4.avi" ];
    (* Document Files *)
    "test with PDF document" >:: test_add [ "../test/test/docs/file.pdf" ];
    "test with DOCX document" >:: test_add [ "../test/test/docs/sample.docx" ];
    "test with PPTX presentation"
    >:: test_add [ "../test/test/docs/sample1.pptx" ];
    "test with XLSX spreadsheet"
    >:: test_add [ "../test/test/docs/sample2.xlsx" ];
    "test with ODT document" >:: test_add [ "../test/test/docs/sample3.odt" ];
    (* Archive Files *)
    "test with ZIP archive" >:: test_add [ "../test/test/archive/file.zip" ];
    "test with RAR archive" >:: test_add [ "../test/test/archive/sample.rar" ];
    "test with 7Z archive" >:: test_add [ "../test/test/archive/sample2.7z" ];
    "test with TAR.GZ archive" >:: test_add [ "../test/test/archive/sample.gz" ];
    "test with TAR.BZ2 archive"
    >:: test_add [ "../test/test/archive/sample.tar" ];
    (* Executable and Script Files *)
    "test with EXE file" >:: test_add [ "../test/test/application/sample.exe" ];
    "test with SH script" >:: test_add [ "../test/test/application/sample1.sh" ];
    "test with BAT script" >:: test_add [ "../test/test/application/bios.bat" ];
    "test with JAR file"
    >:: test_add [ "../test/test/application/helloworld.jar" ];
    (* Configuration and Miscellaneous Files *)
    "test with YAML file" >:: test_add [ "../test/test/config/homestead.yaml" ];
    "test with INI file" >:: test_add [ "../test/test/config/sample.ini" ];
    "test with LOG file" >:: test_add [ "../test/test/config/sample.log" ];
    "test with CONF file" >:: test_add [ "../test/test/config/system.config" ];
    "test with Bash profile"
    >:: test_add [ "../test/test/config/.bash_profile" ];
    "test with Nginx config" >:: test_add [ "../test/test/config/nginx.conf" ];
    (* Programming and Source Code Files *)
    "test with HTML file" >:: test_add [ "../test/test/code/page.html" ];
    "test with PY script" >:: test_add [ "../test/test/code/script.py" ];
    "test with Java file" >:: test_add [ "../test/test/code/HelloWorld.java" ];
    "test with C++ file" >:: test_add [ "../test/test/code/main.cpp" ];
    "test with C# file" >:: test_add [ "../test/test/code/Program.cs" ];
    "test with Ruby file" >:: test_add [ "../test/test/code/script.rb" ];
    "test with JavaScript file" >:: test_add [ "../test/test/code/app.js" ];
    "test with PHP script" >:: test_add [ "../test/test/code/server.php" ];
    "test with CSS file" >:: test_add [ "../test/test/code/style.css" ];
    "test with SCSS file" >:: test_add [ "../test/test/code/style.scss" ];
    "test with LaTeX file" >:: test_add [ "../test/test/code/document.tex" ];
    "test with R script" >:: test_add [ "../test/test/code/analysis.R" ];
    "test with MATLAB file" >:: test_add [ "../test/test/code/calculation.m" ];
    "test with Dockerfile" >:: test_add [ "../test/test/code/Dockerfile" ];
    "test with Git configuration"
    >:: test_add [ "../test/test/config/.gitconfig" ];
    "test with Perl script" >:: test_add [ "../test/test/code/script.pl" ];
    "test with Haskell file" >:: test_add [ "../test/test/code/main.hs" ];
    "test with Go file" >:: test_add [ "../test/test/code/app.go" ];
    "test with Rust file" >:: test_add [ "../test/test/code/lib.rs" ];
    "test with Kotlin file" >:: test_add [ "../test/test/code/Main.kt" ];
    (* Data and Database Files *)
    "test with SQL file" >:: test_add [ "../test/test/data/sample.sql" ];
    "test with SQLite file" >:: test_add [ "../test/test/data/sample.db" ];
    (* Graphic and Design Files *)
    "test with Photoshop file" >:: test_add [ "../test/test/design/sample.psd" ];
    "test with Illustrator file"
    >:: test_add [ "../test/test/design/sample.ai" ];
    "test with AutoCAD file" >:: test_add [ "../test/test/design/sample.dwg" ];
    "test with Sketch file" >:: test_add [ "../test/test/design/sample.sketch" ];
    "test with InDesign file" >:: test_add [ "../test/test/design/sample.indd" ];
    (* Mixed File Types in a Single Test *)
    "test with mixed code files"
    >:: test_add
      [ "../test/test/code/script.py"; "../test/test/code/script.rb" ];
    "test with mixed data files"
    >:: test_add
      [ "../test/test/docs/data.csv"; "../test/test/docs/sample2.xlsx" ];
    "test with mixed image files"
    >:: test_add [ "../test/test/img/cat.jpeg"; "../test/test/img/compass.svg" ];
    "test with mixed document files"
    >:: test_add
      [ "../test/test/docs/sample.docx"; "../test/test/docs/sample1.pptx" ];
    "test with mixed web files"
    >:: test_add [ "../test/test/code/page.html"; "../test/test/code/app.js" ];
    (* Virtual Machine and Container Files *)
    "test with VirtualBox file"
    >:: test_add [ "../test/test/vm/virtualbox.vdi" ];
    "test with VMware file" >:: test_add [ "../test/test/vm/vmware.vmdk" ];
    "test with Vagrantfile" >:: test_add [ "../test/test/vm/Vagrantfile" ];
    (* Various Document Formats *)
    "test with ePub file" >:: test_add [ "../test/test/docs/sample.epub" ];
    "test with MOBI file" >:: test_add [ "../test/test/docs/sample.mobi" ];
    "test with Rich Text Format" >:: test_add [ "../test/test/docs/sample.rtf" ];
    "test with OpenDocument Spreadsheet"
    >:: test_add [ "../test/test/docs/sample.ods" ];
    (* Specialized Data Formats *)
    "test with HDF5 file" >:: test_add [ "../test/test/data/sample.h5" ];
    "test with GeoJSON file" >:: test_add [ "../test/test/data/map.geojson" ];
    "test with KML file" >:: test_add [ "../test/test/data/sample.kml" ];
    "test with Parquet file" >:: test_add [ "../test/test/data/cars.parquet" ];
    "test with Avro file" >:: test_add [ "../test/test/data/data.avro" ];
    (* Combination of Diverse File Types *)
    "test with various script files"
    >:: test_add
      [
        "../test/test/application/sample1.sh"; "../test/test/code/script.py";
      ];
    "test with multiple config files"
    >:: test_add
      [ "../test/test/config/nginx.conf"; "../test/test/config/.gitconfig" ];
    "test with mixed media files"
    >:: test_add
      [ "../test/test/video/sample.mp4"; "../test/test/audio/river.mp3" ];
    "test with various document types"
    >:: test_add
      [ "../test/test/docs/file.pdf"; "../test/test/docs/sample.epub" ];
    "test with assorted data files"
    >:: test_add
      [ "../test/test/data/config.json"; "../test/test/docs/data.csv" ];
    "test with multiple archive files"
    >:: test_add
      [ "../test/test/archive/file.zip"; "../test/test/archive/sample.tar" ];
    "test with various code files"
    >:: test_add [ "../test/test/code/app.js"; "../test/test/code/script.py" ];
    "test with mixed design files"
    >:: test_add
      [
        "../test/test/design/sample.psd";
        "../test/test/design/sample.sketch";
      ];
    "test with various virtual machine files"
    >:: test_add
      [ "../test/test/vm/virtualbox.vdi"; "../test/test/vm/vmware.vmdk" ];
  ]

let commit =
  [
    (* add file to staging area *)
    "test commit with no message" >:: test_commit [ "" ] "";
    "test commit with simple message"
    >:: test_commit [ "Initial commit" ] "Initial commit";
    "test commit with complex message"
    >:: test_commit
      [ "Added new feature with multiple fixes" ]
      "Added new feature with multiple fixes";
    "test commit with special characters"
    >:: test_commit
      [ "No special characters: !@#$%^&*()_+" ]
      "No special characters: !@#$%^&*()_+";
    "test commit with very long message"
    >:: test_commit [ String.make 255 'a' ] (String.make 255 'a');
    "test commit with multiline message"
    >:: test_commit [ "First line"; "Second line" ] "First line Second line";
    "test commit with empty message and no changes" >:: test_commit [ "" ] "";
    "test commit with escape characters in message"
    >:: test_commit
      [ "Fix line breaks\nand tabs\t" ]
      "Fix line breaks\nand tabs\t";
    "test commit with excessively long message"
    >:: test_commit [ String.make 1000 'b' ] (String.make 255 'b');
    "test commit with invalid characters in message"
    >:: test_commit [ "Invalid char \255 here" ] "Invalid char \255 here";
    "test commit with non-ASCII characters"
    >:: test_commit [ "コミットメッセージ" ] "コミットメッセージ";
    "test commit with mixed language message"
    >:: test_commit [ "Initial commit - 初期コミット" ] "Initial commit - 初期コミット";
    "test commit with leading and trailing whitespace"
    >:: test_commit [ "   Feature update   " ] "   Feature update   ";
    "test commit with only whitespace in message"
    >:: test_commit [ "     " ] "     ";
    "test commit with quotation marks in message"
    >:: test_commit
      [ "Added 'new feature' module" ]
      "Added 'new feature' module";
    "test commit with extremely short message" >:: test_commit [ "a" ] "a";
    "test commit with git command in message"
    >:: test_commit
      [ "Fixed issue; run `git pull` after update" ]
      "Fixed issue; run `git pull` after update";
    "test commit with emojis"
    >:: test_commit [ "🐛 Fixed bug in code" ] "🐛 Fixed bug in code";
    "test commit with markdown-like syntax"
    >:: test_commit
      [ "* Added new feature\n* Fixed bug" ]
      "* Added new feature\n* Fixed bug";
    "test commit with HTML-like tags"
    >:: test_commit
      [ "<fix> corrected minor issue </fix>" ]
      "<fix> corrected minor issue </fix>";
    "test commit with backslashes in message"
    >:: test_commit
      [ "Fixed file paths using \\ paths" ]
      "Fixed file paths using \\ paths";
    "test commit with environment variables in message"
    >:: test_commit
      [ "Updated PATH in $HOME/.bashrc" ]
      "Updated PATH in $HOME/.bashrc";
    "test commit with null character in message"
    >:: test_commit [ "Null char \000 present" ] "Null char \000 present";
    "test commit with only numeric characters in message"
    >:: test_commit [ "1234567890" ] "1234567890";
    "test commit with code snippet in message"
    >:: test_commit
      [ "Refactored loop: for(i = 0; i < n; i++) {...}" ]
      "Refactored loop: for(i = 0; i < n; i++) {...}";
    "test commit with mixed case message"
    >:: test_commit
      [ "FiXeD Case Sensitivity ISSUE" ]
      "FiXeD Case Sensitivity ISSUE";
    "test commit with SQL-like syntax in message"
    >:: test_commit
      [ "Updated DB: SELECT * FROM users;" ]
      "Updated DB: SELECT * FROM users;";
    "test commit with XML content in message"
    >:: test_commit
      [ "<xml><update>123</update></xml>" ]
      "<xml><update>123</update></xml>";
    "test commit with timestamp in message"
    >:: test_commit
      [ "Backup created on 2023-03-15 10:00:00 UTC" ]
      "Backup created on 2023-03-15 10:00:00 UTC";
    "test commit with URL in message"
    >:: test_commit
      [ "Fixed issue, see http://example.com for details" ]
      "Fixed issue, see http://example.com for details";
    "test commit with brackets in message"
    >:: test_commit
      [ "Fixed issue (see issue #123)" ]
      "Fixed issue (see issue #123)";
    "test commit with indented message"
    >:: test_commit
      [ "    Indented message for formatting" ]
      "    Indented message for formatting";
    "test commit with bullet points in message"
    >:: test_commit
      [ "- Added feature A\n- Fixed bug B" ]
      "- Added feature A\n- Fixed bug B";
    "test commit with hash character in message"
    >:: test_commit
      [ "Updated README #documentation" ]
      "Updated README #documentation";
    "test commit with only spaces in message"
    >:: test_commit [ "     " ] "     ";
    "test commit with control characters in message"
    >:: test_commit [ "Line1\nLine2\tTabbed" ] "Line1\nLine2\tTabbed";
    "test commit with duplicate message"
    >:: test_commit [ "Duplicate message" ] "Duplicate message";
    "test commit with mathematical symbols in message"
    >:: test_commit
      [ "Improved efficiency by 50%" ]
      "Improved efficiency by 50%";
    "test commit with file paths in message"
    >:: test_commit
      [ "Updated file at /src/main.c" ]
      "Updated file at /src/main.c";
    "test commit with conditional phrase in message"
    >:: test_commit
      [ "If user is admin, allow access to settings" ]
      "If user is admin, allow access to settings";
    "test commit with various date formats in message"
    >:: test_commit
      [ "Event date changed: 03/15/2023 to April 5th, 2023" ]
      "Event date changed: 03/15/2023 to April 5th, 2023";
  ]
let log =
  [
    ( "test log with many commits" >:: fun _ ->
          Utils.Commit.clear_commit_history ();
          let log_entry1 = commit_and_get_log_entry "Commit 1" in
          Unix.sleepf 0.01;
          let log_entry2 = commit_and_get_log_entry "Commit 2" in
          Unix.sleepf 0.01;
          let log_entry3 = commit_and_get_log_entry "Commit 3" in
          Unix.sleepf 0.01;
          let log_entry4 = commit_and_get_log_entry "Commit 4" in
          Unix.sleepf 0.01;
          let log_entry5 = commit_and_get_log_entry "Commit 5" in
          Unix.sleepf 0.01;
          let log_entry6 = commit_and_get_log_entry "Commit 6" in
          Unix.sleepf 0.01;
          let log_entry7 = commit_and_get_log_entry "Commit 7" in
          Unix.sleepf 0.01;
          let log_entry8 = commit_and_get_log_entry "Commit 8" in
          Unix.sleepf 0.01;
          let log_entry9 = commit_and_get_log_entry "Commit 9" in
          Unix.sleepf 0.01;
          let log_entry10 = commit_and_get_log_entry "Commit 10" in
          Unix.sleepf 0.01;
          let log_entry11 = commit_and_get_log_entry "Commit 11" in
          Unix.sleepf 0.01;
          let log_entry12 = commit_and_get_log_entry "Commit 12" in
          Unix.sleepf 0.01;
          let log_entry13 = commit_and_get_log_entry "Commit 13" in
          Unix.sleepf 0.01;
          let log_entry14 = commit_and_get_log_entry "Commit 14" in
          Unix.sleepf 0.01;
          let log_entry15 = commit_and_get_log_entry "Commit 15" in
          Unix.sleepf 0.01;
          let log_entry16 = commit_and_get_log_entry "Commit 16" in
          Unix.sleepf 0.01;
          let log_entry17 = commit_and_get_log_entry "Commit 17" in
          Unix.sleepf 0.01;
          let log_entry18 = commit_and_get_log_entry "Commit 18" in
          Unix.sleepf 0.01;
          let log_entry19 = commit_and_get_log_entry "Commit 19" in
          Unix.sleepf 0.01;
          let log_entry20 = commit_and_get_log_entry "Commit 20" in
          Unix.sleepf 0.01;
          let log_entry21 = commit_and_get_log_entry "Commit 21" in
          Unix.sleepf 0.01;
          let log_entry22 = commit_and_get_log_entry "Commit 22" in
          Unix.sleepf 0.01;
          let log_entry23 = commit_and_get_log_entry "Commit 23" in
          Unix.sleepf 0.01;
          let log_entry24 = commit_and_get_log_entry "Commit 24" in
          Unix.sleepf 0.01;
          let log_entry25 = commit_and_get_log_entry "Commit 25" in
          Unix.sleepf 0.01;
          let log_entry26 = commit_and_get_log_entry "Commit 26" in
          Unix.sleepf 0.01;
          let log_entry27 = commit_and_get_log_entry "Commit 27" in
          Unix.sleepf 0.01;
          let log_entry28 = commit_and_get_log_entry "Commit 28" in
          Unix.sleepf 0.01;
          let log_entry29 = commit_and_get_log_entry "Commit 29" in
          Unix.sleepf 0.01;
          let log_entry30 = commit_and_get_log_entry "Commit 30" in
          Unix.sleepf 0.01;
          let log_entry31 = commit_and_get_log_entry "Commit 31" in
          Unix.sleepf 0.01;
          let log_entry32 = commit_and_get_log_entry "Commit 32" in
          Unix.sleepf 0.01;
          let log_entry33 = commit_and_get_log_entry "Commit 33" in
          Unix.sleepf 0.01;
          let log_entry34 = commit_and_get_log_entry "Commit 34" in
          Unix.sleepf 0.01;
          let log_entry35 = commit_and_get_log_entry "Commit 35" in
          Unix.sleepf 0.01;
          let log_entry36 = commit_and_get_log_entry "Commit 36" in
          Unix.sleepf 0.01;
          let log_entry37 = commit_and_get_log_entry "Commit 37" in
          Unix.sleepf 0.01;
          let log_entry38 = commit_and_get_log_entry "Commit 38" in
          Unix.sleepf 0.01;
          let log_entry39 = commit_and_get_log_entry "Commit 39" in
          Unix.sleepf 0.01;
          let log_entry40 = commit_and_get_log_entry "Commit 40" in
          Unix.sleepf 0.01;
          let log_entry41 = commit_and_get_log_entry "Commit 41" in
          Unix.sleepf 0.01;
          let log_entry42 = commit_and_get_log_entry "Commit 42" in
          Unix.sleepf 0.01;
          let log_entry43 = commit_and_get_log_entry "Commit 43" in
          Unix.sleepf 0.01;
          let log_entry44 = commit_and_get_log_entry "Commit 44" in
          Unix.sleepf 0.01;
          let log_entry45 = commit_and_get_log_entry "Commit 45" in
          Unix.sleepf 0.01;
          let log_entry46 = commit_and_get_log_entry "Commit 46" in
          Unix.sleepf 0.01;
          let log_entry47 = commit_and_get_log_entry "Commit 47" in
          Unix.sleepf 0.01;
          let log_entry48 = commit_and_get_log_entry "Commit 48" in
          Unix.sleepf 0.01;
          let log_entry49 = commit_and_get_log_entry "Commit 49" in
          Unix.sleepf 0.01;
          let log_entry50 = commit_and_get_log_entry "Commit 50" in
          Unix.sleepf 0.01;
          let log_entry51 = commit_and_get_log_entry "Commit 51" in
          Unix.sleepf 0.01;
          let log_entry52 = commit_and_get_log_entry "Commit 52" in
          Unix.sleepf 0.01;
          let log_entry53 = commit_and_get_log_entry "Commit 53" in
          Unix.sleepf 0.01;
          let log_entry54 = commit_and_get_log_entry "Commit 54" in
          Unix.sleepf 0.01;
          let log_entry55 = commit_and_get_log_entry "Commit 55" in
          Unix.sleepf 0.01;
          let log_entry56 = commit_and_get_log_entry "Commit 56" in
          Unix.sleepf 0.01;
          let log_entry57 = commit_and_get_log_entry "Commit 57" in
          Unix.sleepf 0.01;
          let log_entry58 = commit_and_get_log_entry "Commit 58" in
          Unix.sleepf 0.01;
          let log_entry59 = commit_and_get_log_entry "Commit 59" in
          Unix.sleepf 0.01;
          let log_entry60 = commit_and_get_log_entry "Commit 60" in
          test_log
            (log_entry60 ^ "\n" ^ log_entry59 ^ "\n" ^ log_entry58 ^ "\n"
             ^ log_entry57 ^ "\n" ^ log_entry56 ^ "\n" ^ log_entry55 ^ "\n"
             ^ log_entry54 ^ "\n" ^ log_entry53 ^ "\n" ^ log_entry52 ^ "\n"
             ^ log_entry51 ^ "\n" ^ log_entry50 ^ "\n" ^ log_entry49 ^ "\n"
             ^ log_entry48 ^ "\n" ^ log_entry47 ^ "\n" ^ log_entry46 ^ "\n"
             ^ log_entry45 ^ "\n" ^ log_entry44 ^ "\n" ^ log_entry43 ^ "\n"
             ^ log_entry42 ^ "\n" ^ log_entry41 ^ "\n" ^ log_entry40 ^ "\n"
             ^ log_entry39 ^ "\n" ^ log_entry38 ^ "\n" ^ log_entry37 ^ "\n"
             ^ log_entry36 ^ "\n" ^ log_entry35 ^ "\n" ^ log_entry34 ^ "\n"
             ^ log_entry33 ^ "\n" ^ log_entry32 ^ "\n" ^ log_entry31 ^ "\n"
             ^ log_entry30 ^ "\n" ^ log_entry29 ^ "\n" ^ log_entry28 ^ "\n"
             ^ log_entry27 ^ "\n" ^ log_entry26 ^ "\n" ^ log_entry25 ^ "\n"
             ^ log_entry24 ^ "\n" ^ log_entry23 ^ "\n" ^ log_entry22 ^ "\n"
             ^ log_entry21 ^ "\n" ^ log_entry20 ^ "\n" ^ log_entry19 ^ "\n"
             ^ log_entry18 ^ "\n" ^ log_entry17 ^ "\n" ^ log_entry16 ^ "\n"
             ^ log_entry15 ^ "\n" ^ log_entry14 ^ "\n" ^ log_entry13 ^ "\n"
             ^ log_entry12 ^ "\n" ^ log_entry11 ^ "\n" ^ log_entry10 ^ "\n"
             ^ log_entry9 ^ "\n" ^ log_entry8 ^ "\n" ^ log_entry7 ^ "\n" ^ log_entry6
             ^ "\n" ^ log_entry5 ^ "\n" ^ log_entry4 ^ "\n" ^ log_entry3 ^ "\n"
             ^ log_entry2 ^ "\n" ^ log_entry1)
            () );
  ]

let init =
  [
    "test init new repository" >:: test_init_new;
    "test init with existing repository" >:: test_init_exists;
  ]

(* test suite driver *)
let tests = List.flatten [ log; add; commit; init ]
let suite = "got test suite" >::: tests
let _ = run_test_tt_main suite
