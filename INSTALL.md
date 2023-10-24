Run `opam install sha.1.15.4`.

Run `dune build` in the project directory.

To interact with got, first modify / add files in `repo`. We have already added `foo.txt` and `fizz.txt` as files you can work with, but feel free to add more.
- Initializing the repository: `make got init`
- Adding files: `make got add [filename1] [filename2] ...`
- Committing changes: `make got commit [commit message]` 
- Viewing the log: `make got log`