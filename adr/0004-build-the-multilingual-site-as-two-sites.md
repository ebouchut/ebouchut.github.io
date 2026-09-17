# Build the multilingual site as two independent builds

- Status: accepted
- Date: 2026-09-15
- Deciders: Eric Bouchut

## Context and Problem Statement

The blog is published in English and French. Every page must exist in both
languages, each under its own URL prefix (`/en/`, `/fr/`), with a language
switcher in the header and a site root that sends visitors to the right one.

The usual answer in the MkDocs world is the `mkdocs-static-i18n` plugin. It is
not available here: Zensical does not load third-party MkDocs plugins. Its
configuration layer recognises a closed list implemented in Rust — `search`,
`tags`, `autorefs`, `mkdocstrings`, `markdown-exec` — and silently ignores
anything else. The `blog` plugin is not ported either, which is why posts
publish at `blog/posts/<filename>/` and `post_url_format` has no effect.

So: how do we publish two languages with a generator that has no i18n support?

## Decision Drivers

- Zensical cannot be extended with a plugin; whatever we do must use
  configuration keys it already supports.
- No page of one language may leak into the other's build.
- The site root (`CNAME`, `robots.txt`, the Google verification file) must stay
  at the root, outside both languages.
- One source of truth for shared assets — a stylesheet edited twice will drift.
- The local preview (`zensical serve`) has to stay usable.

## Considered Options

- Option A: two builds, two configuration files, two disjoint source trees
- Option B: one build, French pages under `docs/fr/` published as-is
- Option C: wait for, or contribute, i18n support in Zensical

## Decision Outcome

Chosen: **Option A**, because it is the only one that gives each language its own
`theme.language`, navigation and search index using keys Zensical already
supports (`docs_dir`, `site_dir`, `site_url`), with no plugin and no fork.

Concretely:

- `mkdocs.yml` builds `docs/en/` into `site/en/`
- `mkdocs.fr.yml` builds `docs/fr/` into `site/fr/`
- the two source trees are disjoint, so neither build can pick up the other's
  pages and no `exclude_docs` rule is load-bearing
- `root/` holds what belongs to the site root — the language-detecting landing
  page, `CNAME`, `robots.txt`, the Google verification file — and the publish
  workflow copies it into `site/` after both builds
- shared binaries (the stylesheet, the post images) exist once and are reached
  from each tree through **file** symlinks; directory symlinks are skipped by
  the tree walk and must not be used
- the landing page redirects on `navigator.languages`, English being the
  fallback

### Consequences

- Good
  - Each language gets correct `lang` attributes, interface strings and its own
    search index.
  - Neither build can contaminate the other, by construction rather than by a
    rule someone could delete.
  - Shared assets have a single source, so they cannot drift.
  - Publishing stays a single artifact upload: both languages land in `site/`.
- Trade-off
  - The two configuration files must be kept in sync by hand; there is no
    include mechanism in `mkdocs.yml`.
  - `zensical serve` previews one language at a time and ignores `root/`, so the
    landing page and the switcher only work against a full build.
  - Symlinks need `core.symlinks=true` plus Developer Mode on Windows,
    otherwise they clone as text files and the site silently loses its styling.
  - Adding a language means a third configuration file and a third tree.

## Pros and Cons of the Options

### Option A: two builds, two trees

- Good
  - Uses only supported configuration keys — no plugin, no fork.
  - Full per-language control: interface language, navigation labels, search.
  - Isolation is structural, not a rule that can be forgotten.
- Bad
  - Duplicated configuration to maintain in step.
  - Degraded local preview compared to a single build.

### Option B: one build, French pages published as-is

- Good
  - A single configuration file and a single build command.
  - The local preview covers the whole site at once.
- Bad
  - One `theme.language` for both languages: French pages keep English interface
    strings, dates and search placeholder.
  - A single navigation tree and a single search index mixing both languages.
  - `<html lang>` is wrong for half the site, which search engines read.

### Option C: wait for i18n support in Zensical

- Good
  - Would eventually give first-class support with no local machinery.
- Bad
  - No published timeline; the blog stays monolingual meanwhile.
  - Contributing it means learning the Rust configuration layer — out of
    proportion with publishing a personal blog in two languages.
