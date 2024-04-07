# var
MODULE  = $(notdir $(CURDIR))

# dir
CWD   = $(CURDIR)
TMP   = $(CWD)/tmp

# tool
CURL = curl -L -o
CF   = clang-format -style=file

# src
C  = $(wildcard src/*.c*)
H  = $(wildcard inc/*.h*)
D  = $(wildcard src/*.d*)
T  = $(wildcard lib/*.t*)

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

LATEX = pdflatex \
		-halt-on-error -output-directory $(TMP) \
		manual.tex
# -interaction=batchmode
tmp/$(MODULE).pdf: $(TEX) $(FIG) $(LST)
	rm $@ ; cd doc ; $(LATEX) && $(LATEX)
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
	$(CF) -i $? && touch $@
tmp/format_d: $(D)
	dub run dfmt -- -i $? && touch $@

# install
.PHONY: install update ref gz
install: ref gz
	$(MAKE) update
	dub build dfmt
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
ref:
gz:

# merge
MERGE += Makefile README.md apt.txt LICENSE
MERGE += .clang-format .editorconfig .doxygen .gitignore
MERGE += .vscode bin doc lib inc src tmp ref

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout shadow -- $(MERGE)

.PHONY: shadow
shadow:
	git push -v
	git checkout $@
	git pull -v

.PHONY: release
release:
	git tag $(NOW)-$(REL)
	git push -v --tags
	$(MAKE) shadow

.PHONY: zip
zip:
	git archive \
		--format zip \
		--output $(TMP)/$(MODULE)_$(NOW)_$(REL).src.zip \
	HEAD
