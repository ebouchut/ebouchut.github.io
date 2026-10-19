# Build the Typst CV into the four PDFs the site publishes.
#
# Run it from the repository root:
#
#     make -C cv            # all four PDFs (default goal)
#     make -C cv fr         # French only
#     make -C cv watch-fr   # live recompile while editing
#
# or from this directory with a plain `make`.
#
# Each language has one source and two builds, chosen by a compile flag:
#
#     (no flag)               vertical timeline -- the default CV, named
#                             CV-Bouchut-Eric-<LANG>.pdf
#     --input timeline=false  plain flush-left list for applicant-tracking
#                             systems, named CV-Bouchut-Eric-<LANG>-ATS.pdf
#
# The plain name carries the CV you would hand someone; only the special case
# is labelled.
#
# The PDFs are written to root/cv/, which the publish workflow copies to the
# site root (`cp -R root/. site/`), so they are served from
# https://www.ericbouchut.com/cv/ without any change to publish.yml.

OUTDIR  := ../root/cv
FONTS   := $(wildcard fonts/*.ttf)

# --ignore-system-fonts is what makes a build machine-independent: only the
# faces in fonts/ are considered, so this laptop cannot quietly resolve the
# Helvetica and Arial fallbacks that a CI runner does not have. It leaves
# today's output byte-for-byte unchanged, and keeps it that way.
TYPST   := typst compile --ignore-system-fonts --font-path fonts

# Stamp every PDF with one fixed date rather than "now", so that rebuilding
# unchanged sources yields byte-identical files and leaves the working tree
# clean -- which is what makes committing the PDFs bearable.
#
# It has to be a constant. The obvious candidate, the source's own mtime, is
# not stable: a checkout, a stash, a rebase or a GitButler commit rewrites the
# working tree and moves it, and a fresh clone stamps every file with the
# clone time, so CI could never reproduce what was committed here.
#
# The cost is that the PDF metadata reports this date instead of the build
# date. The CV's real history is in the git log.
#
# 1792281600 = 2026-10-18T00:00:00Z, the day this pipeline landed.
STAMP   := --creation-timestamp 1792281600

FR := $(OUTDIR)/CV-Bouchut-Eric-FR.pdf $(OUTDIR)/CV-Bouchut-Eric-FR-ATS.pdf
EN := $(OUTDIR)/CV-Bouchut-Eric-EN.pdf $(OUTDIR)/CV-Bouchut-Eric-EN-ATS.pdf

.PHONY: cv fr en watch-fr watch-en clean
.DEFAULT_GOAL := cv

cv: fr en
fr: $(FR)
en: $(EN)

# The timeline build is the default one; the ATS build only adds the flag.
$(OUTDIR)/CV-Bouchut-Eric-FR.pdf: cv-fr.typ $(FONTS) | $(OUTDIR)
	$(TYPST) $(STAMP) $< $@

$(OUTDIR)/CV-Bouchut-Eric-FR-ATS.pdf: cv-fr.typ $(FONTS) | $(OUTDIR)
	$(TYPST) $(STAMP) --input timeline=false $< $@

$(OUTDIR)/CV-Bouchut-Eric-EN.pdf: cv-en.typ $(FONTS) | $(OUTDIR)
	$(TYPST) $(STAMP) $< $@

$(OUTDIR)/CV-Bouchut-Eric-EN-ATS.pdf: cv-en.typ $(FONTS) | $(OUTDIR)
	$(TYPST) $(STAMP) --input timeline=false $< $@

$(OUTDIR):
	mkdir -p $@

# Previews are scratch files, never the published PDFs, so that an editing
# session cannot leave a half-finished CV staged for commit.
watch-fr:
	typst watch --ignore-system-fonts --font-path fonts cv-fr.typ preview-fr.pdf

watch-en:
	typst watch --ignore-system-fonts --font-path fonts cv-en.typ preview-en.pdf

clean:
	rm -f $(FR) $(EN) preview-fr.pdf preview-en.pdf
