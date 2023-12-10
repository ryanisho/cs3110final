(* Testing Plan:

   1. Automated Testing with OUnit: - Modules Tested: `Add`, `Commit`, `Log` -
   Test Case Development: Black box testing was primarily used. We considered
   the expected behavior of the functions without looking at their
   implementation. - `Add` Module: We test the `run` function with a list of
   files. We expect the function to return a string that indicates the files
   were added. We test with different types of files (text files, binary files,
   etc.) and different numbers of files (no files, one file, multiple files). -
   `Commit` Module: We test the `run` function with a list of messages. We
   expect the function to return a string that starts with "Committed" and
   contains the commit message. We test with different types of messages (empty
   string, one word, multiple words, special characters). - `Log` Module: We
   test the `run` function with no arguments. We expect the function to return a
   string that contains the commit log. We test with different states of the
   commit log (no commits, one commit, multiple commits).

   2. Manual Testing: - Modules Tested: `Branch`, `Checkout`, `Rm`, `Reset`,
   `Status` - `Branch` Module: We manually tested this module by creating new
   branches, switching between branches, and checking the state of the
   filesystem and the output of the `Branch.run` function. - `Checkout` Module:
   We manually tested this module by checking out different branches and
   commits, and checking the state of the filesystem and the output of the
   `Checkout.run` function. - `Rm` Module: We manually tested this module by
   removing different files and directories, and checking the state of the
   filesystem and the output of the `rm` function. - `Reset` Module: We manually
   tested this module by resetting the repository to different states, and
   checking the state of the filesystem and the output of the `reset` function.
   - `Status` Module: Some parts of this module required manual testing because
   they involve a change in color. We manually tested these parts by running the
   `status` function and visually inspecting the output.

   This testing approach demonstrates the correctness of the system because it
   covers all the major functionality of the system. The automated tests ensure
   that the `Add`, `Commit`, and `Log` functions work as expected for a variety
   of inputs, and the manual tests ensure that the functions that interact with
   the filesystem and the terminal (`Branch`, `Checkout`, `Rm`, `Reset`,
   `Status`) work correctly. By covering all these areas, we can be confident
   that the system works as intended. *)
open OUnit2
open Commands

exception Got_initialized of string

(* helper test functions *)
let test_add files _ =
  Unix.sleepf 1.5;
  let result = Commands.Add.run files in
  assert_equal ("Added " ^ String.concat " " files) result ~printer:(fun s -> s)

let test_commit messages expected_message _ =
  Unix.sleepf 1.5;
  let _ = Commands.Add.run [ "../test/test/docs/apples.txt" ] in
  let result = Commands.Commit.run [ "-m"; messages ] in
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
  let result = Commands.Init.run [] in
  let result = String.sub result 0 28 in
  assert_equal result "Initialized empty repository";
  ()

let test_init_exists _ =
  let result = Commands.Init.run [] in
  assert_equal result
    "fatal: a got version-control system already exists in the directory.";
  ()

let test_log messages ctxt =
  Unix.sleepf 1.5;
  let rec commit_and_add_messages messages =
    match messages with
    | [] -> ()
    | message :: rest ->
        Unix.sleepf 0.5;
        ignore (Commands.Add.run [ "../test/test/docs/apples.txt" ]);
        Unix.sleepf 0.5;
        ignore (Commands.Commit.run [ "-m"; message ]);
        commit_and_add_messages rest
  in
  commit_and_add_messages messages;
  let actual = Commands.Log.run () in
  let actual_messages =
    actual |> String.split_on_char '\n'
    |> List.map (fun line ->
           match String.index_opt line ']' with
           | Some idx ->
               String.trim
                 (String.sub line (idx + 1) (String.length line - idx - 1))
           | None -> "")
    |> List.filter (fun message -> message <> "Initial commit")
  in
  assert_equal
    ~printer:(fun s -> String.concat ", " s)
    messages (List.rev actual_messages);
  Utils.Commit.clear_commit_history ()

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
    "test commit with no message" >:: test_commit "" "";
    "test commit with simple message"
    >:: test_commit "Initial commit" "Initial commit";
    "test commit with complex message"
    >:: test_commit "Added new feature with multiple fixes"
          "Added new feature with multiple fixes";
    "test commit with special characters"
    >:: test_commit "No special characters: !@#$%^&*()_+"
          "No special characters: !@#$%^&*()_+";
    "test commit with very long message"
    >:: test_commit (String.make 255 'a') (String.make 255 'a');
    "test commit with empty message and no changes" >:: test_commit "" "";
    "test commit with escape characters in message"
    >:: test_commit "Fix line breaks\nand tabs\t" "Fix line breaks\nand tabs\t";
    "test commit with excessively long message"
    >:: test_commit (String.make 1000 'b') (String.make 255 'b');
    "test commit with invalid characters in message"
    >:: test_commit "Invalid char \255 here" "Invalid char \255 here";
    "test commit with non-ASCII characters"
    >:: test_commit "コミットメッセージ" "コミットメッセージ";
    "test commit with mixed language message"
    >:: test_commit "Initial commit - 初期コミット" "Initial commit - 初期コミット";
    "test commit with leading and trailing whitespace"
    >:: test_commit "   Feature update   " "   Feature update   ";
    "test commit with only whitespace in message"
    >:: test_commit "     " "     ";
    "test commit with quotation marks in message"
    >:: test_commit "Added 'new feature' module" "Added 'new feature' module";
    "test commit with extremely short message" >:: test_commit "a" "a";
    "test commit with git command in message"
    >:: test_commit "Fixed issue; run `git pull` after update"
          "Fixed issue; run `git pull` after update";
    "test commit with emojis"
    >:: test_commit "🐛 Fixed bug in code" "🐛 Fixed bug in code";
    "test commit with markdown-like syntax"
    >:: test_commit "* Added new feature\n* Fixed bug"
          "* Added new feature\n* Fixed bug";
    "test commit with HTML-like tags"
    >:: test_commit "<fix> corrected minor issue </fix>"
          "<fix> corrected minor issue </fix>";
    "test commit with backslashes in message"
    >:: test_commit "Fixed file paths using \\ paths"
          "Fixed file paths using \\ paths";
    "test commit with environment variables in message"
    >:: test_commit "Updated PATH in $HOME/.bashrc"
          "Updated PATH in $HOME/.bashrc";
    "test commit with null character in message"
    >:: test_commit "Null char \000 present" "Null char \000 present";
    "test commit with only numeric characters in message"
    >:: test_commit "1234567890" "1234567890";
    "test commit with code snippet in message"
    >:: test_commit "Refactored loop: for(i = 0; i < n; i++) {...}"
          "Refactored loop: for(i = 0; i < n; i++) {...}";
    "test commit with mixed case message"
    >:: test_commit "FiXeD Case Sensitivity ISSUE"
          "FiXeD Case Sensitivity ISSUE";
    "test commit with SQL-like syntax in message"
    >:: test_commit "Updated DB: SELECT * FROM users;"
          "Updated DB: SELECT * FROM users;";
    "test commit with XML content in message"
    >:: test_commit "<xml><update>123</update></xml>"
          "<xml><update>123</update></xml>";
    "test commit with timestamp in message"
    >:: test_commit "Backup created on 2023-03-15 10:00:00 UTC"
          "Backup created on 2023-03-15 10:00:00 UTC";
    "test commit with URL in message"
    >:: test_commit "Fixed issue, see http://example.com for details"
          "Fixed issue, see http://example.com for details";
    "test commit with brackets in message"
    >:: test_commit "Fixed issue (see issue #123)"
          "Fixed issue (see issue #123)";
    "test commit with indented message"
    >:: test_commit "    Indented message for formatting"
          "    Indented message for formatting";
    "test commit with bullet points in message"
    >:: test_commit "- Added feature A\n- Fixed bug B"
          "- Added feature A\n- Fixed bug B";
    "test commit with hash character in message"
    >:: test_commit "Updated README #documentation"
          "Updated README #documentation";
    "test commit with only spaces in message" >:: test_commit "     " "     ";
    "test commit with control characters in message"
    >:: test_commit "Line1\nLine2\tTabbed" "Line1\nLine2\tTabbed";
    "test commit with duplicate message"
    >:: test_commit "Duplicate message" "Duplicate message";
    "test commit with mathematical symbols in message"
    >:: test_commit "Improved efficiency by 50%" "Improved efficiency by 50%";
    "test commit with file paths in message"
    >:: test_commit "Updated file at /src/main.c" "Updated file at /src/main.c";
    "test commit with conditional phrase in message"
    >:: test_commit "If user is admin, allow access to settings"
          "If user is admin, allow access to settings";
    "test commit with various date formats in message"
    >:: test_commit "Event date changed: 03/15/2023 to April 5th, 2023"
          "Event date changed: 03/15/2023 to April 5th, 2023";
    "test commit with multiple languages in message"
    >:: test_commit "Initial commit - 初期コミット - ابتدائی کمیٹ"
          "Initial commit - 初期コミット - ابتدائی کمیٹ";
    "test commit with repeated messages"
    >:: test_commit "Repeat commit" "Repeat commit";
    "test commit with only numeric characters and special symbols"
    >:: test_commit "1234567890!@#$%^&*()" "1234567890!@#$%^&*()";
    "test commit with interleaved special characters and text"
    >:: test_commit "Fi#x1! @Issue (Resolved)" "Fi#x1! @Issue (Resolved)";
    "test commit with incomplete escape sequences"
    >:: test_commit "Incomplete escape \\ sequence"
          "Incomplete escape \\ sequence";
    "test commit with only special characters"
    >:: test_commit "!@#$%^&*()_+-=[]{};':\",.<>/?`~"
          "!@#$%^&*()_+-=[]{};':\",.<>/?`~";
    "test commit with a very short message repeated many times"
    >:: test_commit
          (String.concat "" (Array.to_list (Array.make 100 "x")))
          (String.concat "" (Array.to_list (Array.make 100 "x")));
    "test commit with network paths"
    >:: test_commit "Updated network path \\\\network\\shared\\file"
          "Updated network path \\\\network\\shared\\file";
    "test commit with URLs"
    >:: test_commit "See documentation at https://example.com/docs"
          "See documentation at https://example.com/docs";
    "test commit with only numbers and punctuation"
    >:: test_commit "1234567890,.;'[]!" "1234567890,.;'[]!";
    "test commit with code snippet"
    >:: test_commit "Fix: `if (x < 10) { return x; }` in script.js"
          "Fix: `if (x < 10) { return x; }` in script.js";
    "test commit with automated message"
    >:: test_commit "Automated build: success" "Automated build: success";
    "test commit with multiline varied content"
    >:: test_commit "Line 1\n12345\nSpecial: *&^%$"
          "Line 1\n12345\nSpecial: *&^%$";
    "test commit with different date formats"
    >:: test_commit "Event on 2023-04-01, April 1st, 01/04/2023"
          "Event on 2023-04-01, April 1st, 01/04/2023";
    "test commit with file extensions"
    >:: test_commit "Updated README.md and script.py"
          "Updated README.md and script.py";
    "test commit with JSON string"
    >:: test_commit "{\"key\": \"value\"}" "{\"key\": \"value\"}";
    "test commit with XML string"
    >:: test_commit "<tag>content</tag>" "<tag>content</tag>";
    "test commit with repeated substrings"
    >:: test_commit "fix fix fix bug" "fix fix fix bug";
    "test commit with tabulated data"
    >:: test_commit "Data:\nName\tAge\nAlice\t30\nBob\t25"
          "Data:\nName\tAge\nAlice\t30\nBob\t25";
    "test commit with file system commands"
    >:: test_commit "Updated script: `rm -rf /tmp/*`"
          "Updated script: `rm -rf /tmp/*`";
    "test commit with cross-platform file paths"
    >:: test_commit "Fixed paths: C:\\Users\\user and /home/user"
          "Fixed paths: C:\\Users\\user and /home/user";
    "test commit with historical references"
    >:: test_commit "Reverted changes from 1920-1930"
          "Reverted changes from 1920-1930";
    "test commit with regular expressions"
    >:: test_commit "Regex update: ^[a-zA-Z0-9]+$"
          "Regex update: ^[a-zA-Z0-9]+$";
    "test commit with pseudo-code"
    >:: test_commit "Algorithm: if x > y then x else y"
          "Algorithm: if x > y then x else y";
    "test commit with currency symbols"
    >:: test_commit "Prices updated: $100, €80, £70"
          "Prices updated: $100, €80, £70";
    "test commit with scientific notation"
    >:: test_commit "Adjusted value: 6.02e23 particles/mole"
          "Adjusted value: 6.02e23 particles/mole";
    "test commit with hashtags and mentions"
    >:: test_commit "New feature #release @devteam"
          "New feature #release @devteam";
    "test commit with palindrome message"
    >:: test_commit "A man a plan a canal Panama" "A man a plan a canal Panama";
    "test commit with chemical formulas"
    >:: test_commit "Updated reaction: H2O + CO2 -> H2CO3"
          "Updated reaction: H2O + CO2 -> H2CO3";
    "test commit with literary references"
    >:: test_commit "Bug fix based on 'To Kill a Mockingbird'"
          "Bug fix based on 'To Kill a Mockingbird'";
    "test commit with VINs"
    >:: test_commit "Updated vehicle data: VIN 1HGCM82633A004352"
          "Updated vehicle data: VIN 1HGCM82633A004352";
    "test commit with political statements"
    >:: test_commit "Refactor based on 1990's economic policies"
          "Refactor based on 1990's economic policies";
    "test commit with pseudonyms"
    >:: test_commit "Code review by The Architect"
          "Code review by The Architect";
    "test commit with mathematical expressions"
    >:: test_commit "Optimized algorithm for x^2 + y^2 = z^2"
          "Optimized algorithm for x^2 + y^2 = z^2";
    "test commit with multiple programming languages"
    >:: test_commit "Fixed Python and JS scripts: def func(), function() {}"
          "Fixed Python and JS scripts: def func(), function() {}";
    "test commit with recipes"
    >:: test_commit "Updated recipe: 2 cups flour, 1 cup sugar"
          "Updated recipe: 2 cups flour, 1 cup sugar";
    "test commit with music references"
    >:: test_commit "Interface redesign inspired by Van Gogh's Starry Night"
          "Interface redesign inspired by Van Gogh's Starry Night";
    "test commit with astronomical data"
    >:: test_commit "New feature: Mars Rover data processing module"
          "New feature: Mars Rover data processing module";
    "test commit with legal jargon"
    >:: test_commit
          "Updated terms and conditions as per Clause 18B of the Agreement."
          "Updated terms and conditions as per Clause 18B of the Agreement.";
    "test commit with professional jargon"
    >:: test_commit "Refactored the ETL pipeline for better data warehousing."
          "Refactored the ETL pipeline for better data warehousing.";
    "test commit with multiple time zones"
    >:: test_commit "Event times updated for EST, GMT, and IST."
          "Event times updated for EST, GMT, and IST.";
    "test commit with complex algorithm pseudocode"
    >:: test_commit
          "Optimized sorting: while n > 1, swap elements if in wrong order"
          "Optimized sorting: while n > 1, swap elements if in wrong order";
    "test commit with philosophical quotes"
    >:: test_commit
          "Code refactor inspired by 'I think, therefore I am' - Descartes"
          "Code refactor inspired by 'I think, therefore I am' - Descartes";
    "test commit with mathematical symbols"
    >:: test_commit "Updated calculation: ∫(x²)dx from 0 to 1"
          "Updated calculation: ∫(x²)dx from 0 to 1";
    "test commit with design terms"
    >:: test_commit "Redesigned UI based on Bauhaus principles."
          "Redesigned UI based on Bauhaus principles.";
    "test commit with scientific experiment description"
    >:: test_commit
          "Fixed the data analysis module: titration experiment with NaOH and \
           HCl."
          "Fixed the data analysis module: titration experiment with NaOH and \
           HCl.";
    "test commit with Morse code"
    >:: test_commit
          "-- . ... ... .- --. .  .. -.  -- --- .-. ... .  -.-. --- -.. ."
          "-- . ... ... .- --. .  .. -.  -- --- .-. ... .  -.-. --- -.. .";
    "test commit with binary code"
    >:: test_commit "Fixed issue 01010100 01000001 01000010"
          "Fixed issue 01010100 01000001 01000010";
    "test commit with reverse order message"
    >:: test_commit "egasseM esreveR" "egasseM esreveR";
    "test commit with geographical coordinates"
    >:: test_commit "Location tagged at 37.7749° N, 122.4194° W"
          "Location tagged at 37.7749° N, 122.4194° W";
    "test commit with hexadecimal values"
    >:: test_commit "Color update: #FF5733, #4A69BD"
          "Color update: #FF5733, #4A69BD";
    "test commit with scientific terms"
    >:: test_commit "Updated algorithm to consider homeostasis and metabolism"
          "Updated algorithm to consider homeostasis and metabolism";
    "test commit with multi-paragraph message"
    >:: test_commit "First paragraph.\n\nSecond paragraph."
          "First paragraph.\n\nSecond paragraph.";
    "test commit with pseudo-random strings"
    >:: test_commit "Random string: asd93#d_!2kD" "Random string: asd";
    "test commit with pseudo-random strings"
    >:: test_commit "Random string: asd93#d_!2kD" "Random string: asd93#d_!2kD";
    "test commit with fictional language"
    >:: test_commit "Klingon code update: Qapla' batlh je"
          "Klingon code update: Qapla' batlh je";
    "test commit with anagrams"
    >:: test_commit "Astronomer -> Moon starer" "Astronomer -> Moon starer";
    "test commit with technical specifications"
    >:: test_commit "Specs updated: CPU 3.5GHz, RAM 16GB, SSD 512GB"
          "Specs updated: CPU 3.5GHz, RAM 16GB, SSD 512GB";
    "test commit with recipe instructions"
    >:: test_commit
          "Recipe update: Mix 2 cups flour, 1 cup water, bake for 20 mins"
          "Recipe update: Mix 2 cups flour, 1 cup water, bake for 20 mins";
    "test commit with non-standard formatting"
    >:: test_commit "Markdown update: **Bold**, *Italic*, `Code`"
          "Markdown update: **Bold**, *Italic*, `Code`";
    "test commit with fictional characters"
    >:: test_commit "Updated character: Frodo Baggins"
          "Updated character: Frodo Baggins";
  ]

let log =
  [
    "test log with large commit test"
    >:: test_log
          [
            "Added a new feature with multiple fixes, including performance \
             improvements and UI enhancements for better user experience.";
            "Fixed critical issue; please run git pull to update your branch \
             with the latest changes and security patches.";
            "Updated the PATH variable in $HOME/.bashrc to include the \
             directory of newly installed tools and dependencies.";
            "Fixed file paths in the project's configuration files, using \
             double backslashes for Windows compatibility.";
            "Fixed a crucial issue in the application's core module, for more \
             details see the documentation at http://example.com.";
            "Resolved a critical issue involving complex string handling: \
             1234567890!@#$%^&*() now correctly parsed and processed.";
            "Added comprehensive logging across all modules for enhanced \
             debugging purposes, facilitating faster issue resolution.";
            "Refactored the main() function to improve its readability and \
             maintainability, following best coding practices.";
            "Implemented a robust user authentication feature with enhanced \
             security measures, including OAuth and JWT tokens.";
            "Successfully resolved a complex merge conflict in utils.py, \
             ensuring the latest features are seamlessly integrated.";
            "Updated the README file with new installation instructions \
             reflecting the latest changes in the project setup process.";
            "Addressed and resolved the issue detailed in (see issue #123); \
             implemented a robust solution to prevent future occurrences.";
            "Deprecated an old API endpoint as part of our ongoing efforts to \
             streamline and modernize our backend services.";
            "Optimized database queries across the application for enhanced \
             performance, particularly in data-intensive operations.";
            "Added comprehensive unit tests for the UserService class, \
             covering all new functionalities and edge cases.";
            "Removed several unused dependencies from package.json to reduce \
             the application's load time and improve efficiency.";
            "Fixed several broken image links in the project's documentation, \
             ensuring all visual aids are properly displayed.";
            "Corrected numerous typos in the user interface text, enhancing \
             the application's professionalism and readability.";
            "Upgraded the project to the latest version of React, taking \
             advantage of the latest features and performance improvements.";
            "Implemented a user-requested dark mode for the application, \
             providing a more comfortable viewing experience in low-light \
             conditions.";
            "Fixed a critical XSS vulnerability discovered in the comment \
             section, enhancing the overall security of the application.";
            "Added localization support for Spanish and French, expanding our \
             application's reach to a broader, global audience.";
            "Resolved a recurring issue where the application crashes on load \
             due to improper resource initialization.";
            "Fixed various layout issues on mobile devices, ensuring a \
             seamless and responsive user experience across all platforms.";
            "Implemented caching for API responses, significantly improving \
             the application's performance and reducing server load.";
            "Updated the design of the user profile page, making it more \
             intuitive and user-friendly while adding new features.";
            "Added comprehensive error handling for all network requests, \
             improving the app's stability and user experience.";
            "Refactored the entire codebase to use modern async/await syntax, \
             simplifying asynchronous code and improving readability.";
            "Improved the logging mechanism for error tracking, providing \
             clearer insights and facilitating faster debugging.";
            "Fixed an issue where incorrect status codes were being returned \
             in API responses, now aligning with RESTful standards.";
            "Implemented a feature toggle system for beta features, allowing \
             selective testing and phased rollouts to users.";
            "Resolved complex timezone issues in event scheduling, ensuring \
             accurate timing across different geographic locations.";
            "Fixed a critical issue where users are unexpectedly logged out, \
             improving session management and user experience.";
            "Adjusted the layout for better responsive design compatibility, \
             ensuring a seamless experience on devices of all sizes.";
            "Implemented OAuth2.0 for enhanced security, providing a more \
             secure and reliable authentication process for users.";
            "Reformatted the entire codebase according to PEP8 standards to \
             maintain consistency and improve code quality.";
            "Enhanced user input validation on all forms, preventing invalid \
             data entry and improving overall data integrity.";
            "Integrated a third-party API for real-time weather data, \
             providing users with accurate and up-to-date weather information.";
            "Fixed a significant bug causing memory leaks in the server code, \
             enhancing the system's stability and performance.";
            "Updated the Dockerfile for optimized container builds, reducing \
             build time and improving deployment efficiency.";
            "Added a feature flag system for the experimental search \
             functionality, allowing controlled testing with selected users.";
            "Improved website load times by optimizing image assets, resulting \
             in faster page rendering and improved user experience.";
            "Refactored the database schema for better scalability, preparing \
             the application for future growth and more data.";
            "Added support for WebSockets in the chat application, enabling \
             real-time communication and a better user experience.";
            "Fixed a critical issue where email notifications were not being \
             sent due to a misconfiguration in the mail server.";
            "Upgraded the server infrastructure to the latest version of \
             Node.js, taking advantage of performance improvements.";
            "Implemented rate limiting on critical API endpoints to prevent \
             abuse and ensure service availability for all users.";
            "Added analytics tracking for key user interactions, enabling \
             data-driven decisions to enhance the application.";
            "Fixed a persistent scroll issue in the newsfeed section, \
             enhancing the user experience on various devices.";
            "Added webhook support for external integrations, allowing \
             seamless integration with third-party services and tools.";
            "Corrected date calculations in financial reports, ensuring \
             accuracy and reliability in fiscal data presentation.";
            "Updated the copyright notice in the project footer to reflect the \
             current year and maintain legal compliance.";
            "Implemented lazy loading for better performance, particularly in \
             reducing initial load times for users with slower connections.";
            "Fixed alignment issues in the navigation bar, enhancing the \
             overall aesthetic and functionality of the website.";
            "Added a user feedback form to gather feature requests and \
             opinions, fostering community engagement and product improvement.";
            "Enhanced the search algorithm to provide faster and more relevant \
             results, improving user satisfaction and efficiency.";
            "Resolved a critical compatibility issue with the Safari browser, \
             ensuring a consistent experience across all platforms.";
            "Improved the user notification system, providing more timely and \
             relevant alerts to enhance user engagement.";
            "Added an avatar upload feature for user profiles, allowing \
             personalization and a more engaging user experience.";
            "Implemented a comprehensive password reset functionality, \
             enhancing account security and user convenience.";
            "Fixed a critical error in an SQL query causing data corruption, \
             ensuring data integrity and system reliability.";
            "Added pagination to the product listing page to improve usability \
             and performance with large inventories.";
            "Enhanced security measures for protecting user data, including \
             encryption and secure data handling practices.";
            "Refactored session management for enhanced robustness, preventing \
             unauthorized access and session hijacking.";
            "Fixed an issue with responsive layout on tablets, ensuring a \
             smooth and consistent experience across all devices.";
            "Implemented a custom 404 error page to improve user experience in \
             case of broken links or missing content.";
            "Improved the caching mechanism for static assets, significantly \
             reducing server load and improving response times.";
            "Added sorting functionality to the user dashboard, enabling users \
             to organize and view data more effectively.";
            "Refactored code for better service layer abstraction, improving \
             modularity and making the system more maintainable.";
            "Enhanced data validation on the backend to prevent invalid data \
             submissions and improve overall system security.";
            "Fixed a UI glitch in the settings panel that caused display \
             issues, enhancing the user interface's consistency.";
            "Implemented bulk actions in the admin interface, allowing \
             administrators to efficiently manage large datasets.";
            "Added an email verification flow for new user registrations, \
             enhancing account security and reducing spam.";
            "Fixed an incorrect API response format that caused \
             inconsistencies in client-server communication.";
            "Updated project dependencies to the latest versions to take \
             advantage of security patches and new features.";
            "Added user activity logs for auditing purposes, providing \
             insights into user behavior and system usage.";
            "Fixed a flickering issue in the CSS animation that affected the \
             user interface's visual appeal and performance.";
            "Implemented theme customization options, allowing users to \
             personalize the look and feel of the application.";
            "Refactored global state management using Redux to enhance \
             performance and maintainability of stateful components.";
            "Added GDPR compliance measures to ensure the application adheres \
             to data protection and privacy regulations.";
            "Improved error handling in the file upload feature, providing \
             clearer feedback and instructions to users.";
            "Implemented two-factor authentication as an additional security \
             measure to protect user accounts from unauthorized access.";
            "Fixed an issue with infinite scroll on mobile devices that caused \
             improper loading of content and user interface glitches.";
            "Refactored routing logic in the front-end application to improve \
             navigation efficiency and maintainability.";
            "Enhanced the performance of the search functionality by \
             optimizing query execution and indexing strategies.";
            "Added unit tests for newly developed utility functions to ensure \
             code reliability and prevent future regressions.";
            "Fixed cross-origin resource sharing (CORS) issues to enable \
             secure and efficient communication between different domains.";
            "Updated the user interface to enhance usability, incorporating \
             modern design principles and user feedback.";
            "Refactored the database interaction layer to improve efficiency, \
             reduce latency, and enhance data access patterns.";
            "Enhanced email templates for better readability and engagement, \
             ensuring communications are clear and effective.";
            "Fixed broken links in the navigation menu, ensuring users can \
             seamlessly navigate through the application.";
            "Implemented a new feature for dynamic report generation with \
             customizable filters and interactive data visualizations.";
            "Improved accessibility features for screen readers, including \
             better ARIA labels and keyboard navigation enhancements.";
            "Fixed layout issues in the email templates, ensuring consistency \
             and clarity across various email clients and devices.";
            "Added comprehensive API documentation using Swagger for easier \
             integration and clearer understanding of API endpoints.";
            "Refactored client-side validation logic to streamline form \
             submissions and enhance user experience with real-time feedback.";
            "Implemented a caching layer for database queries to significantly \
             improve application performance and reduce server load.";
            "Fixed timezone handling in appointment scheduling, ensuring \
             accuracy and consistency in event times across all user locales.";
            "Added error logging to an external monitoring service for \
             real-time alerting and quicker resolution of production issues.";
            "Refactored the authentication flow to streamline user login \
             processes and enhance security with the latest best practices.";
            "Improved the recommendation algorithm for personalized user \
             suggestions, utilizing advanced machine learning techniques.";
            "Fixed an issue with duplicate entries in the database, ensuring \
             data integrity and preventing errors in data retrieval.";
            "Added user roles and permissions functionality, allowing for \
             granular access control and improved security management.";
            "Refactored CSS for better maintainability, adopting BEM \
             methodology and implementing Sass for more structured \
             stylesheets.";
            "Enhanced the mobile user experience by optimizing touch \
             interactions, improving load times, and refining mobile layouts.";
            "Fixed a performance issue with large data sets, optimizing \
             queries and leveraging efficient data structures for processing.";
            "Added integration with a leading payment gateway, enabling secure \
             and diverse payment options for users.";
            "Implemented a feature for exporting data to CSV format, providing \
             users with the flexibility to analyze data offline.";
            "Fixed a critical bug in the notification dispatch system that was \
             causing delayed or missed user notifications.";
            "Updated the privacy policy in compliance with new regulations, \
             ensuring transparent and lawful handling of user data.";
            "Refactored the API layer for better maintainability and \
             scalability, adopting microservices architecture for key \
             components.";
            "Enhanced the user onboarding experience with interactive \
             tutorials, personalized setups, and helpful tips.";
            "Fixed an issue with profile picture uploads, resolving errors in \
             image cropping and file format compatibility.";
            "Added a feature for real-time data synchronization across \
             devices, ensuring users have the most up-to-date information.";
            "Refactored the logging system for better insights, implementing \
             structured logging and integrating with a centralized log \
             management solution.";
            "Implemented a new design for the landing page, featuring a modern \
             aesthetic, clearer messaging, and improved user navigation.";
            "Fixed an issue with the chat functionality in the app, resolving \
             problems with message delivery and notification alerts.";
            "Added an automated backup system for the database, ensuring data \
             safety and enabling easy recovery in case of data loss.";
            "Implemented data visualization tools for analytics, allowing \
             users to interact with and gain insights from their data.";
            "Fixed an issue with user session expiration, ensuring sessions \
             remain active under appropriate conditions and improving user \
             experience.";
            "Added new filters in the search functionality, allowing users to \
             narrow down results based on various criteria.";
            "Refactored API endpoints for a RESTful design, ensuring a more \
             intuitive and standardized interface for developers.";
            "Enhanced security checks in the authentication process, adding \
             additional layers of verification to protect user accounts.";
            "Fixed a layout issue on high-resolution displays, ensuring the UI \
             scales correctly and looks sharp on all screens.";
            "Added functionality for user-generated content, enabling users to \
             contribute articles, comments, and other types of content.";
            "Implemented a responsive design for mobile users, ensuring a \
             seamless and engaging experience on all device types.";
            "Fixed a bug affecting loading times on the homepage, optimizing \
             resource loading and script execution for faster access.";
            "Refactored the newsletter subscription logic, streamlining the \
             process and ensuring compliance with email marketing regulations.";
            "Enhanced the file management system in the app, adding features \
             like drag-and-drop upload, file previews, and better \
             organization.";
            "Fixed a UI issue in the dark mode theme, correcting color \
             inconsistencies and improving readability under dark mode \
             settings.";
            "Implemented an admin dashboard for user management, providing \
             administrators with tools to manage accounts, roles, and access.";
            "Refactored email sending logic to an asynchronous queue, \
             improving performance and reliability of email notifications.";
            "Enhanced the performance of the image processing module, \
             optimizing algorithms for faster rendering and lower resource \
             usage.";
            "Fixed compatibility issues with older browsers, ensuring the app \
             functions correctly and looks consistent across different browser \
             versions.";
            "Added a feature for user-generated reports, enabling users to \
             create custom reports based on their data and preferences.";
            "Refactored the payment processing module, streamlining the \
             workflow and integrating additional security measures.";
            "Enhanced the security of the file storage system, implementing \
             encryption and secure access controls to protect user data.";
            "Fixed an issue with form submission on the contact page, \
             resolving errors and improving the feedback mechanism.";
            "Implemented a tagging system for content categorization, allowing \
             users to tag and organize content for easier discovery.";
            "Refactored the frontend build process for optimization, \
             implementing modern tools and techniques for faster builds.";
            "Enhanced the localization system for multiple languages, \
             improving the translation workflow and accuracy of localized \
             content.";
            "Fixed an issue with data export in the admin panel, resolving \
             format inconsistencies and ensuring data integrity.";
            "Added notifications for specific user actions, providing timely \
             alerts and improving user engagement with the app.";
            "Refactored the model layer for database efficiency, optimizing \
             data models and relationships for better performance.";
            "Enhanced the UI design for a modern look, adopting contemporary \
             design trends and improving the overall aesthetic.";
            "Fixed a bug in user role assignment logic, ensuring correct \
             permissions are assigned and maintained for each user.";
            "Implemented a review and rating system, allowing users to provide \
             feedback on products or services offered in the app.";
            "Refactored the event handling mechanism, improving the efficiency \
             and scalability of event processing in the application.";
            "Enhanced the API rate limiting feature, ensuring fair usage and \
             preventing abuse while maintaining a good user experience.";
            "Fixed an issue with asynchronous task processing, ensuring tasks \
             are executed in the correct order and without delay.";
            "Added a module for automated report generation, providing users \
             with the ability to schedule and customize reports.";
            "Refactored client-side routing for Single Page Applications \
             (SPA), improving navigation speed and user experience.";
            "Enhanced the search engine optimization (SEO) features, ensuring \
             better visibility and ranking in search engine results.";
            "Fixed an issue with mobile navigation in the app, ensuring a \
             smooth and intuitive navigation experience on mobile devices.";
            "Implemented a new feature for comprehensive user notifications, \
             providing customizable alerts and updates within the app.";
            "a";
            "By semantics, we mean the rules that define the behavior of \
             programs. In other words, semantics is about the meaning of a \
             program—what computation a particular piece of syntax represents. \
             Note that although “semantics” is plural in form, we use it as \
             singular. That’s similar to “mathematics” or “physics”. There are \
             two pieces to semantics, the dynamic semantics of a language and \
             the static semantics of a language. The dynamic semantics define \
             the run-time behavior of a program as it is executed or \
             evaluated. The static semantics define the compile-time checking \
             that is done to ensure that a program is legal, beyond any \
             syntactic requirements. The most important kind of static \
             semantics is probably type checking: the rules that define \
             whether a program is well typed or not. Learning the semantics of \
             a new language is usually the real challenge, even though the \
             syntax might be the first hurdle you have to overcome. You need \
             to understand semantics to say what you mean to the computer, and \
             you need to say what you mean so that your program performs the \
             right computation.";
          ];
  ]

let init =
  [
    "test init new repository" >:: test_init_new;
    "test init with existing repository" >:: test_init_exists;
  ]

let test_status_empty _ =
  let expected = "nothing to be committed, working tree clean" in
  let actual = Commands.Status.run () in
  assert_equal expected actual ~printer:(fun s -> s)

let status = [ "test_status_empty" >:: test_status_empty ]

(* test suite driver *)
let tests = List.flatten [ add; commit; log; init; status ]
let suite = "got test suite" >::: tests
let _ = run_test_tt_main suite
