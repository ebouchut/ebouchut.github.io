# Embed videos as raw iframes served from `youtube-nocookie.com`

- Status: accepted
- Date: 2026-09-17
- Deciders: Eric Bouchut

## Context and Problem Statement

One post referenced three YouTube videos through Hugo shortcodes
(`{{< youtube ID >}}`), left over from the engine the blog used before. Zensical
does not interpret them, so they rendered as literal text — in both the
English and the French edition.

The obvious answer, a Markdown plugin that turns a video URL into a player, is
not available: Zensical loads no third-party MkDocs plugin. Its configuration
layer recognises a closed list implemented in Rust and silently ignores the
rest, which is the same wall already documented in ADR 0004 for the `blog`
plugin. There is no native video extension either.

How do we render a video player with an engine that offers no mechanism for it?

## Decision Drivers

- No engine extension is available, and none can be added.
- The markup has to work identically in both language trees.
- Visitor privacy: an embedded player is a third party watching the page load.
- Responsive: the player must keep its ratio on a phone.

## Considered Options

- Option A: a third-party Markdown plugin
- Option B: the `macros` extension Zensical ships
- Option C: a raw `<iframe>` written in the Markdown

## Decision Outcome

Chosen: **Option C**. Zensical does not sanitise HTML, so an `<iframe>` written
in a Markdown file reaches the built page untouched. It needs no dependency and
no configuration.

The player is served from `youtube-nocookie.com`, deferred with
`loading="lazy"`, and given a restricted `allow` list that omits `autoplay`.
A `.video-embed` wrapper in `root/css/extra.css` holds the ratio with
`aspect-ratio: 16 / 9`, which makes the old `padding-top` trick unnecessary.
In shape:

```html
<div class="video-embed">
  <iframe src="https://www.youtube-nocookie.com/embed/ID" ...></iframe>
</div>
```

The current markup lives in the posts and the stylesheet; it is not reproduced
here, because this log is append-only and a copy would become wrong at the first
adjustment without any way to correct it.

### Consequences

- Good
  - No dependency, no configuration, nothing to re-check on a Zensical upgrade.
  - The same markup works in both editions, and the shared stylesheet carries
    the ratio rule for both.
  - `loading="lazy"` means the request does not fire until the player nears the
    viewport.
- Trade-off
  - The markup is repeated at each call site, six times across the two
    editions.
  - `title` is written in the language of the page, since screen readers
    announce it — an intentional divergence between the two files.
  - `-nocookie` removes the tracking cookies but **not the request**: the IP
    address, user agent and referring page still reach the server. Tracked in
    the third-party request issue, along with the click-to-load facade that
    would remove it entirely.

## Pros and Cons of the Options

### Option A: a third-party Markdown plugin

- Good
  - One line per video, the usual answer in the MkDocs ecosystem.
- Bad
  - Cannot be loaded at all: Zensical ignores plugins it does not implement.
    The failure is silent, which is worse than an error.

### Option B: the `macros` extension

- Good
  - Shipped by Zensical, so no dependency to install.
  - Would reduce each call site to a single line.
- Bad
  - Applies Jinja to **every** Markdown file. Any double brace in a current or
    future post becomes template syntax and breaks the build.
  - A global risk taken on for three videos.

### Option C: a raw `<iframe>`

- Good
  - Works by construction, since nothing strips it.
  - Explicit: the attributes governing privacy and loading are visible at the
    call site rather than hidden in a macro.
- Bad
  - Verbose, and repeated per video.
  - HTML in the middle of Markdown is less pleasant to write.
