# Bundled fonts

A Typst build only renders identically on every machine if it uses the same
font files, so the four faces the CV needs are committed here rather than
taken from the system. Every build passes `--ignore-system-fonts
--font-path fonts`, which makes this directory the *only* source of fonts, so
a missing face fails the build instead of silently falling back.

| File                         | Family          | Weight | Used for                     |
| ---------------------------- | --------------- | ------ | ---------------------------- |
| `Poppins-SemiBold.ttf`       | Poppins         | 600    | Name and section titles      |
| `Poppins-Regular.ttf`        | Poppins         | 400    | None today — see below       |
| `LiberationSans-Regular.ttf` | Liberation Sans | 400    | Body text                    |
| `LiberationSans-Bold.ttf`    | Liberation Sans | 700    | Job titles, emphasis         |

The requested weights exist as real faces, so nothing is synthesised: the
display font is only ever asked for at weight 600, and the body font at 400
and 700.

`Poppins-Regular.ttf` is unused as the design stands, because the sources
never ask for the display family below weight 600. It stays bundled so that
a future `weight: "regular"` on a title renders in Poppins instead of quietly
falling back to Liberation Sans.

The sources also list `Helvetica`, `Arial` and `DejaVu Sans` as fallbacks.
Those are deliberately absent, so every build reports
`warning: unknown font family: …` for them. The warnings are expected and
harmless — the real faces are found first, and dropping the fallback lists
would remove the safety net without changing any output.

## Provenance

- **Poppins** — [Google Fonts](https://github.com/google/fonts/tree/main/ofl/poppins),
  SIL Open Font License 1.1 (`OFL-Poppins.txt`).
- **Liberation Sans** — [liberation-fonts](https://github.com/liberationfonts/liberation-fonts)
  2.1.5, SIL Open Font License 1.1 (`OFL-LiberationSans.txt`).

The OFL requires the licence to travel with the font files, which is why both
licence texts are committed alongside them.
