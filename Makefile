##################################################################################################################################
#	Dominik Bauer, 
#	use:
#	make 			build the sheet
#	make draft		build an draft version of the sheet
#	make clean		clean the messy stuff
#	make count		count words, merge include files
#	make resize		compress the pdf to 300dpi
#	make resize_minimal	compress to minimal dpi
#	make lua		build the sheet with lualatex
#	make beam		start okular in presentation mode (for example beamer.pdf) 
##################################################################################################################################
#	To-Do:
#	make svn_ci		commit to svn repo (git?) --> Backup 
#  inkscape -D -z --file=versuchsaufbau2.svg --export-pdf=image.pdf --export-latex
##################################################################################################################################


####################################
#       PROJECT
###################################
SRCDIR=src
PROJECT=$(shell grep '\\newcommand\*{\\Projektname}' $(SRCDIR)/bewerbung.tex | sed 's/.*{\(.*\)}.*/\1/')
FILENAME=$(shell grep '\\newcommand\*{\\PDFDateiname}' $(SRCDIR)/$(PROJECT).tex | sed 's/.*{\(.*\)}.*/\1/')


####################################
#       SETTINGS
###################################
OUTPUTDIR=output
SHELL=/bin/bash
export TEXINPUTS=./$(SRCDIR)//:./:


####################################
#       EXECTUABLE
###################################
TEX=lualatex
BIBER=biber
GHOSTSCRIPT=gs
LUALATEX=lualatex
OKULAR=okular
GLOSSARIES=makeglossaries
TEXCOUNT=./misc/texcount.pl

####################################
#       COLORS
###################################
NO_COLOR=\e[0m
OK_COLOR=\e[32;01m
ERROR_COLOR=\e[31;01m
WARN_COLOR=\e[33;01m
RUN_COLOR=\e[1;34m

####################################
#       FLAGS
###################################
#Tex Flags
TFLAGS+=--output-directory=$(OUTPUTDIR)
TFLAGS+=--shell-escape
#TFLAGS+=--interaction=nonstopmode
TFLAGS+=--file-line-error

#Biber Flags
BFLAGS+=--output_directory $(OUTPUTDIR)
BFLAGS+=

#Ghostscript Flags
GFLAGS+=-dNOPAUSE
GFLAGS+=-dBATCH 
GFLAGS+=-dDownsampleColorImages=true 
GFLAGS+=-dColorImageResolution=300
GFLAGS+=-dDownsampleGrayImages=true 
GFLAGS+=-dGrayImageResolution=300
GFLAGS+=-dDownsampleMonoImages=true 
GFLAGS+=-dMonoImageResolution=300
GFLAGS+=-sDEVICE=pdfwrite 
GFLAGS+=-sOutputFile=$(PROJECT)_resize.pdf 

#LuaLates Flags
LFLAGS+=-synctex=1
LFLAGS+=-interaction=nonstopmode
LFLAGS+=-output-directory=$(OUTPUTDIR) 
LFLAGS+=--shell-escape


#texcount Flags
TXFLAGS+=-inc
TXFLAGS+=-v0
TXFLAGS+=-auxdir=.$(OUTPUTDIR) 
TXFLAGS+=-relaxed

#Okular Flags
OFLAGS+=--presentation

#Glossaries Flags
GLFLAGS+=-d $(OUTPUTDIR)

#RM Flags
RMFLAGS+=-rf

#Grep-Flags
GRFLAGS+=-A 8 
GRFLAGS+=--color=always
GRFLAGS+=-i
TEXSEARCH+=".*:[0-9]*:.*\|warning"

#sed Flags
SFLAGS+=-e
BWARNSEARCH+="s/^WARN/\x1b[33;01m&\x1b[0m/" 
BERRSEARCH+="s/^ERROR/\x1b[31;01m&\x1b[0m/"
BINFOSEARCH+="s/^INFO/\x1b[32;01m&\x1b[0m/"

#Draft Flags
DFLAGS+="\def\isdraft{1} \input{$(SRCDIR)/$(PROJECT).tex}"

####################################
#      EXE 
##################################
BUILDTEX1		=$(TEX) $(TFLAGS) -draftmode $(SRCDIR)/$(PROJECT).tex
#| grep $(GRFLAGS) $(TEXSEARCH)
BUILDBIBER		=$(BIBER) $(BFLAGS) $(PROJECT) 	 | sed $(SFLAGS) $(BWARNSEARCH) \
												 | sed $(SFLAGS) $(BERRSEARCH)  \
												 | sed $(SFLAGS) $(BINFOSEARCH)

BUILDTEX		=$(TEX) $(TFLAGS) $(SRCDIR)/$(PROJECT).tex
#| grep $(GRFLAGS) $(TEXSEARCH)
BUILDLUA		=$(LUALATEX) $(SRCDIR)/$(PROJECT).tex
BUILDOKULAR		=$(OKULAR) $(PROJECT).pdf $(OFLAGS)
BUILDDRAFT		=$(TEX) $(TFLAGS) $(DFLAGS)
#| grep $(GRFLAGS) $(TEXSEARCH)
BUILDRESIZE		=$(GHOSTSCRIPT) $(GFLAGS) $(PROJECT).pdf
BUILDGLOSSARIES	=$(GLOSSARIES) $(GLFLAGS) $(PROJECT)
BUILDCOUNT		=$(TEXCOUNT) $(TXFLAGS) $(SRCDIR)/$(PROJECT).tex 
COPY			=cp $(OUTPUTDIR)/$(PROJECT).pdf "$(FILENAME).pdf" \
						&& printf "$(RUN_COLOR)[$@]\t\t$(NO_COLOR) $(OK_COLOR) Copy $(PROJECT).pdf from $(OUTPUTDIR) to $(FILENAME).pdf$(NO_COLOR)\n";
####################################
#       PHONY
###################################
.PHONY: clean
.PHONY: clean-all
.PHONY: draft
.PHONY: count
.PHONY: glossaries
.PHONY: checkdir
.PHONY: bewerbung
.PHONY: scan

#Bewerbung Dirs
BEWERBUNGEN_JSON=Bewerbungs-Adressen/bewerbungen.json
GENERIERT_DIR=Bewerbungs-Adressen/Generierte Bewerbungsdaten


####################################
#       SILENT MODE
###################################
.SILENT:

# make bewerbung <firmenname> - Argumente nach "bewerbung" als Firmenname nutzen
ifeq (bewerbung,$(firstword $(MAKECMDGOALS)))
  BEWERBUNG_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(BEWERBUNG_ARGS):;@:)
endif

####################################
#       RULES
###################################
cv: clean-all checkdir
		@printf "$(RUN_COLOR)[TeX]\t\t$(NO_COLOR) $(OK_COLOR) Building TeX files in final mode (1st run)$(NO_COLOR)\n";
		$(BUILDTEX1)
		#@printf "$(RUN_COLOR)[makeglossaries]\t$(NO_COLOR) $(OK_COLOR) Building glossaries $(NO_COLOR)\n";
		#$(BUILDGLOSSARIES)
		@printf "$(RUN_COLOR)[Biber]\t$(NO_COLOR) $(OK_COLOR) Creating BibTeX entries $(NO_COLOR)\n"; 
		$(BUILDBIBER)
		@printf "$(RUN_COLOR)[TeX]\t\t$(NO_COLOR) $(OK_COLOR) Building TeX files in final mode (2nd run)$(NO_COLOR)\n";
		$(BUILDTEX1)
		@printf "$(RUN_COLOR)[TeX]\t\t$(NO_COLOR) $(OK_COLOR) Building TeX files in final mode (3nd run)$(NO_COLOR)\n";
		$(BUILDTEX)
		$(COPY)
		@printf "$(RUN_COLOR)[PDF]\t\t$(NO_COLOR) $(OK_COLOR) Opening PDF file $(NO_COLOR)\n";
		xdg-open "$(FILENAME).pdf" &

bewerbung: checkdir
ifeq ($(strip $(BEWERBUNG_ARGS)),)
		$(error Usage: make bewerbung <firmenname>  z.B. make bewerbung Virtual-Minds-GmbH)
endif
		@printf "$(RUN_COLOR)[Generate]\t$(NO_COLOR) $(OK_COLOR) Generiere Firmendaten fuer: $(BEWERBUNG_ARGS)$(NO_COLOR)\n";
		python3 scripts/generate-firmendaten.py $(BEWERBUNGEN_JSON) "$(BEWERBUNG_ARGS)" $(SRCDIR)
		@printf "$(RUN_COLOR)[TeX]\t\t$(NO_COLOR) $(OK_COLOR) Building Bewerbung (1st run)$(NO_COLOR)\n";
		$(BUILDTEX1)
		@printf "$(RUN_COLOR)[TeX]\t\t$(NO_COLOR) $(OK_COLOR) Building Bewerbung (2nd run)$(NO_COLOR)\n";
		$(BUILDTEX)
		@FIRMA=$$(cat $(SRCDIR)/firma.txt); \
		mkdir -p "$(GENERIERT_DIR)/$$FIRMA"; \
		cp $(OUTPUTDIR)/$(PROJECT).pdf "$(GENERIERT_DIR)/$$FIRMA/Bewerbungsunterlagen-$$FIRMA.pdf"; \
		cp $(SRCDIR)/firmendaten.tex "$(GENERIERT_DIR)/$$FIRMA/firmendaten.tex"; \
		printf "$(RUN_COLOR)[Copy]\t\t$(NO_COLOR) $(OK_COLOR) PDF nach $(GENERIERT_DIR)/$$FIRMA/$(NO_COLOR)\n"; \
		printf "$(RUN_COLOR)[PDF]\t\t$(NO_COLOR) $(OK_COLOR) Opening PDF$(NO_COLOR)\n"; \
		nohup xdg-open "$(GENERIERT_DIR)/$$FIRMA/Bewerbungsunterlagen-$$FIRMA.pdf" >/dev/null 2>&1 &
		rm -f $(SRCDIR)/firmendaten.tex $(SRCDIR)/firma.txt

scan:
		@printf "$(RUN_COLOR)[Scan]\t\t$(NO_COLOR) $(OK_COLOR) Scanne Fotos in Bewerbungs-Adressen/Fotos/$(NO_COLOR)\n";
		python3 scripts/scan-fotos.py

draft: checkdir
		@printf "$(RUN_COLOR)[$@]\t\t$(NO_COLOR) $(OK_COLOR) Building TeX files in draft mode $(NO_COLOR)\n";
		$(BUILDDRAFT)
		@printf "$(WARN_COLOR)[$@]\t\t$(NO_COLOR) $(WARN_COLOR) Draft mode: Bibliographie, glossaries and page numbers \
may not be updated!!! $(NO_COLOR)\n";
		$(COPY)

glossaries:
		@printf "$(RUN_COLOR)[$@]\t\t$(NO_COLOR) $(OK_COLOR) Building glossaries $(NO_COLOR)\n";
		$(BUILDGLOSSARIES)

clean-all:
	find . -type f -name "*.aux" -exec rm -rf {} \;
	find . -type f -name "*.log" -exec rm -rf {} \;
	find . -type f -name "*.bak" -exec rm -rf {} \;
	find . -type f -name "*.bbl" -exec rm -rf {} \;
	find . -type f -name "*.blg" -exec rm -rf {} \;
	find . -type f -name "*.idx" -exec rm -rf {} \;
	find . -type f -name "*.toc" -exec rm -rf {} \;
	find . -type f -name "*.out" -exec rm -rf {} \;
	find . -type f -name "*.upa" -exec rm -rf {} \;
	find . -type f -name "*.tex~" -exec rm -rf {} \;

clean:
		@printf "$(RUN_COLOR)[$@]\t\t$(NO_COLOR) $(ERROR_COLOR) Removing old files in $(OUTPUTDIR)$(NO_COLOR)\n";
		rm $(RMFLAGS) $(OUTPUTDIR)/*

count:
		@printf "$(RUN_COLOR)[$@]\t\t$(NO_COLOR) $(OK_COLOR) Count words in $(PROJECT).tex $(NO_COLOR)\n";
		$(BUILDCOUNT) 
resize:
		@printf "$(RUN_COLOR)[$@]\t\t$(NO_COLOR) $(OK_COLOR) Resize document to 300dpi $(NO_COLOR)\n";
		$(BUILDRESIZE) 
resize_minimal:
		$(GHOSTSCRIPT) -dNOPAUSE -dBATCH -dDownsampleColorImages=true -dColorImageResolution=75\
	       		-dDownsampleGrayImages=true -dGrayImageResolution=75\
		       	-dDownsampleMonoImages=true -dMonoImageResolution=75\
		       	-sDEVICE=pdfwrite -sOutputFile=$(PROJECT)_minimal.pdf $(PROJECT).pdf


lua:
		@printf "$(RUN_COLOR)[$@]\t\t$(NO_COLOR) $(OK_COLOR) Building Tex files with LuaLatex $(NO_COLOR)\n";
		$(BUILDLUA)

beam:
		@printf "$(RUN_COLOR)[$@]\t\t$(NO_COLOR) $(OK_COLOR) Starting $(OKULAR) in presentation mode $(NO_COLOR)\n";
		$(BUILDOKULAR) 
checkdir:
		@printf "$(RUN_COLOR)[$@]\t$(NO_COLOR) $(OK_COLOR) Checking directory $(NO_COLOR)\n";
		if [ ! -d "./$(OUTPUTDIR)" ];then\
			mkdir $(OUTPUTDIR);\
			printf "$(RUN_COLOR)[$@]\t$(NO_COLOR) $(WARN_COLOR) Creating output directory$(NO_COLOR)\n";\
		fi
#EOF
