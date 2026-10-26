#!/usr/bin/env python3
"""Check the built sitemaps against the pages actually built.

Zensical writes `site/<lang>/sitemap.xml` itself, and since 0.0.70 it lists
every published page, the ones the `blog` plugin generates included. Nothing
proves it still does. Before that release those pages were silently absent --
six entries out of sixteen -- and the only symptom was that search engines
never learned about a single post. This script is the regression guard.

It writes nothing. For each language it compares two sets:

  * the URLs that `site/<lang>/sitemap.xml` advertises;
  * the canonical URL of every built HTML page.

Every rendered page carries its own `<link rel="canonical">`, whoever
generated it, so the second set needs no knowledge of Zensical's collection
names, template variables or pass order, and survives upgrades. A page that
declares no canonical excludes itself from both sides of the comparison, which
is the behaviour we want: today that is exactly and only `404.html`, in both
languages, so there is no exclusion list to keep in sync.

It also checks that the hand-maintained `root/sitemap.xml` index lists exactly
the sitemaps that were built, so adding a language without updating that file
fails the build instead of shipping an index that silently omits part of the
site.

The site root itself needs no check here, by construction. It lives in `root/`
rather than under `site/en` or `site/fr`, so it can never enter a per-language
sitemap; and a sitemap index may contain only <sitemap> elements, never <url>.
Its `noindex` therefore cannot end up contradicting a sitemap entry, which
would otherwise be reported in Search Console as a submitted URL marked
noindex.

Run it after both builds and after the root files are copied in:

    uv run zensical build --strict
    uv run zensical build -f mkdocs.fr.yml --strict
    cp -R root/. site/
    uv run python scripts/check_sitemaps.py
"""

from __future__ import annotations

import html
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path

LANGUAGES = ("en", "fr")
SITE = Path("site")
ROOT_INDEX = Path("root/sitemap.xml")

# A full regression would otherwise dump every URL of the site into the CI log.
MAX_URLS_REPORTED = 10

SITEMAP_NS = "http://www.sitemaps.org/schemas/sitemap/0.9"
LOC = f"{{{SITEMAP_NS}}}loc"

# The canonical URL is the one piece of self-knowledge every rendered page
# carries, whoever generated it.
CANONICAL = re.compile(
    r"""<link\s+rel=["']canonical["']\s+href=["']([^"']+)["']""",
    re.IGNORECASE,
)


def canonical_url(page: Path) -> str | None:
    """Return the page's canonical URL, or None when it declares none."""
    match = CANONICAL.search(page.read_text(encoding="utf-8", errors="replace"))
    if not match:
        return None
    # The href sits in HTML, so `&` arrives as `&amp;`. The sitemap stores it
    # unescaped, so unescape here to compare like with like.
    return html.unescape(match.group(1))


def built(lang: str) -> set[str]:
    """The canonical URL of every built page for one language."""
    root = SITE / lang
    if not root.is_dir():
        sys.exit(f"error: {root} is missing -- run the build for '{lang}' first")

    urls = {
        url
        for page in root.rglob("*.html")
        if (url := canonical_url(page)) is not None
    }
    if not urls:
        sys.exit(f"error: no page under {root} declares a canonical URL")
    return urls


def advertised(lang: str) -> set[str]:
    """The URLs that one language's sitemap lists."""
    sitemap = SITE / lang / "sitemap.xml"
    if not sitemap.is_file():
        sys.exit(f"error: {sitemap} is missing -- did the build for '{lang}' run?")
    try:
        root = ET.parse(sitemap).getroot()
    except ET.ParseError as error:
        sys.exit(f"error: {sitemap} is not well-formed XML: {error}")

    urls = {element.text.strip() for element in root.iter(LOC) if element.text}
    if not urls:
        sys.exit(f"error: {sitemap} lists no URL at all")
    return urls


