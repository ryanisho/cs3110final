open OUnit2
open Commands

(* helper test functions *)
let test_add files _ =
  let result = Commands.Add.run files in
  assert_equal ("Added " ^ String.concat " " files) result

let test_commit messages expected_message _ =
  let result = Commands.Commit.run messages in
  let startswith_committed = String.sub result 0 9 = "Committed" in
  let contains_message =
    String.contains result ':'
    && String.sub result
      (String.index result ':' + 3)
      (String.length expected_message)
       = expected_message
  in
  assert_bool "Output does not start with 'Committed'" startswith_committed;
  assert_bool "Output does not contain the correct commit message"
    contains_message

let test_init_new _ =
  let _ = Unix.system "rm -rf ./repo/.got/" in
  let result = Commands.Init.run () in
  assert_equal "Initialized empty repository." result;
  assert (Sys.file_exists "./repo/.got/");
  assert (Sys.file_exists "./repo/.got/blobs/");
  assert (Sys.file_exists "./repo/.got/commits/");
  assert (Sys.file_exists "./repo/.got/stage.msh");
  ()

let test_init_exists _ =
  assert_raises
    (Failure
       "A Got version-control system already exists in the current directory.")
    (fun () -> Commands.Init.run ());
  ()

let add =
  [
    (* no files *)
    ( "test with no files" >:: fun _ ->
          let result = Commands.Add.run [] in
          assert_equal "No file added." result );
    (* variation testing *)
    "test with one file" >:: test_add [ "../test/test/txt/apples.txt" ];
    "test with multiple files"
    >:: test_add
      [ "../test/test/txt/apples.txt"; "../test/test/txt/loremipsum.txt" ];
    "test with images" >:: test_add [ "../test/test/img/james.png" ];
    "test with multiple images"
    >:: test_add [ "../test/test/img/james.png"; "../test/test/img/chris.png" ];
    "test with audio" >:: test_add [ "../test/test/mp3/river.mp3" ];
    "test with multiple audio"
    >:: test_add
      [ "../test/test/mp3/river.mp3"; "../test/test/mp3/walking.mp3" ];
    "test with images and audio and text"
    >:: test_add
      [
        "../test/test/txt/apples.txt";
        "../test/test/img/james.png";
        "../test/test/mp3/river.mp3";
      ];
    (* extension variability testing *)
    (* Text Files *)
    "test with Markdown file" >:: test_add [ "../test/test/txt/document.md" ];
    "test with XML file" >:: test_add [ "../test/test/xml/data.xml" ];
    "test with JSON file" >:: test_add [ "../test/test/json/config.json" ];
    "test with CSV file" >:: test_add [ "../test/test/docs/data.csv" ];
    (* Image Files *)
    "test with JPEG image" >:: test_add [ "../test/test/img/cat.jpeg" ];
    "test with BMP image" >:: test_add [ "../test/test/img/flower.bmp" ];
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
    >:: test_add [ "../test/test/code/.gitconfig" ];
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
    "test with ePub file" >:: test_add [ "../test/test/docs/ebook.epub" ];
    "test with MOBI file" >:: test_add [ "../test/test/docs/ebook.mobi" ];
    "test with Rich Text Format"
    >:: test_add [ "../test/test/docs/document.rtf" ];
    "test with OpenDocument Spreadsheet"
    >:: test_add [ "../test/test/spreadsheet/sheet.ods" ];
    (* Specialized Data Formats *)
    "test with HDF5 file" >:: test_add [ "../test/test/data/data.h5" ];
    "test with GeoJSON file" >:: test_add [ "../test/test/data/map.geojson" ];
    "test with KML file" >:: test_add [ "../test/test/data/locations.kml" ];
    "test with Parquet file" >:: test_add [ "../test/test/data/data.parquet" ];
    "test with Avro file" >:: test_add [ "../test/test/data/data.avro" ];
    (* Combination of Diverse File Types *)
    "test with various script files"
    >:: test_add
      [ "../test/test/script/run.sh"; "../test/test/script/automation.py" ];
    "test with multiple config files"
    >:: test_add
      [ "../test/test/config/nginx.conf"; "../test/test/config/.gitconfig" ];
    "test with mixed media files"
    >:: test_add
      [ "../test/test/media/video.mp4"; "../test/test/media/audio.mp3" ];
    "test with various document types"
    >:: test_add
      [ "../test/test/docs/file.pdf"; "../test/test/docs/ebook.epub" ];
    "test with assorted data files"
    >:: test_add [ "../test/test/data/data.json"; "../test/test/data/data.csv" ];
  ]

let commit =
  [
    "test commit with no message" >:: test_commit [ "" ] "";
    "test commit with simple message"
    >:: test_commit [ "Initial commit" ] "Initial commit";
    "test commit with complex message"
    >:: test_commit
      [ "Added new feature with multiple fixes" ]
      "Added new feature with multiple fixes";
    "test commit with special characters"
    >:: test_commit
      [ "Fix: Handle the issue #123" ]
      "Fix: Handle the issue #123";
    "test commit with very long message"
    >:: test_commit [ String.make 255 'a' ] (String.make 255 'a');
    "test commit with multiline message"
    >:: test_commit [ "First line"; "Second line" ] "First line Second line";
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
