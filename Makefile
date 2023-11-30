.PHONY: got clean build

default: build

clean: 
	rm -rf repo/.got/

build:
	dune build

# Commands
got:
	dune exec bin/main.exe $(filter-out $@,$(MAKECMDGOALS))

test:
	dune exec test/main.exe

# Generic rule to suppress "make: *** No rule to make target `$got-cmd'.  Stop." message
# Note that this also suppresses real unknown targets though.
%:
	@: