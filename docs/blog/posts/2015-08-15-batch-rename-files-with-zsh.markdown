---
date: 2015-08-15
categories:
  - shell
tags:
  - zsh
  - rename
  - file
---

# Batch File Renaming With Zsh

I recently discovered `zmv`, a builtin feature of zsh that makes batch file renaming, a breeze.

<!-- more -->

To use it you need to add this to your zsh configuration file (`.zshrc`).

```shell
autoload zmv
```

My blog contains several Markdown files with a `.markdown` extension and I want to use `.md` instead.

```shell
ls **/*.markdown

./drafts/2012-05-06-learning-ruby-and-ruby-on-rails.markdown
./drafts/2015-07-19-welcome-to-jekyll.markdown
./posts/2012-02-10-baked-with-octopress.markdown
./posts/2015-08-15-batch-rename-files-with-zsh.markdown
./posts/2015-08-15-octopress-3-0.markdown
./about/index.markdown
./contact/index.markdown
```

Note I used the double star zsh notation to **recursively** list the files with the `.markdown` suffix.

- `**/` will match the current directory or (recursively) any directory below it.
- `*.markdown` will match any file with the `.markdown` suffix.

`ls **/*.markdown` is shorter than the alternative `find . -name '*.markdown'`.

Now, `zmv` comes in handy to **recursively** change the extension from `.markdown` to `.md`.

```shell
zmv '(**)(*).markdown' '$1$2.md'
```

where:

- `()` are used n the source part to capture what is inside the parenteses, for example when processing `contact/index.markdown`
- `(**)` captures the path without the filename: `contact/` (in our example)
- `(*)` captures the filename: `index`
- `$1` refers to what the first pair of parenteses captured: `contact/`
- `$2` refers to what the second pair of parenteses captured: `index`

This means that when processing `contact/index.markdown`,
_zmv_ will do something similar to
`mv contact/index.markdown contact/index.md` but faster.

Voilà, the files have been renamed!

```shell
ls **/*.md

./drafts/2012-05-06-learning-ruby-and-ruby-on-rails.md
./drafts/2015-07-19-welcome-to-jekyll.md
./posts/2012-02-10-baked-with-octopress.md
./posts/2015-08-15-batch-rename-files-with-zsh.md
./posts/2015-08-15-octopress-3-0.md
./about/index.md
./contact/index.md
```

!!! tip "Check your `zmv` command without actually running it"

```shell
zmv -n '(**)(*).markdown' '$1$2.md'

mv drafts/2012-05-06-learning-ruby-and-ruby-on-rails.markdown drafts/2012-05-06-learning-ruby-and-ruby-on-rails.md
mv drafts/2015-07-19-welcome-to-jekyll.markdown drafts/2015-07-19-welcome-to-jekyll.md
mv posts/2012-02-10-baked-with-octopress.markdown posts/2012-02-10-baked-with-octopress.md
mv posts/2015-08-15-batch-rename-files-with-zsh.markdown posts/2015-08-15-batch-rename-files-with-zsh.md
mv posts/2015-08-15-octopress-3-0.markdown posts/2015-08-15-octopress-3-0.md
mv about/index.markdown about/index.md
mv contact/index.markdown contact/index.md
```

I only scratched the surface of this feature.  
If you want to read more I recommend you [Seth Brown's post][source].

[source]: http://www.drbunsen.org/batch-file-renaming/