def sample(urls: set[str]) -> str:
    """Render a set of URLs as one indented line each, capped and sorted.

    One per line because these are long URLs: comma-joining ten of them makes
    a 700-character log line that cannot be read or copied. Sorted so the same
    failure reads identically on every run, which is what makes two CI logs
    comparable.
    """
    shown = sorted(urls)[:MAX_URLS_REPORTED]
    hidden = len(urls) - len(shown)
    lines = [f"  {url}" for url in shown]
    if hidden:
        lines.append(f"  ... and {hidden} more")
    return "\n".join(lines)


def problems(listed: set[str], pages: set[str]) -> list[str]:
    """Return one message per disagreement, empty when the two sets match.

    `listed` is what the sitemap advertises, `pages` what the build produced.
    Every message names the URLs at fault: a count alone would say the sitemap
    is wrong without saying where to look.
    """
    found: list[str] = []

    # The pre-0.0.70 regression. An absent page is still served, so nothing
    # breaks visibly -- it simply never gets discovered, which is why only a
    # build-time check catches it.
    unlisted = pages - listed
    if unlisted:
        found.append(
            f"absent from the sitemap ({len(unlisted)} of {len(pages)} built "
            f"pages):\n{sample(unlisted)}"
        )

    # The opposite direction, deliberately not chained to the one above: a
    # renamed page trips both at once, and seeing both is what distinguishes a
    # rename from a page that was simply lost.
    unbuilt = listed - pages
    if unbuilt:
        found.append(
            f"listed in the sitemap but never built ({len(unbuilt)}) -- "
            f"crawlers would be sent to a 404:\n{sample(unbuilt)}"
        )

    return found


def language_base(lang: str) -> str:
    """Return the site URL of one language, from its home page.

    Taken from the page rather than assumed, so a deeper `site_url` base path
    keeps working.
    """
    home = SITE / lang / "index.html"
    if not home.is_file():
        sys.exit(f"error: {home} is missing -- run the build for '{lang}' first")
    base = canonical_url(home)
    if base is None:
        sys.exit(f"error: {home} declares no canonical URL")
    return base if base.endswith("/") else base + "/"


def check_root_index(expected: set[str]) -> None:
    """Fail unless the static index lists exactly the sitemaps that were built.

    This is what keeps a hand-maintained file honest: add a language and forget
    `root/sitemap.xml`, and the build stops instead of shipping a site whose
    index silently omits part of it.
    """
    if not ROOT_INDEX.is_file():
        sys.exit(f"error: {ROOT_INDEX} is missing")
    try:
        listed = {
            element.text.strip()
            for element in ET.parse(ROOT_INDEX).getroot().iter(LOC)
            if element.text
        }
    except ET.ParseError as error:
        sys.exit(f"error: {ROOT_INDEX} is not well-formed XML: {error}")

    if listed != expected:
        missing = sorted(expected - listed)
        unknown = sorted(listed - expected)
        lines = [f"error: {ROOT_INDEX} does not match the sitemaps built"]
        lines += [f"  missing from the index: {url}" for url in missing]
        lines += [f"  listed but not built:   {url}" for url in unknown]
        sys.exit("\n".join(lines))


def main() -> None:
    failed = False
    expected: set[str] = set()

    for lang in LANGUAGES:
        listed, pages = advertised(lang), built(lang)
        found = problems(listed, pages)
        if found:
            failed = True
            print(f"FAIL {lang}")
            # Indent every line: a problem may carry a URL list beneath it.
            for problem in found:
                for line in problem.split("\n"):
                    print(f"       {line}")
        else:
            print(f"ok   {lang}: {len(listed)} URLs, matching the pages built")
        expected.add(f"{language_base(lang)}sitemap.xml")

    if failed:
        sys.exit(1)

    # Only reached when every sitemap is sound, so a failure here is about the
    # index alone and cannot be confused with a missing page.
    check_root_index(expected)
    print(f"{ROOT_INDEX} lists the {len(expected)} sitemaps built")


if __name__ == "__main__":
    main()
