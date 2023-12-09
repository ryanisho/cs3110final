open OUnit2
open Commands

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
  assert_raises
    (Failure
       "A Got version-control system already exists in the directory.") (fun () ->
        Commands.Init.run [] ());
  ()

let test_log expected_log_entries _ =
  Unix.sleep 2;
  let result = Commands.Log.run () in
  assert_equal expected_log_entries result ~printer:(fun x -> x)

(* Function to capture timestamp from commit *)
let commit_and_get_log_entry message =
  Unix.sleep 2;
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
    ( "test log with one commit" >:: fun _ ->
          Utils.Commit.clear_commit_history ();
          let log_entry = commit_and_get_log_entry "Initial commit" in
          test_log log_entry () );
    ( "test log with three commits" >:: fun _ ->
          Utils.Commit.clear_commit_history ();
          let log_entry1 = commit_and_get_log_entry "Initial commit" in
          let log_entry2 = commit_and_get_log_entry "Added new feature" in
          let log_entry3 = commit_and_get_log_entry "Fixed a bug" in
          test_log (log_entry3 ^ "\n" ^ log_entry2 ^ "\n" ^ log_entry1) () );
  ]

let init =
  [
    "test init new repository" >:: test_init_new;
    "test init with existing repository" >:: test_init_exists;
  ]

(* test suite driver *)
let tests = List.flatten [ add; commit; init ]
let suite = "got test suite" >::: tests
let _ = run_test_tt_main suite
