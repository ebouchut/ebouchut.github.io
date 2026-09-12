[![publish status][publish-image]][publish-url]
[![Built with Zensical][zensical-image]][zensical-url]

[My blog](https://EricBouchut.com) uses [_Zensical_](https://zensical.org) — a static site generator built by the Material for MkDocs team — as its blogging platform. Content is written in Markdown.

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
   - Downloads the pinned _Python_ (declared in `python-version`) if needed,
   - Creates `.venv/`, and installs the locked dependencies (including `zensical`) from `uv.lock`.

Run project commands with `uv run <command>` (no activation required), or
activate the environment yourself with `source .venv/bin/activate`.

## Run

### Preview

You can **preview** the blog **locally** as you edit the files.

- Run the command below

  ```shell
  uv run zensical serve
  ```

  This builds the website locally then runs a local web server listening on port `8000` .

  If the default port (`8000`) is already used, you can use another one like `8080` for example:

  ```shell
  uv run zensical serve -a 127.0.0.1:8080
  ```

  ℹ️ **Keep this command running as you make changes to the blog** 
  because it will continuously watch for file changes, build the changed files, and ask the browser to reload the updated pages.

  However, if you change the configuration file (`mkdocs.yml`), you will need to restart `uv run zensical serve`.

- **Open** this URL in your **web browser**: http://127.0.0.1:8000/

### Add a Blog Post

To create a new blog post:

- **Create** a new Markdown **file** under `docs/blog/posts` with this naming convention  
  `YYYY-MM-DD-post_title_here.md`, where:
  - `YYYY` denotes the year number in a four-digit format (for instance `2023`)
  - `MM` denotes the month number in a two-digit format within the `01` to `12` range (where `01` is January and `12` is December)
  - `DD` denotes the day of the month in two-digit format within the range `01` to `31`
  - `post_title_here` denotes the title of the blog post. Separate each word with an underscore (`_`)
  - `.md` is the Markdown file suffix
- **Edit** the blog post (for instance `docs/blog/posts/2023-08-14-post_title_here.md`).  
  The blog is built with [Zensical](https://zensical.org), which reads the same `mkdocs.yml` and
  supports the Python-Markdown extensions configured there. Use the below documentation to learn
  more:
  - [Zensical documentation](https://zensical.org/docs/)
  - [Python Markdown](https://squidfunk.github.io/mkdocs-material/setup/extensions/python-markdown/)
  - [Python Markdown Extensions](https://squidfunk.github.io/mkdocs-material/setup/extensions/python-markdown-extensions/)
    Most of the extensions mentioned in the docs are already installed and configured in `mkdocs.yml`.
- Commit your changes on the `main` branch and push to your `origin` repository when you are done.

  ```shell
  git add docs/blog/post/2023-08-14-post_title_here.md
  git commit -m "Add a new blog post..."

  git push  # origin main
  ```

### Publish

Publishing is **fully automated**: push the `main` branch, and [`publish.yml`](.github/workflows/publish.yml) builds the blog and deploys it to GitHub Pages. There is no separate manual/CLI deploy step anymore.

**IMPORTANT**: This requires [GitHub Pages to be enabled and configured](#configure-github-pages) (one-time) beforehand.

```shell
git push origin main
```

**When** is it triggered?

> Every push to the `main` branch.

**What** does it do?

> It checks out the repository, installs `uv` and the locked dependencies, builds the site with
> `uv run zensical build --strict`, uploads the result as a **GitHub Pages artifact**, then deploys
> that artifact directly — no `gh-pages` branch is pushed to or read from.

**How long** does it take?

> From under a minute to a few minutes.
> To monitor what is happening, take a look at the [GitHub Actions](https://github.com/ebouchut/ebouchut.github.io/actions) tab.

If you just want to build the site locally without deploying it — for instance to sanity-check before pushing:

```shell
uv run zensical build --strict
```

The rendered site is written to `site/`.

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
