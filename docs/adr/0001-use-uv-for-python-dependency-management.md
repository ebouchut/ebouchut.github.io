# Use uv for Python dependency management

- Status: accepted
- Date: 2026-08-31
- Deciders: Eric Bouchut

## Context and Problem Statement

The blog is built with MkDocs and Material for MkDocs. Python dependencies were
managed with pip and pip-tools: direct dependencies declared in
`requirements.in` / `requirements-dev.in`, compiled to fully pinned
`requirements.txt` / `requirements-dev.txt` with `pip-compile`, and installed
into a hand-created `venv/`.  
CI ran `pip install -r requirements.txt`.

This multi-tool workflow had no single source of truth (the `.in` files, the
`.txt` files, and an implicit, unpinned Python version), needed manual virtual
environment creation and activation, gave slow and uncached installs in CI, and
left the Python version unpinned.

What should manage Python dependencies and the environment for this project?

## Decision Drivers

- Single source of truth for dependencies and the interpreter version
- Reproducible installs from a hashed lockfile
- **Fast**, cache-friendly CI
- **Minimal tooling** and setup steps for contributors

## Considered Options

- `uv`
- Keep `pip` + `pip-tools` (`pip-compile`)
- Poetry
- PDM

## Decision Outcome

Chosen: **uv**, because it covers dependency resolution, locking, the virtual
environment, and Python version provisioning in one fast tool, driven by the
standard `pyproject.toml`.

- `pyproject.toml` `[project.dependencies]` is the single source of truth for
  direct dependencies.
- `uv.lock` is the committed, hashed lockfile; it replaces `requirements.txt`
  and `requirements-dev.txt`.
- The repository is a non-package application: `[tool.uv]` sets
  `package = false` and there is no build backend.
- `.python-version` pins CPython 3.14; uv provisions it automatically.
- `uv sync` creates and manages `.venv/`; commands run through `uv run`.
- CI installs uv with `astral-sh/setup-uv`, runs `uv sync --locked`, then
  `uv run mkdocs gh-deploy --force`.
- uv is installed as a system tool, not declared as a project dependency.
- `requirements.in`, `requirements.txt`, `requirements-dev.in`, and
  `requirements-dev.txt` are removed.

### Consequences

- Good
  - One tool and one lockfile for a reproducible environment, set up with a
    single `uv sync`.
  - Faster, cache-friendly CI installs.
  - The Python version is pinned and provisioned automatically.
- Trade-off
  - Contributors must install uv (documented in `README.md`).
  - Dependabot's `pip` ecosystem no longer applies; the `uv` ecosystem must be
    enabled if automated dependency-update pull requests are still wanted.
  - `uv.lock` is uv-specific; any tool that needs a `requirements.txt` must
    obtain it with `uv export`.

## Pros and Cons of the Options

### uv

- Good
  - One tool handles resolution, locking, the virtualenv, and Python version
    provisioning.
  - Significantly faster than pip, with first-class CI caching via
    `astral-sh/setup-uv`.
  - Driven by the standard `pyproject.toml` and emits a hashed `uv.lock`.
- Bad
  - Comparatively young; its lockfile format is not yet a cross-tool standard.

### Keep pip + pip-tools

- Good
  - Already in place and widely understood.
- Bad
  - Needs several tools and manual venv steps, has no built-in Python version
    management, and gives slower, less cache-friendly CI.

### Poetry

- Good
  - Mature; manages both dependencies and the virtualenv.
- Bad
  - Slower than uv, historically diverged from `pyproject.toml` standards, and
    does not provision the Python interpreter.

### PDM

- Good
  - Standards-oriented (PEP 621).
- Bad
  - Smaller ecosystem, does not provision the interpreter, and would still be an
    extra tool to learn.
