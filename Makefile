.PHONY: test clean got

build:
	dune build

test:
# remove existing test repository (if exists)
	rm -rf repo/.got/	
# create new got repository for testing
	dune exec bin/main.exe init
# run existing tests
	-OCAMLRUNPARAM=b dune exec test/main.exe
# remove test repository
	rm -rf repo/.got/

clean: 
	rm -rf repo/.got/

# Commands
got:
	dune exec bin/main.exe $(filter-out $@,$(MAKECMDGOALS))

# Generic rule to suppress "make: *** No rule to make target `$got-cmd'.  Stop." message
# Note that this also suppresses real unknown targets though.
%:
	@: