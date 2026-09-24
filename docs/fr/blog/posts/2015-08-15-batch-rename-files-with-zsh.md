---
date: 2015-08-15
slug: renommer-des-fichiers-en-lot-avec-zsh
categories:
  - shell
tags:
  - zsh
  - renommer
  - fichier
---

# Renommer des fichiers en lot avec Zsh

J'ai découvert récemment `zmv`, une fonctionnalité intégrée à zsh qui rend le
renommage de fichiers en lot très simple.

<!-- more -->

Pour l'utiliser, il faut ajouter ceci à votre fichier de configuration zsh
(`.zshrc`).

```shell
autoload zmv
```

Mon blog contient plusieurs fichiers Markdown portant l'extension `.markdown`,
et je veux utiliser `.md` à la place.

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

Notez l'emploi de la double étoile de zsh pour lister **récursivement** les
fichiers ayant le suffixe `.markdown`.

- `**/` correspond au répertoire courant ou, récursivement, à n'importe quel
  répertoire situé en dessous.
- `*.markdown` correspond à tout fichier portant le suffixe `.markdown`.

`ls **/*.markdown` est plus court que l'alternative `find . -name '*.markdown'`.

`zmv` se révèle alors bien pratique pour changer **récursivement** l'extension
`.markdown` en `.md`.

```shell
zmv '(**/)(*).markdown' '$1$2.md'
```

où :

- les `()` servent, dans la partie source, à capturer ce qu'elles contiennent —
  par exemple lors du traitement de `contact/index.markdown`
- `(**/)` capture le chemin sans le nom de fichier : `contact/` (dans notre
  exemple)
- `(*)` capture le nom de fichier sans le suffixe : `index`
- `$1` sera remplacé par ce qu'a capturé la première paire de parenthèses :
  `contact/`
- `$2` sera remplacé par ce qu'a capturé la seconde paire de parenthèses :
  `index`

Autrement dit, lors du traitement de `contact/index.markdown`,  
_zmv_ fait l'équivalent de `mv contact/index.markdown contact/index.md`.

Voilà, les fichiers sont renommés !

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

!!! tip "Vérifier votre commande `zmv` sans l'exécuter"

    L'option `-n` demande à *zmv* d'afficher ce qu'il ferait, sans rien faire.  
    C'est l'occasion de vérifier que tout est correct avant de lancer la
    commande pour de bon, et de s'épargner de longs allers-retours à cause
    d'une simple faute de frappe.

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
