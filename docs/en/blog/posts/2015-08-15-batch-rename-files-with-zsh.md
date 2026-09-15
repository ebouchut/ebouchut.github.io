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
zmv '(**/)(*).markdown' '$1$2.md'
```

where:

- `()` are used n the source part to capture what is inside the parenteses, for example when processing `contact/index.markdown`
- `(**/)` captures the path without the filename: `contact/` (in our example)
- `(*)` captures the filename without the suffix: `index`
- `$1` will be replaced by whatever was captured by the first pair of parentheses: `contact/`
- `$2` will be replaced by whatever was captured by second pair of parenteses: `index`

This means that when processing `contact/index.markdown`,  
_zmv_ will do something similar to `mv contact/index.markdown contact/index.md`.

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
    
    You can use the `-n` option to ask *zmv* to print what it would do without actually doing it.  
    This gives you an opportunity to check that everything is ok before running the command 
    to prevent you from doing a lot of back and forth only because of a typo in the command.
    
    ```shell
    zmv -n '(**/)(*).markdown' '$1$2.md'
    
    mv drafts/2012-05-06-learning-ruby-and-ruby-on-rails.markdown drafts/2012-05-06-learning-ruby-and-ruby-on-rails.md
    mv drafts/2015-07-19-welcome-to-jekyll.markdown               drafts/2015-07-19-welcome-to-jekyll.md
    mv posts/2012-02-10-baked-with-octopress.markdown             posts/2012-02-10-baked-with-octopress.md
    mv posts/2015-08-15-batch-rename-files-with-zsh.markdown      posts/2015-08-15-batch-rename-files-with-zsh.md
    mv posts/2015-08-15-octopress-3-0.markdown                    posts/2015-08-15-octopress-3-0.md
    mv about/index.markdown                                       about/index.md
    mv contact/index.markdown                                     contact/index.md
    ```
