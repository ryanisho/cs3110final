.PHONY: test clean got

build:
	dune build

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

clean: 
	rm -rf repo/.got/

# Commands
got:
	dune exec bin/main.exe $(filter-out $@,$(MAKECMDGOALS))

# Generic rule to suppress "make: *** No rule to make target `$got-cmd'.  Stop." message
# Note that this also suppresses real unknown targets though.
%:
	@: