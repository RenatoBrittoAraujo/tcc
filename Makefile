TARGET = TCC_FGA.pdf

BIBTEX = bibtex
LATEX = pdflatex
PS2PDF = ps2pdf

VERSION = 0.1.0

FIXOS_DIR = fixos
FIXOS_SOURCES = informacoes.tex fichaCatalografica.tex \
		listasAutomaticas.tex indiceAutomatico.tex

FIXOS_FILES = $(addprefix $(FIXOS_DIR)/, $(FIXOS_SOURCES))

EDITAVEIS_DIR = editaveis
EDITAVEIS_SOURCES = .

EDITAVEIS_FILES = $(addprefix $(EDITAVEIS_DIR)/, $(EDITAVEIS_SOURCES))

MAIN_FILE = main.tex
DVI_FILE  = $(addsuffix .dvi, $(basename $(MAIN_FILE)))
AUX_FILE  = $(addsuffix .aux, $(basename $(MAIN_FILE)))
PS_FILE   = $(addsuffix .ps, $(basename $(MAIN_FILE)))
PDF_FILE  = $(addsuffix .pdf, $(basename $(MAIN_FILE)))

SOURCES = $(FIXOS_FILES) $(EDITAVEIS_FILES)

.PHONY: all clean dist-clean

all: 
	@make $(TARGET)
     
$(TARGET): $(MAIN_FILE) $(SOURCES) bibliografia.bib
	$(LATEX) $(MAIN_FILE) $(SOURCES)
	$(BIBTEX) $(AUX_FILE)
	$(LATEX) $(MAIN_FILE) $(SOURCES)
	$(LATEX) $(MAIN_FILE) $(SOURCES)
	@cp $(PDF_FILE) $(TARGET)
	echo MOVING STUFF
	mv main* build
	mv build/main.tex .

install-deps:
	sudo apt-get install texlive-latex-base texlive-full
	echo ======== INSTALL THE FOLLOWING VSCODE EXTENSIONS
	echo ======== 1. LaTeX
	echo ======== 2. LaTeX Workshop
	

clean:
	rm -f *~ *.dvi *.ps *.backup *.aux *.log
	rm -f *.lof *.lot *.bbl *.blg *.brf *.toc *.idx
	rm -f *.pdf *.fls *.fdb_latexmk *.ind
	
dist: clean
	tar vczf tcc-fga-latex-$(VERSION).tar.gz *

dist-clean: clean
	rm -f $(PDF_FILE) $(TARGET)
