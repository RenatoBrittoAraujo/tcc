TARGET = tcc.pdf

BIBTEX = bibtex
LATEX = pdflatex
PS2PDF = ps2pdf

BUILD_FOLDER = build
LATEX_FLAGS = -output-directory=$(BUILD_FOLDER)

VERSION = 0.1.0

CONFIG_DIR = config
CONFIG_SOURCES = listasAutomaticas.tex indiceAutomatico.tex

CONFIG_FILES = $(addprefix $(CONFIG_DIR)/, $(CONFIG_SOURCES))

SRC_DIR = src
SRC_SOURCES = .

SRC_FILES = $(addprefix $(SRC_DIR)/, $(SRC_SOURCES))

MAIN_FILE = main.tex
DVI_FILE  = $(addsuffix .dvi, $(basename $(MAIN_FILE)))
AUX_FILE  = $(addsuffix .aux, $(basename $(MAIN_FILE)))
PS_FILE   = $(addsuffix .ps, $(basename $(MAIN_FILE)))
PDF_FILE  = $(addsuffix .pdf, $(basename $(MAIN_FILE)))

PDF_NAME = main.pdf

SOURCES = $(CONFIG_FILES) $(SRC_FILES)

.PHONY: all clean dist-clean

all: 
	rm -f tcc.pdf
	@make $(TARGET) 
     
$(TARGET): $(MAIN_FILE) $(SOURCES) bibliografia.bib
	$(LATEX) $(LATEX_FLAGS) $(MAIN_FILE) $(SOURCES) 
	$(BIBTEX) $(BUILD_FOLDER)/$(AUX_FILE) 
	$(LATEX) $(LATEX_FLAGS) $(MAIN_FILE) $(SOURCES) 
	$(LATEX) $(LATEX_FLAGS) $(MAIN_FILE) $(SOURCES) 
	echo fim
	cp $(BUILD_FOLDER)/$(PDF_NAME) $(TARGET)

install-deps:
	sudo apt-get install texlive-latex-base texlive-full
	@printf "\n\n"
	@echo "==> NOW INSTALL THE FOLLOWING VSCODE EXTENSIONS <=="
	@printf "\t\t-> LaTeX\n"
	@printf "\t\t-> LaTeX Workshop\n\n"

clean:
	rm -f *~ *.dvi *.ps *.backup *.aux *.log
	rm -f *.lof *.lot *.bbl *.blg *.brf *.toc *.idx
	rm -f *.pdf *.fls *.fdb_latexmk *.ind
	rm -rf build/*
	touch build/.gitkeep
	
dist: clean
	tar vczf tcc-fga-latex-$(VERSION).tar.gz *

dist-clean: clean
	rm -f $(PDF_FILE) $(TARGET)
