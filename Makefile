.PHONY: test clean got

build:
	dune build

test:
# remove existing test repository (if exists)
	dune clean
	rm -rf repo/.got/	
# create new got repository for testing
	dune exec bin/main.exe init
# run existing tests
	-OCAMLRUNPARAM=b dune exec test/main.exe
# remove test repository
	rm -rf repo/.got/

clean: 
	dune clean
	rm -rf repo/.got/

loc:
	dune clean
	cloc --by-file --include-lang=OCaml .
	
doc: 
	dune build @doc

opendoc : doc 
	@bash opendoc.sh