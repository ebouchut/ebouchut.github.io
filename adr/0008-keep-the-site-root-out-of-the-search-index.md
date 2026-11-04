# Keep the site root out of the search index

- Status: accepted
- Date: 2026-10-25
- Deciders: Eric Bouchut

## Context and Problem Statement

The site is built twice and served under `/en/` and `/fr/`. Neither build owns
the bare domain, so `root/index.html` sits there: a shim that reads
`navigator.languages` and calls `location.replace()` to send the visitor to one
of the two. It has no content of its own beyond two `<noscript>` links.

Which URL should search engines treat as the home page, and what should the
bare domain declare about itself? The page used to declare two things at once,
`noindex, follow` and a `rel=canonical` pointing at `/en/`, which are
contradictory instructions about the same URL.

## Decision Drivers

- GitHub Pages serves static files and lets us set no response headers, so
  neither a server-side 302 with `Accept-Language` negotiation nor an
  `X-Robots-Tag` is available.
- `/en/` is the page that must rank. It is already indexable and already
  listed in `site/en/sitemap.xml`.
- A `noindex` paired with a `rel=canonical` is contradictory: one asks for the
  URL to be dropped, the other for its signals to be merged into the target.
  Google does not define which wins, and the documented risk is the `noindex`
  being consolidated onto the target -- here `/en/`, which carries no
  `noindex` of its own.
- The shim redirects itself. Googlebot renders JavaScript, so it follows
  `location.replace()` much as it would a 302, whatever the meta tag says.

## Considered Options

- Option A: keep `noindex, follow`, remove the canonical
- Option B: make the bare domain indexable
- Option C: give the bare domain real content

## Decision Outcome

Chosen: "Option A", because it is the only option whose instruction matches
what the page actually does. The page exists to send visitors elsewhere, so
asking for it to be indexed contradicts its own behaviour. Removing the
canonical leaves one unambiguous signal and no path along which the `noindex`
can reach `/en/`.

### Consequences

- Good
  - `/en/` and `/fr/` are the indexed home pages with no further change: both
    are already indexable and already in their sitemaps.
  - Nothing can carry the `noindex` to another URL, because no canonical links
    the shim to one.
  - The invariant is structural rather than policed. The bare domain lives in
    `root/`, not under `site/en` or `site/fr`, so it cannot enter a
    per-language sitemap, and a sitemap index may hold no `<url>` at all.
- Trade-off
  - The bare domain never appears as a search result; Google shows
    `www.ericbouchut.com/en/` instead. No ranking strength is lost, only the
    tidier-looking URL.
  - A reader arriving at `/en/` from search gets English even if French suits
    them better. The language shim only runs at the bare domain.

## Related decision: the CV PDFs stay unadvertised

The generated PDFs under `root/cv/` are in no sitemap. The CV web pages
`/en/blog/cv/` and `/fr/blog/cv/` are, and they carry the CV for search. Two
reasons: a CV and its `-ATS` twin are near-duplicate content, and the `-ATS`
build is a flush-left variant meant for parsers rather than the document a
reader should land on. Nothing links the `-ATS` files, so they stay
undiscoverable without having to be blocked.

Search engines cannot be told about a sitemap change automatically any more:
Google retired its ping endpoint in June 2023 and Bing did the same.
Submission is a one-time manual action in Search Console, after which the
sitemap is re-crawled where it already sits. What is automated instead is
correctness -- `scripts/check_sitemaps.py` fails the deploy if a built page is
missing from its sitemap, which is the regression that shipped unnoticed
before Zensical 0.0.70.

## Pros and Cons of the Options

### Option A: keep `noindex, follow`, remove the canonical

- Good
  - One instruction, no contradiction, and no way for the `noindex` to
    propagate.
  - Honest about a page whose only content is two `<noscript>` links.
  - No sitemap change and no new file.
- Bad
  - The bare domain is absent from results.

### Option B: make the bare domain indexable

Drop the `noindex`, point the canonical at itself, aim `x-default` here, and
add the URL to a new sitemap at the root.

- Good
  - The bare domain can appear in results.
  - Matches Google's `x-default` guidance for language-selector pages.
- Bad
  - Fights the page's own `location.replace()`, which Googlebot follows, so
    Google may drop the URL in favour of `/en/` regardless -- the same outcome
    as Option A, reached less predictably.
  - A page whose only content is two links invites a soft-404 or
    thin-content classification.
  - Needs a third sitemap plus an extra entry in the index, since a sitemap
    index cannot hold a `<url>`.

### Option C: give the bare domain real content

Stop redirecting, and make the root a genuine bilingual landing page.

- Good
  - The only option under which the bare domain legitimately earns indexing:
    real text, both languages, a self-referential canonical, and `x-default`
    pointing here.
- Bad
  - A visible change to how every first-time visitor arrives, reopening a
    settled UX decision for an SEO reason.
  - Every visitor chooses a language by hand instead of being sent to one.
