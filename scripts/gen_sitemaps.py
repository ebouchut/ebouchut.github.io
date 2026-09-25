#!/usr/bin/env python3
"""Rewrite the per-language sitemaps from the built site.

Zensical's `sitemap.xml` template iterates a page collection that the `blog`
plugin's generated pages never enter, so posts, archive pages and category
pages are missing from `site/<lang>/sitemap.xml` -- six entries out of sixteen
pages, at the time of writing. That matters twice over: search engines never
learn about any post, and the theme resolves every instant-preview target
against the sitemap, so a link to a post can never show a preview.

Every built page does carry its own `<link rel="canonical">`, so we read those
back and write the sitemaps ourselves. Working from the built output rather
than from Zensical's internals means this survives upgrades: it needs no
knowledge of collection names, template variables or pass order.

Delete this script once Zensical lists generated pages itself. The static
`root/sitemap.xml` index stays either way -- see the comment in that file.

Run it after both builds and after the root files are copied in:

    uv run zensical build --strict
    uv run zensical build -f mkdocs.fr.yml --strict
    cp -R root/. site/
    uv run python scripts/gen_sitemaps.py
"""

from __future__ import annotations

import html
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from xml.sax.saxutils import escape

LANGUAGES = ("en", "fr")
SITE = Path("site")
ROOT_INDEX = Path("root/sitemap.xml")

SITEMAP_NS = "http://www.sitemaps.org/schemas/sitemap/0.9"
LOC = f"{{{SITEMAP_NS}}}loc"

# The canonical URL is the one piece of self-knowledge every rendered page
# carries, whoever generated it.
CANONICAL = re.compile(
    r"""<link\s+rel=["']canonical["']\s+href=["']([^"']+)["']""",
    re.IGNORECASE,
)


def canonical_url(page: Path) -> str | None:
    """Return the page's canonical URL, or None when it declares none.

    A page without a canonical URL excludes itself from the sitemap, which is
    the behaviour we want: today that is exactly and only `404.html`, so there
    is no exclusion list to keep in sync.
    """
    match = CANONICAL.search(page.read_text(encoding="utf-8", errors="replace"))
    if not match:
        return None
    # The href sits in HTML, so `&` arrives as `&amp;`. Unescape it here and
    # re-escape for XML below; writing the raw href into XML is how upstream
    # broke sitemaps once already (zensical/zensical#772).
    return html.unescape(match.group(1))


def collect(lang: str) -> list[str]:
    """Collect the canonical URLs of every built page for one language."""
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
    return sorted(urls)


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


def write_sitemap(lang: str, urls: list[str]) -> None:
    """Write `site/<lang>/sitemap.xml`, replacing the one Zensical emitted.

    Same shape as Zensical's own template -- a bare `<urlset>` with one `<loc>`
    per page -- so the theme's parser and search engines find what they expect.
    """
    body = "\n".join(f"    <url><loc>{escape(url)}</loc></url>" for url in urls)
    (SITE / lang / "sitemap.xml").write_text(
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        f'<urlset xmlns="{SITEMAP_NS}">\n{body}\n</urlset>\n',
        encoding="utf-8",
    )


def check_root_index(expected: set[str]) -> None:
    """Fail unless the static index lists exactly the sitemaps we wrote.

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
        lines = [f"error: {ROOT_INDEX} does not match the sitemaps written"]
        lines += [f"  missing from the index: {url}" for url in missing]
        lines += [f"  listed but not written: {url}" for url in unknown]
        sys.exit("\n".join(lines))


def main() -> None:
    expected: set[str] = set()
    for lang in LANGUAGES:
        urls = collect(lang)
        write_sitemap(lang, urls)
        expected.add(f"{language_base(lang)}sitemap.xml")
        print(f"{lang}: {len(urls)} URLs")

    check_root_index(expected)
    print(f"{ROOT_INDEX} matches the {len(expected)} sitemaps written")


if __name__ == "__main__":
    main()
