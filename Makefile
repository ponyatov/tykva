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
doc: tmp/$(MODULE).pdf

TEX  = $(wildcard doc/*.tex)
FIG  = $(wildcard doc/*.png)
FIG += $(wildcard doc/*.pdf)
LST  = $(wildcard doc/*.t)

LATEX = pdflatex -halt-on-error doc/manual.tex
tmp/$(MODULE).pdf: $(TEX) $(FIG) $(LST)
	$(LATEX) && $(LATEX)
tmp/$(MODULE)_screen.pdf: tmp/$(MODULE).pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen \
		-dNOPAUSE -dQUIET -dBATCH \
		-sOutputFile=$(MODULE)_$(TODAY).pdf book/$(MODULE).pdf

.PHONY: doxy
doxy:

# format
.PHONY: format
format: tmp/format_c tmp/format_d
tmp/format_c: $(C) $(H)
	clang-format -style=file -i $? && touch $@
tmp/format_d: $(D)
	dub run dfmt -- -i $? && touch $@

# install
.PHONY: install update ref gz
install: ref gz
	$(MAKE) update
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
ref:
gz:
