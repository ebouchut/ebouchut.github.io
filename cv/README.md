# CV

The CV as a print document, written in [Typst](https://typst.app) and served
as PDF from the site root.

It is separate from the CV *web* pages in `docs/en/blog/cv/` and
`docs/fr/blog/cv/`, which are Markdown built by Zensical. Why the CV is
generated this way is recorded in
[ADR-0007](../adr/0007-generate-the-cv-from-typst-sources.md).

## Layout

| Path                     | Contents                                      |
| ------------------------ | --------------------------------------------- |
| `cv-en.typ`, `cv-fr.typ` | One source per language                       |
| `fonts/`                 | The bundled faces — see [fonts/README.md](fonts/README.md) |
| `Makefile`               | The build targets below                       |

## What gets built

Each language has one source and two builds, chosen by a compile flag. All
four land in `root/cv/`.

| File                         | Build                    | Audience                        |
| ---------------------------- | ------------------------ | ------------------------------- |
| `CV-Bouchut-Eric-EN.pdf`     | default                  | The blog — with vertical timeline |
| `CV-Bouchut-Eric-EN-ATS.pdf` | `--input timeline=false` | Recruiters — flush-left, no timeline |

and the same pair for `FR`. The plain name carries the CV you would hand
someone; only the special case is labelled. Send the `-ATS` file wherever an
applicant-tracking system will parse it.

Keeping the switch inside one source means there is no duplicated content to
hold in sync between the two versions of a language.

## Build

Needs Typst 0.15.1 (`brew install typst`); CI pins the same version.

```shell
make -C cv          # all four PDFs
make -C cv fr       # French only
make -C cv en       # English only
make -C cv clean    # remove the generated PDFs
```

While editing, recompile on every save into a scratch file that is git-ignored
and never published:

```shell
make -C cv watch-fr
```

Every build passes `--ignore-system-fonts --font-path fonts`, so the bundled
faces are the only ones considered and the output does not depend on what the
machine happens to have installed. The `warning: unknown font family` lines
for Helvetica, Arial and DejaVu Sans are expected; see
[fonts/README.md](fonts/README.md).

## Publishing

The PDFs are committed. `root/` holds everything that belongs to neither
language build, and the publish workflow copies it over the built site with
`cp -R root/. site/`, so the files are served from:

```
https://www.ericbouchut.com/cv/CV-Bouchut-Eric-EN.pdf
```

No change to `publish.yml` is involved.

Rebuilding unchanged sources produces byte-identical PDFs, so `make -C cv`
leaves the working tree clean. After editing a `.typ`, rebuild and commit the
PDFs alongside the source, or the site keeps serving the previous version.

## CI

[`.github/workflows/cv.yml`](../.github/workflows/cv.yml) runs on demand, with
a language choice, and whenever anything under `cv/` changes.

It publishes nothing and holds no write access. It proves the sources still
compile on a clean machine that has none of the fonts installed, and uploads
the PDFs as a workflow artifact so one can be fetched without a local Typst
install.
