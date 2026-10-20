#!/usr/bin/env python3
"""Assert the invariants that must hold for every built CV PDF.

Run it through the Makefile, which supplies pypdf without pulling in the
site's own dependencies:

    make -C cv check

Two properties of the design are settled and easy to break from the Typst
source: each build is exactly one A4 page, and its text must stay selectable
so that applicant-tracking systems can read it. One line too many silently
spills onto a second page, and neither property shows up in a source diff,
so they are checked here instead of by eye.

A third check guards the font bundle: if a build ever renders with a face
that is not in `fonts/`, the PDF stops matching the reference design, which
is precisely what bundling the fonts was meant to prevent.
"""

from __future__ import annotations

import sys
from dataclasses import dataclass
from pathlib import Path

from pypdf import PdfReader

# A4 as Typst emits it at 72 dpi: 595.28 x 841.89 pt.
A4_WIDTH_PT = 595.28
A4_HEIGHT_PT = 841.89

# The faces bundled in fonts/, as they appear in a PDF's /BaseFont entry.
# Anything else means a fallback family was reached.
ALLOWED_FONTS = frozenset(
    {"Poppins", "Poppins-SemiBold", "LiberationSans", "LiberationSans-Bold"}
)

# A correct build already sits 0.0044pt from the rounded constants above, so
# an exact comparison would fail on every sound PDF. The nearest other paper
# size, US Letter, is about 17pt wider and 50pt shorter. Any threshold between
# those two separates rounding noise from a real change; 1pt sits comfortably
# inside the gap and needs no explanation when it fires.
PAGE_SIZE_TOLERANCE_PT = 1.0

# The real builds carry 2718 (EN) to 2898 (FR) characters. The floor is set
# well below that: it should catch a page that rendered as outlines or stopped
# halfway, not fail the day the CV is legitimately shortened. A check that
# cries wolf gets ignored, which is worse than not having it.
MIN_TEXT_CHARACTERS = 1500


@dataclass(frozen=True)
class Pdf:
    """What one built PDF says about itself."""

    path: Path
    pages: int
    width_pt: float
    height_pt: float
    text: str
    fonts: frozenset[str]


def read(path: Path) -> Pdf:
    """Collect the facts needed to judge one PDF."""
    reader = PdfReader(path)
    box = reader.pages[0].mediabox
    fonts: set[str] = set()
    for page in reader.pages:
        resources = page.get("/Resources") or {}
        for font in (resources.get("/Font") or {}).values():
            base = font.get_object().get("/BaseFont")
            if base:
                # Subset fonts carry a six-letter tag, as in `ABCDEF+Poppins`.
                fonts.add(str(base).lstrip("/").split("+")[-1])
    return Pdf(
        path=path,
        pages=len(reader.pages),
        width_pt=float(box.width),
        height_pt=float(box.height),
        text=reader.pages[0].extract_text(),
        fonts=frozenset(fonts),
    )


def problems(pdf: Pdf) -> list[str]:
    """Return one message per broken invariant, empty when the PDF is sound.

    Every message names the value that was measured, so a CI log explains
    itself months later without anyone rebuilding locally.
    """
    found: list[str] = []

    # The invariant most likely to break: two extra lines in the source spill
    # onto a second page, and Typst reports nothing.
    if pdf.pages != 1:
        found.append(f"{pdf.pages} pages, expected exactly 1")

    if (
        abs(pdf.width_pt - A4_WIDTH_PT) > PAGE_SIZE_TOLERANCE_PT
        or abs(pdf.height_pt - A4_HEIGHT_PT) > PAGE_SIZE_TOLERANCE_PT
    ):
        found.append(
            f"page is {pdf.width_pt:.1f}x{pdf.height_pt:.1f}pt, expected A4 "
            f"({A4_WIDTH_PT}x{A4_HEIGHT_PT}pt +/- {PAGE_SIZE_TOLERANCE_PT}pt)"
        )

    # Only an *extra* face is a failure. A bundled face that does not appear
    # simply was not needed on this page, which is normal: the ATS build uses
    # no weight the timeline build does not.
    unexpected = pdf.fonts - ALLOWED_FONTS
    if unexpected:
        found.append(
            f"renders with unbundled {', '.join(sorted(unexpected))} -- "
            "a fallback family was reached"
        )

    # Two text checks, deliberately chained: text that is empty also falls
    # below the floor, and reporting both would say the same thing twice.
    if not pdf.text.strip():
        found.append("no selectable text -- an ATS would read an empty CV")
    elif len(pdf.text) < MIN_TEXT_CHARACTERS:
        found.append(
            f"only {len(pdf.text)} characters of text, expected at least "
            f"{MIN_TEXT_CHARACTERS} -- the page may have rendered partially"
        )

    return found


def main() -> None:
    paths = [Path(argument) for argument in sys.argv[1:]]
    if not paths:
        sys.exit("usage: check.py <pdf> [<pdf> ...]")

    failed = False
    for path in paths:
        if not path.is_file():
            print(f"FAIL {path}: missing -- run `make -C cv` first")
            failed = True
            continue
        pdf = read(path)
        found = problems(pdf) or []
        if found:
            failed = True
            print(f"FAIL {path.name}")
            for problem in found:
                print(f"       {problem}")
        else:
            print(
                f"ok   {path.name}: {pdf.pages} page, "
                f"{pdf.width_pt:.0f}x{pdf.height_pt:.0f}pt, "
                f"{len(pdf.text)} characters of text"
            )

    if failed:
        sys.exit(1)
    print(f"{len(paths)} PDFs match the design invariants")


if __name__ == "__main__":
    main()
