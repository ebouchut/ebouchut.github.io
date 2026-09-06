# Use Zensical as the blogging engine

- Status: accepted
- Date: 2026-09-06
- Deciders: Eric Bouchut

## Context and Problem Statement

The blog is built with MkDocs and the Material for MkDocs theme (see
[ADR 0001](0001-use-uv-for-python-dependency-management.md) for the Python
toolchain). The Material maintainer has announced that **MkDocs 2.0 removes the
plugin system and rewrites the theming layer with no migration path** — every
`mkdocs build --strict` already prints that warning — and is building
**[Zensical](https://zensical.org)** as the successor engine from the same team.
See <https://squidfunk.github.io/mkdocs-material/blog/2026/02/18/mkdocs-2.0/>.

Staying on MkDocs + Material for MkDocs is therefore a dead end. What static site
generator should the blog use going forward?

## Decision Drivers

- Longevity — a tool that will still be maintained after MkDocs 2.0
- Keep the Material look, feel, and content conventions (blog, tags, admonitions,
  typeset, palette toggles)
- Reuse the existing `mkdocs.yml` and `docs/` tree with minimal churn
- Build speed
- Simple GitHub Pages deployment

## Considered Options

- Zensical
- Stay on MkDocs + Material for MkDocs
- Another static site generator (Hugo, Eleventy, Astro)

## Decision Outcome

Chosen: **Zensical**, because it is the Material team's designated MkDocs 2.0
successor, reads the existing `mkdocs.yml`, ships the Material `modern` /
`classic` themes, and preserves the blog, tags, and typeset conventions — so the
migration is essentially configuration, and it moves the blog onto an engine
that will still be maintained.

- `zensical` is the sole entry in `[dependency-groups] dev`; `pyproject.toml`
  `[project.dependencies]` is now empty. It is pinned `>=0.0.58, < 1`.
- Local workflow: `uv run zensical serve` (build and serve), `uv run zensical
  build` (build only).
- Theme configuration becomes `theme: variant: modern` with `lucide`
  palette-toggle icons.
- `md_in_html` is added to `markdown_extensions` for the `<div markdown>` layout
  blocks used on the CV page.
- Deployment stays on `.github/workflows/publish.yml` (push to `main` -> build
  -> publish to the `gh-pages` branch); `uv run mkdocs gh-deploy` is replaced by
  `uv run zensical build --strict` followed by `ghp-import` (with
  `--no-history`, so `gh-pages` is kept at a single throwaway commit).
- The ADRs move from `docs/adr/` to `adr/` at the repository root, so they sit
  outside the docs tree entirely rather than relying on `exclude_docs`.

### Consequences

- Good
  - The blog stays on a supported engine past MkDocs 2.0, from the same team,
    with the same visual identity.
  - Builds are sub-second for a site this size.
  - `mkdocs.yml` and `docs/` are reused; the migration is config-level.
- Trade-off
  - **Post URLs change** from `/YYYY/MM/DD/slug/` to `/blog/posts/<filename>/`;
    Zensical ignores the blog plugin's `post_url_format` /
    `post_url_date_format`. Existing inbound links and bookmarks break, with no
    redirect mechanism.
  - Zensical is pre-1.0 (`0.0.x`); its configuration and behaviour surface may
    still shift between releases.
  - Smaller ecosystem and documentation than MkDocs; some `pymdownx` and plugin
    behaviours differ or are unsupported and must be checked feature by feature.

## Pros and Cons of the Options

### Zensical

- Good
  - Same team as Material for MkDocs, and the designated MkDocs 2.0 successor.
  - Nearly drop-in: reads `mkdocs.yml`, ships the Material themes, keeps the
    blog, tags, and typeset conventions.
  - Very fast builds.
- Bad
  - Pre-1.0; an unstable configuration and feature surface.
  - Changes post URLs and has no built-in redirect story.
  - Younger, with a smaller ecosystem and thinner documentation.

### Stay on MkDocs + Material for MkDocs

- Good
  - Zero migration; everything already works.
  - Mature, with a large ecosystem and extensive `pymdownx` support.
- Bad
  - MkDocs 2.0 removes the plugin system and rewrites theming with no migration
    path, so Material for MkDocs on today's MkDocs is a dead end — the strict
    build already warns about it.

### Another static site generator (Hugo / Eleventy / Astro)

- Good
  - Mature, fast, well-documented, with large communities.
  - Full control over output, URLs, and redirects.
- Bad
  - A full rewrite: new templating, re-doing the theme and look, porting every
    `pymdownx` feature, and rebuilding blog, tags, and search.
  - Loses the Material visual identity the blog is built around.
