# Use a custom lavender palette

- Status: accepted
- Date: 2026-09-17
- Deciders: Eric Bouchut

## Context and Problem Statement

The theme accepts `primary` and `accent` only from a closed list of named
colours. Lavender is not one of them, and the stock palettes give the blog the
same look as every other site built on this theme.

The dark scheme adds a second constraint: its surfaces are not fixed colours but
derived from a hue variable, so tinting the accent without tinting the surfaces
leaves the two out of step.

How do we give the blog a distinct lavender identity, in both schemes, without
maintaining a fork of the theme?

## Decision Drivers

- A recognisable identity rather than a stock theme colour.
- WCAG AA contrast for body links and interface elements, in both schemes.
- A single source of truth, since the stylesheet is shared by the English and
  French builds.
- The smallest possible surface: restyle the accent, not the whole theme.

## Considered Options

- Option A: pick the closest stock named colour
- Option B: `primary: custom` / `accent: custom` plus CSS custom properties
- Option C: fork the theme or ship a full replacement stylesheet

## Decision Outcome

Chosen: **Option B**. `mkdocs.yml` and `mkdocs.fr.yml` declare
`primary: custom` / `accent: custom`, and `root/css/extra.css` redefines the
handful of custom properties the theme reads, scoped per scheme.

The values, and the reasons that are not readable from the stylesheet itself:

- Light primary `#6E56CF`, dark primary `#C4B5FD`. Measured at roughly 5.4:1 for
  links on the light background — above the 4.5:1 AA threshold for body text.
- Light background `#FAFAFA`, a **neutral** grey. An earlier attempt used a warm
  off-white (`#faf9f6`), which sat directly under the header's cool lavender
  wash and produced a visible seam at the divider. A neutral grey has no
  undertone to clash with anything layered above it, while still being softer to
  read than pure white.
- `--md-hue: 265` on the dark scheme. The theme derives its dark surfaces from
  this hue, whose default is around 210 (blue); moving it to 265 keeps the
  surfaces in the same violet family as the accent.
- `default` and `slate` are the theme's **only** valid scheme names. Each ships
  a full token set; any other value gets none, which renders the page unstyled.
  Renaming a scheme therefore breaks dark mode silently, with no build warning.
- Admonition colours are deliberately left untouched: their teal / blue / orange
  / red carry meaning (note, info, warning, danger) that a decorative palette
  should not override.

### Consequences

- Good
  - A distinct identity for the cost of about twenty lines of CSS.
  - One stylesheet serves both language builds, so the palette cannot drift
    between editions.
  - Both schemes were checked against the contrast thresholds rather than
    picked by eye.
- Trade-off
  - These custom properties are the theme's internal interface, not a
    documented API. An upgrade can rename or drop them, so the palette has to be
    re-checked after a Zensical upgrade.
  - Scheme-scoped rules must be written twice, once per scheme. A rule written
    unscoped leaks into the other scheme — which happened once with the header
    wash.

## Pros and Cons of the Options

### Option A: closest stock named colour

- Good
  - Zero custom CSS, nothing to maintain across upgrades.
  - Guaranteed to stay consistent with the theme's own contrast work.
- Bad
  - No stock colour is the intended lavender.
  - Leaves the blog looking like the theme's default.

### Option B: custom properties

- Good
  - Exactly the intended colours, in both schemes.
  - Small, readable surface; everything else is inherited.
  - Supported path, documented by the engine for this purpose.
- Bad
  - Depends on internal property names that can change.
  - Contrast becomes the author's responsibility.

### Option C: fork the theme

- Good
  - Total control over every visual decision.
- Bad
  - Every upstream release has to be merged by hand.
  - Wildly disproportionate for changing an accent colour.
