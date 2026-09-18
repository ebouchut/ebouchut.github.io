# Architecture Decision Records (ADR)

This directory holds the **Architecture Decision Records** for this blog.

An _ADR_ is a short, dated document that captures one significant architectural or
design decision. Its context is the choice made, and its consequences.

ADRs are an **append-only, numbered log**: a decision is never silently rewritten; when a
choice changes, a new ADR _supersedes_ the old one, preserving the history of
_why_ things are the way they are.

These records live in version control but are kept out of the published site
via `exclude_docs: adr/` in `mkdocs.yml`.

## Format

All ADRs use the [**MADR**](https://adr.github.io/madr/) (Markdown Any Decision Records) short form.
Copy [`template.md`](template.md) when writing a new one.

## Naming convention

```
NNNN-short-title-in-kebab-case.md
```

- `NNNN` — 4-digit zero-padded, sequential (`0001`, `0002`, …). Never reused.
- Title — kebab-case, concise, topic-first.
- Files are never deleted; a superseded ADR stays and its **Status** is updated.

## Status values

`proposed` · `accepted` · `superseded by ADR-NNNN` · `deprecated`

## Index

| ADR                                                        | Title                                   | Status   |
| ---------------------------------------------------------- | --------------------------------------- | -------- |
| [0001](0001-use-uv-for-python-dependency-management.md)    | Use uv for Python dependency management | accepted |
| [0002](0002-use-zensical-as-the-blogging-engine.md)        | Use Zensical as the blogging engine     | accepted |
| [0003](0003-deploy-pages-via-artifact-upload.md)           | Deploy the site as a GitHub Pages artifact | accepted |
| [0004](0004-build-the-multilingual-site-as-two-sites.md)   | Build the multilingual site as two independent builds | accepted |
| [0005](0005-use-a-custom-lavender-palette.md)              | Use a custom lavender palette | accepted |
| [0006](0006-embed-videos-as-raw-iframes.md)                | Embed videos as raw iframes | accepted |
