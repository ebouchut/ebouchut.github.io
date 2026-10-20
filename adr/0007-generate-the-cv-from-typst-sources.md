# Generate the CV from Typst sources

- Status: accepted
- Date: 2026-10-19
- Deciders: Eric Bouchut

## Context and Problem Statement

The CV already exists as Markdown pages in both languages, built by Zensical
with the rest of the site. A web page is not something you can attach to an
application: recruiters expect a PDF, applicant-tracking systems parse one,
and a page printed from a browser carries the site navigation and theme
instead of a print layout.

The CV therefore needs a second form — one A4 page per language, in two
variants: one with a vertical timeline for the blog, one stripped flush-left
for machine parsing. How should that PDF be produced, and where should the
generated file live so that the site can serve it?

## Decision Drivers

- The PDF must render identically wherever it is built, including on a CI
  runner that has no fonts of its own installed.
- One source of content per language: the timeline and ATS variants must not
  be able to drift apart.
- The site must serve the PDFs for download under a stable URL.
- `publish.yml` runs on `contents: read`, and the documented workflow routes
  every change to `main` through a pull request. Neither should be weakened.
- Each build must stay on exactly one A4 page.

## Considered Options

For producing the document:

- Typst sources compiled to PDF
- Printing the existing Markdown page from a browser

For the generated PDFs, given Typst:

- Option A: commit them to `root/cv/`
- Option B: generate them during the Pages deploy
- Option C: let a workflow commit them to `main`
- Option D: upload them as workflow artifacts only

## Decision Outcome

Chosen: **Typst sources, with the generated PDFs committed to `root/cv/`**
(Option A), because it is the only option that serves the PDFs from the site
without either weakening `publish.yml`'s least privilege or bypassing the
pull-request gate.

Printing from the browser was rejected outright: it gives no control over
pagination, and the output depends on the browser and its print settings.

Three supporting choices follow from the same drivers:

- **One source per language, two builds from a compile flag.** `cv-en.typ`
  and `cv-fr.typ` each build twice; `--input timeline=false` is the only
  intended difference between the two builds of a language. Two separate
  files would be two copies of the same career to keep in step.
- **Fonts bundled in the repository**, compiled with `--ignore-system-fonts`
  so that `cv/fonts/` is the only source of faces. Without it this laptop
  resolves the Helvetica and Arial fallbacks and a CI runner does not, so the
  two take different paths through the fallback list and agree only by luck.
  Both families are SIL OFL 1.1, which permits redistribution and requires
  the licence to travel with the files.
- **A fixed creation timestamp.** Committing generated binaries is only
  tolerable if rebuilding unchanged sources changes nothing, and Typst
  otherwise stamps each PDF with the build time. The source's own mtime looks
  like the obvious stamp but is not stable — a checkout, a rebase or a commit
  rewrites the working tree and moves it, and a fresh clone stamps everything
  with the clone time.

### Consequences

- Good
  - `root/` already holds what belongs to neither language build, and
    `cp -R root/. site/` publishes it, so serving the PDFs needs no change to
    `publish.yml` at all.
  - A single CV per language serves both sites, instead of the same binary
    committed once under `docs/en/` and again under `docs/fr/`.
  - The file sent to a recruiter is byte-for-byte the file the site serves.
  - CI needs no write access: it rebuilds as a guard and uploads artifacts.
- Trade-off
  - Binaries live in git history. Reproducible builds keep the diffs honest —
    a rebuild that changes nothing produces no diff — but the repository does
    grow by roughly 230 KB each time the CV genuinely changes.
  - The PDF metadata reports the fixed stamp date rather than the build date.
    The CV's real history is the git log.
  - A source edited without rebuilding leaves the site serving the previous
    PDF. Nothing detects that yet.
  - **Each build must stay on exactly one A4 page**, and nothing in the
    source enforces it: one line too many spills silently onto a second page
    and shows up in no diff. This is the constraint that justifies checking
    the built PDFs rather than trusting the sources.

## Pros and Cons of the Options

### Option A: commit the PDFs to `root/cv/`

- Good
  - Served by the existing root copy; no deploy change.
  - Publishing stays behind the pull-request gate.
  - The published bytes are reviewable and revertible like any other file.
- Bad
  - Generated output in version control.
  - Depends on contributors remembering to rebuild.

### Option B: generate during the Pages deploy

- Good
  - No binaries in git, and the output cannot go stale.
- Bad
  - Adds Typst and four compilations to every blog deployment, for a document
    that changes a few times a year.
  - What is published is never exactly what was reviewed.

### Option C: let a workflow commit to `main`

- Good
  - No manual rebuild step.
- Bad
  - Needs `contents: write` and a push straight to `main`, defeating both the
    least-privilege posture and the pull-request gate.

### Option D: artifacts only

- Good
  - Simplest, and no binaries anywhere.
- Bad
  - The site cannot link a CV for download, which was the point.
