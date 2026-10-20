[![publish status][publish-image]][publish-url]
[![Built with Zensical][zensical-image]][zensical-url]

[My blog](https://EricBouchut.com) uses [_Zensical_](https://zensical.org) — a static site generator built by the Material for MkDocs team — as its blogging platform. Content is written in Markdown.

The site is **bilingual**. It is built **twice**, from two disjoint source
trees, and served under a language prefix:

| Configuration   | Source     | Output     | URL   |
| --------------- | ---------- | ---------- | ----- |
| `mkdocs.yml`    | `docs/en/` | `site/en/` | `/en/` |
| `mkdocs.fr.yml` | `docs/fr/` | `site/fr/` | `/fr/` |

Neither build owns the site root, so anything that must live there is kept in
`root/` and copied over `site/` when publishing: the language-detecting landing
page, `CNAME`, `robots.txt`, the sitemap index, and the shared stylesheet.

This git repository's **`main`** branch contains the source of the blog. Publishing goes straight through GitHub Actions to GitHub Pages (see [Publish](#publish)); it no longer pushes to a `gh-pages` branch.

## Installation

Dependencies — including [Zensical](https://zensical.org) itself — are managed with [`uv`](https://docs.astral.sh/uv/).

```shell
# 1. Install `uv`  (See https://docs.astral.sh/uv/getting-started/installation/)

# 2. Clone the Project
   git clone git@github.com:ebouchut/ebouchut.github.io.git
   cd ebouchut.github.io

# 3. Install Python, create the virtual environment, and install dependencies
uv sync
```

Let's break down each of the above steps:

1. Install [`uv`](https://docs.astral.sh/uv/getting-started/installation/).
2. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this project.
3. Run **`uv sync`** that does the following tasks in a single swoop:
   - Reads `.python-version` and `pyproject.toml`,
   - Downloads the pinned _Python_ (declared in `.python-version`) if needed,
   - Creates `.venv/`, and installs the locked dependencies (including `zensical`) from `uv.lock`.

Run project commands with `uv run <command>` (no activation required), or
activate the environment yourself with `source .venv/bin/activate`.

## Repository layout

| Path       | Contents                                                        |
| ---------- | --------------------------------------------------------------- |
| `docs/en/` | English pages and posts, built by `mkdocs.yml`                   |
| `docs/fr/` | French pages and posts, built by `mkdocs.fr.yml`                 |
| `root/`    | Files that belong to the site root, copied over `site/`          |
| `includes/`| Shared Markdown snippets, appended to every page                 |
| `scripts/` | Build helpers                                                   |
| `cv/`      | Typst CV sources and the Makefile that builds the published PDFs |
| `adr/`     | Architecture Decision Records, kept out of the published site    |

`layouts/` and `img/` are leftovers from the Hugo era and are not part of the
build. `site/` is build output and is git-ignored.

## Run

### Preview

You can **preview** the blog **locally** as you edit the files.

- Run one of the commands below

  ```shell
  uv run zensical serve                      # English, from mkdocs.yml
  uv run zensical serve -f mkdocs.fr.yml     # French, from mkdocs.fr.yml
  ```

  This builds the website locally then runs a local web server listening on port `8000` .

  Each command previews **one language**, since each configuration has its own
  `docs_dir`. To see both at once, run them on different ports:

  ```shell
  uv run zensical serve -a 127.0.0.1:8000
  uv run zensical serve -f mkdocs.fr.yml -a 127.0.0.1:8080
  ```

  The language-detecting landing page lives in `root/` and belongs to neither
  build, so it is not part of the preview.

  ℹ️ **Keep this command running as you make changes to the blog** 
  because it will continuously watch for file changes, build the changed files, and ask the browser to reload the updated pages.

  However, if you change a configuration file (`mkdocs.yml` or `mkdocs.fr.yml`), you will need to restart the corresponding `uv run zensical serve`.

- **Open** this URL in your **web browser**: http://127.0.0.1:8000/

### Add a Blog Post

To create a new blog post:

- **Create** a new Markdown **file** under `docs/en/blog/posts` (or
  `docs/fr/blog/posts` for the French version) with this naming convention  
  `YYYY-MM-DD-post_title_here.md`, where:
  - `YYYY` denotes the year number in a four-digit format (for instance `2023`)
  - `MM` denotes the month number in a two-digit format within the `01` to `12` range (where `01` is January and `12` is December)
  - `DD` denotes the day of the month in two-digit format within the range `01` to `31`
  - `post_title_here` denotes the title of the blog post. Separate each word with an underscore (`_`)
  - `.md` is the Markdown file suffix

  The **file name does not decide the URL.** Posts are published at
  `/<lang>/blog/<yyyy>/<mm>/<dd>/<slug>/`, where the date comes from the `date:`
  front matter and the slug is derived from the post title. Pin the slug
  explicitly to keep it stable when the title is reworded, and to keep accented
  characters out of French URLs:

  ```yaml
  ---
  date: 2026-09-01
  slug: le-fonctionnement-interne-de-git-stash
  categories:
    - git
  ---
  ```

  **Link to a post by its `.md` source path**, as you would any other page:
  from `blog/cv/index.md`, write `(../posts/2021-07-22-git-stash-internals.md)`.
  The build rewrites it to the published URL and resolves each language to its
  own slug. That form is checked by `--strict`, so a renamed file is caught at
  build time, where a hand-written URL would not be.

  This needs Zensical 0.0.65 or later. Before that, a `.md` link passed
  validation and still rendered a dead `href`
  ([zensical/zensical#966](https://github.com/zensical/zensical/issues/966)).
- **Edit** the blog post (for instance `docs/blog/posts/2023-08-14-post_title_here.md`).  
  The blog is built with [Zensical](https://zensical.org), which reads the same `mkdocs.yml` and
  supports the Python-Markdown extensions configured there. Use the below documentation to learn
  more:
  - [Zensical documentation](https://zensical.org/docs/)
  - [Python Markdown](https://squidfunk.github.io/mkdocs-material/setup/extensions/python-markdown/)
  - [Python Markdown Extensions](https://squidfunk.github.io/mkdocs-material/setup/extensions/python-markdown-extensions/)
    Most of the extensions mentioned in the docs are already installed and configured in `mkdocs.yml`.
- Commit on a **branch**, push it, and open a **pull request**. Pushing to
  `main` publishes immediately, so changes go through a PR to keep the strict
  builds as a gate.

  ```shell
  git switch -c post/my-new-post
  git add docs/en/blog/posts/2026-09-01-my_new_post.md
  git commit -m "docs(blog): Add a post about ..."

  git push -u origin post/my-new-post
  gh pr create --base main
  ```

### Publish

Publishing is **fully automated**: anything that lands on `main` is built and deployed by [`publish.yml`](.github/workflows/publish.yml). There is no separate manual/CLI deploy step anymore.

In practice that means **merging a pull request**, which is what pushes to
`main`:

```shell
gh pr merge --merge
```

**IMPORTANT**: This requires [GitHub Pages to be enabled and configured](#configure-github-pages) (one-time) beforehand.

**When** is it triggered?

> Every push to the `main` branch.

**What** does it do?

> It checks out the repository and installs `uv` and the locked dependencies, then:
>
> 1. builds the English site with `uv run zensical build --strict`,
> 2. builds the French site with `uv run zensical build -f mkdocs.fr.yml --strict`,
> 3. copies `root/` over `site/`, which supplies everything that belongs to the
>    site root rather than to a language,
>
> then uploads `site/` as a **GitHub Pages artifact** and deploys that artifact
> directly — no `gh-pages` branch is pushed to or read from.
>
> Both builds run with `--strict`, so a broken internal link fails the
> deployment rather than shipping.

**How long** does it take?

> From under a minute to a few minutes.
> To monitor what is happening, take a look at the [GitHub Actions](https://github.com/ebouchut/ebouchut.github.io/actions) tab.

If you just want to build the site locally without deploying it — for instance to sanity-check before pushing:

```shell
uv run zensical build --strict                    # -> site/en/
uv run zensical build -f mkdocs.fr.yml --strict   # -> site/fr/
```

Each build writes its own subdirectory and leaves the other alone. To reproduce
exactly what gets published, add the step the workflow runs afterwards:

```shell
cp -R root/. site/
```

#### Configure GitHub Pages

**What** is GitHub Pages?

> **GitHub Pages** is a static site hosting service provided by GitHub that allows users to publish web pages directly from their GitHub repositories.
> It utilizes the repository content to automatically generate and serve web pages.  
> It is free of charge.

It is disabled by default and can be enabled per repository.

**How** does _GitHub Pages_ work with this project?

> [`publish.yml`](.github/workflows/publish.yml) builds the site and deploys it as a **Pages
> artifact** straight to GitHub Pages, so Pages must be told to accept deployments from GitHub
> Actions rather than from a branch.

Now, that you know what it is and how it works, let's **configure** and enable _GitHub Pages_:

1. Open your [blog repository](https://github.com/ebouchut/ebouchut.github.io) on GitHub  
   If you are using your own repo, the URL should rather look like so:
   `https://github.com/YOUR_GITHUB_USERNAME_HERE/YOUR_GITHUB_USERNAME_REPO_HERE.github.io`
2. Click the ⚙️ **`"Settings"`** tab (last one on the right)
3. Click **`Pages`** located under the `Code and Automation` section
4. In the **`Source`** field, select **`GitHub Actions`**
5. That's it — there is no branch or folder to pick. The next run of `publish.yml` publishes the site.

<!-- Github Badges: Images and URLs -->

[publish-image]: https://github.com/ebouchut/ebouchut.github.io/actions/workflows/publish.yml/badge.svg?branch=main
[publish-url]: https://github.com/ebouchut/ebouchut.github.io/actions/workflows/publish.yml
[zensical-image]: https://img.shields.io/badge/Built_with-Zensical-6E56CF?style=for-the-badge
[zensical-url]: https://zensical.org/
