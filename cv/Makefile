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
#     (no flag)               vertical timeline, for the blog
#     --input timeline=false  plain flush-left list, for ATS screening
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

# Stamp each PDF with its source's last-modified time rather than "now".
# Typst honours this (see reproducible-builds.org/specs/source-date-epoch),
# so rebuilding unchanged sources yields byte-identical PDFs and leaves the
# working tree clean -- which is what makes committing them bearable.
stamp    = --creation-timestamp $$(date -r $(1) +%s)

FR := $(OUTDIR)/CV-Bouchut-Eric-FR-timeline.pdf $(OUTDIR)/CV-Bouchut-Eric-FR.pdf
EN := $(OUTDIR)/CV-Bouchut-Eric-EN-timeline.pdf $(OUTDIR)/CV-Bouchut-Eric-EN.pdf

.PHONY: cv fr en watch-fr watch-en clean
.DEFAULT_GOAL := cv

cv: fr en
fr: $(FR)
en: $(EN)

# The timeline build is the default one; the ATS build only adds the flag.
$(OUTDIR)/CV-Bouchut-Eric-FR-timeline.pdf: cv-fr.typ $(FONTS) | $(OUTDIR)
	$(TYPST) $(call stamp,$<) $< $@

$(OUTDIR)/CV-Bouchut-Eric-FR.pdf: cv-fr.typ $(FONTS) | $(OUTDIR)
	$(TYPST) $(call stamp,$<) --input timeline=false $< $@

$(OUTDIR)/CV-Bouchut-Eric-EN-timeline.pdf: cv-en.typ $(FONTS) | $(OUTDIR)
	$(TYPST) $(call stamp,$<) $< $@

$(OUTDIR)/CV-Bouchut-Eric-EN.pdf: cv-en.typ $(FONTS) | $(OUTDIR)
	$(TYPST) $(call stamp,$<) --input timeline=false $< $@

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
