---
date: 2021-07-14
slug: revenir-a-la-branche-precedente-avec-git-checkout
categories:
- git
tags:
- git
- changer
- branche
- historique
- naviguer
keywords:
- git
- changer
- branche
- historique
- naviguer
thumbnailImage: /images/git_checkout_dash.png
---

# Revenir à la branche précédente avec git checkout

Vous avez l'habitude d'utiliser `cd` dans le shell (*bash*, *zsh*) pour changer
de répertoire, puis `cd -` pour revenir à celui où vous étiez auparavant.

Bonne nouvelle : `git` propose un raccourci comparable pour changer de branche.

<!-- more -->
Ci-dessous, on passe d'abord de `folderA` à `folderB`, puis on revient à
`folderA` avec `cd -`.
```
cd folderA
cd folderB  

cd -   # => retour au répertoire précédent (folderA)
```

Dans le même esprit, on change de branche avec `git checkout nom-de-branche`, et
`git checkout -` ramène sur la branche où l'on se trouvait juste avant.
Voici un exemple :
```
git checkout master
git checkout branch-a
git checkout branch-b

git checkout -
```
On saute d'abord sur la branche `master`, puis sur `branch-a`, et enfin sur
`branch-b`.

![git checkout dash](../../images/git_checkout_dash.png)

Ensuite, **`git checkout -` ramène sur la branche précédente**, soit `branch-a`.  
Notez qu'ici `git checkout` est suivi d'un tiret (`-`) au lieu d'un nom de
branche. C'est une façon de revenir à la branche précédente sans avoir à
connaître son nom.

Le tableau ci-dessous donne le contenu de la pile de sauts après chaque commande
de l'exemple.

| Révision |             Description | git checkout master | git checkout branch-a | git checkout branch-b |
| ---      |                     --- | ---                 | ---                   | ---                   |
| @{0}     |        Branche courante | `master`            | `branch-a`            | `branch-b`            |
| @{-1}    |      Branche précédente |                     | `master`              | `branch-a`            |
| @{-2}    | Avant-dernière branche  |                     |                       | `master`              |

Chaque fois que vous sautez sur une nouvelle branche, les branches déjà
présentes dans la pile sont décalées vers le bas, et la branche d'arrivée est
empilée au sommet.

git propose des [révisions][git revisions], parmi lesquelles les raccourcis bien
pratiques `@{0}`, `@{-1}`, `@{-2}`… qui permettent de désigner les éléments de
cette pile.

`git checkout -` est un raccourci pour `git checkout @{-1}`, disponible depuis
la [version 1.6.2 de
git](https://github.com/git/git/blob/master/Documentation/RelNotes/1.6.2.txt#L85).

[git revisions]: https://mirrors.edge.kernel.org/pub/software/scm/git/docs/gitrevisions.html#_specifying_revisions
