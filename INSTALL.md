Run `opam install sha.1.15.4`.

To interact with got, first modify / add files in `repo`. We have already added `foo.txt` and `fizz.txt` as files you can work with, but feel free to add more.
- Initializing the repository: `./got init`
- Adding files: `./got add [filename1] [filename2] ...`
- Removing files: `./got rm [filename1] [filename2] ...`
- Committing changes: `./got commit [commit message]` 
- Viewing the log: `./got log`
- Get status: `./got status`
- For more details, see README.md