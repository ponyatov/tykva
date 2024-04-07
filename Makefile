# var
MODULE  = $(notdir $(CURDIR))

# dir
CWD   = $(CURDIR)

# tool
CURL = curl -L -o
CF   = clang-format -style=file

# src
C = $(wildcard src/*.c*)
H = $(wildcard inc/*.h*)
D = $(wildcard src/*.d*)
T = $(wildcard lib/*.t*)

# all
.PHONY: all run 
all:
	dub build
run: $(T)
	dub run -- $^

# doc
.PHONY: doc
doc:

.PHONY: doxy
doxy:

# format
.PHONY: format
format: tmp/format_c tmp/format_d
tmp/format_c: $(C) $(H)
	clang-format -style=file -i $? && touch $@
tmp/format_d: $(D)
	dub run dfmt -- -i $? && touch $@
