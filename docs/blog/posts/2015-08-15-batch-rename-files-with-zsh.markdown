---
date: 2015-08-15
title: Batch File Renaming With Zsh
categories:
- shell
tags:
- zsh
- rename
- file
---

I recently discovered `zmv`, a builtin feature of zsh that makes batch file renaming, a breeze. 

<!--more-->

To use it you need to add this to your zsh configuration file (`.zshrc`).
{{< highlight shell >}}
autoload zmv
{{< / highlight >}}

My blog contains several Markdown files with a `.markdown` extension and I want to use `.md` instead. Here is what the markdown files looks like.
{{< highlight shell >}}
ls **/*.markdown  
    ./_drafts/2012-05-06-learning-ruby-and-ruby-on-rails.markdown
    ./_drafts/2015-07-19-welcome-to-jekyll.markdown
    ./_posts/2012-02-10-baked-with-octopress.markdown
    ./_posts/2015-08-15-batch-rename-files-with-zsh.markdown
    ./_posts/2015-08-15-octopress-3-0.markdown
    ./about/index.markdown
    ./contact/index.markdown
{{< / highlight >}}
Note I used the double star zsh notation to __recursively__ list the files which is shorter than  `find . -name '*.markdown'`.

This is where `zmv` comes in handy to **recursively** change the extension from `.markdown` to `.md`. Once more the double stars `**` match the current directory or whatever directory beneath it.
{{< highlight shell >}}
zmv '(**/)(*).markdown' '$1$2.md'
{{< / highlight >}}


Voilà, the files are renamed!
{{< highlight shell >}}
ls **/*.md
    ./_drafts/2012-05-06-learning-ruby-and-ruby-on-rails.md
    ./_drafts/2015-07-19-welcome-to-jekyll.md
    ./_posts/2012-02-10-baked-with-octopress.md
    ./_posts/2015-08-15-batch-rename-files-with-zsh.md
    ./_posts/2015-08-15-octopress-3-0.md
    ./about/index.md
    ./contact/index.md
{{< / highlight >}}

You can also use the `-n` option to ask `zmv` to print what it would do without actually doing it. This gives you an opportunity to check that everything is ok before running the command to prevent you from doing a lot of back and forth only because of a typo in the command ;-).

{{< highlight shell >}}
zmv  -n '(**/)(*).markdown' '$1$2.md'
    mv -- _drafts/2012-05-06-learning-ruby-and-ruby-on-rails.markdown _drafts/2012-05-06-learning-ruby-and-ruby-on-rails.md
    mv -- _drafts/2015-07-19-welcome-to-jekyll.markdown _drafts/2015-07-19-welcome-to-jekyll.md
    mv -- _posts/2012-02-10-baked-with-octopress.markdown _posts/2012-02-10-baked-with-octopress.md
    mv -- _posts/2015-08-15-batch-rename-files-with-zsh.markdown _posts/2015-08-15-batch-rename-files-with-zsh.md
    mv -- _posts/2015-08-15-octopress-3-0.markdown _posts/2015-08-15-octopress-3-0.md
    mv -- about/index.markdown about/index.md
    mv -- contact/index.markdown contact/index.md
{{< / highlight >}}

I only scratched the surface of this feature. 
If you want to read more I recommend you [Seth Brown's post][source].

[source]: http://www.drbunsen.org/batch-file-renaming/
