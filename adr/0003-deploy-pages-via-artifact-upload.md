# Deploy the site as a GitHub Pages artifact instead of pushing to `gh-pages`

- Status: accepted
- Date: 2026-09-09
- Deciders: Eric Bouchut

## Context and Problem Statement

The blog deploys to GitHub Pages. Until now the workflow builds the site and
pushes the output to the `gh-pages` branch — first with `mkdocs gh-deploy`, then
(see [ADR 0002](0002-use-zensical-as-the-blogging-engine.md)) with
`uv run zensical build` + `ghp-import`. GitHub Pages is set to "Deploy from a
branch".

GitHub also supports, and now recommends, deploying the built site as an
uploaded *artifact*: `actions/upload-pages-artifact` packs the output and
`actions/deploy-pages` hands it to the Pages service directly, with Pages set to
"GitHub Actions". Which model should the workflow use?

## Decision Drivers

- Keep generated HTML out of Git history
- Least-privilege CI token
- A real deployment record (history, URL, optional protection rules, rollback)
- Follow GitHub's actively maintained path

## Considered Options

- Push the build to the `gh-pages` branch (`zensical build` + `ghp-import --no-history`)
- Upload a Pages artifact (`upload-pages-artifact` + `deploy-pages`)

## Decision Outcome

Chosen: **the artifact model**, which revises the deployment approach recorded
in ADR 0002.

- `.github/workflows/publish.yml` gets two jobs: `build`
  (`uv run zensical build --strict`, then `upload-pages-artifact` with
  `path: site`) and `deploy` (`deploy-pages`, `needs: build`,
  `environment: github-pages`).
- `permissions` drops `contents: write` for `pages: write` + `id-token: write`;
  an OIDC token authenticates the deployment and the job can no longer write to
  the repository.
- `concurrency: { group: pages, cancel-in-progress: false }` serialises deploys.
- `ghp-import` and the CI git-identity step are removed.
- One-time repo change: Settings > Pages > Source = "GitHub Actions"; the
  `gh-pages` branch is then deleted.

### Consequences

- Good
  - No build output is committed anywhere; the repository stops accumulating
    rendered HTML.
  - The CI token cannot write to the repository (`contents: read`).
  - A real `github-pages` environment: deployment history, an exposed URL,
    optional required reviewers or wait timers, and rollback from the UI.
  - No more force-pushes to a branch.
- Trade-off
  - A one-time manual repo setting change (Pages "Source").
  - Requires `id-token: write`, which is unavailable to fork pull requests and
    can be disallowed by some organisation policies.
  - The rendered site is no longer archived on `gh-pages`; the Pages artifact
    has limited retention.
  - Two jobs instead of one.

## Pros and Cons of the Options

### Push to the `gh-pages` branch

- Good
  - Works with the repository's current Pages setting — no manual change.
  - `gh-pages` keeps a copy of the rendered site: an archive, and a place for a
    hand-managed `CNAME`.
- Bad
  - Needs `contents: write`; the job force-pushes a branch.
  - Stores generated HTML in the repository (mitigated, not removed, by
    `ghp-import --no-history`).
  - No deployment environment, history, or rollback.

### Upload a Pages artifact

- Good
  - Nothing generated lands in Git; a least-privilege token via OIDC; a real
    deployment environment and rollback; GitHub's recommended, maintained path.
- Bad
  - A one-time Pages "Source" change; depends on `id-token: write`; no permanent
    archive of the rendered output; a second job.
