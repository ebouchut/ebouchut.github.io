---
date: 2021-07-22
categories:
  - git
tags:
  - git
  - stash
  - fonctionnement interne
  - différence
  - modification
  - sauvegarde
keywords:
  - git
  - stash
  - fonctionnement interne
  - différence
  - sauvegarde
thumbnailImage: /images/git_stash/git-stash-internals-commit_parents.png
---

# Le fonctionnement interne de git stash

Comment `git stash` fonctionne-t-il en interne ?  
Comment consulter les fichiers non suivis contenus dans un stash ?
<!-- more -->

## Définition

Imaginons que vous vouliez **mettre de côté votre travail en cours non
commité** pour corriger un bogue urgent, ou passer temporairement sur une autre
branche avant de revenir à ce que vous faisiez. C'est là qu'intervient
`git stash` : il permet de mettre ce travail de côté puis de le restaurer plus
tard.

Dans l'exemple ci-dessous, mon **répertoire de travail est sale**, c'est-à-dire
qu'il contient des modifications non enregistrées.  
Changer de branche sans faire le ménage au préalable emporterait ces fichiers
modifiés sur l'autre branche.  
Pour l'éviter, j'utilise `git stash` avant de changer de branche, afin de repartir
d'une page blanche.

## Terminologie

Un petit rappel de **terminologie** peut être utile pour la suite de ce billet.
N'hésitez pas à passer directement à la suite et à y revenir au besoin.

- Un **fichier suivi** est un fichier sous gestion de version : git le connaît
  déjà parce que vous l'avez ajouté au dépôt avec `git add` puis `git commit`.
- Un **fichier non suivi** n'est pas encore sous gestion de version.
  Il n'est présent ni dans l'Index ni dans le dépôt.
  Autrement dit, vous n'avez pas fait `git add` puis `git commit` dessus.
- Les **fichiers ignorés** sont déclarés comme tels dans `.gitignore` ou
  `.git/info/exclude`. `git stash` les laisse de côté par défaut, sauf si vous
  employez l'option `-a`.
- **Répertoire de travail** : le répertoire où vous voyez et modifiez les
  fichiers, contenant la dernière version du projet extraite du dépôt.
- L'**Index**, aussi appelé *cache* ou *staging area*, est un emplacement de
  stockage temporaire, `.git/index`, où git conserve chaque fichier (en totalité
  ou en partie) prêt à être commité.
  Voyez-le comme un entrepôt où vous déposez, avec `git add`, une copie de chaque
  colis d'une expédition donnée dès qu'il est prêt.
  Une fois tous les colis nécessaires réunis dans l'entrepôt, on expédie le tout
  avec `git commit`.

## Exemple

Voici le script shell que j'ai utilisé pour créer le dépôt de cet exemple.
Il peut vous être utile pour pratiquer les options de `git stash` en partant d'un
terrain de jeu déjà configuré.

```shell
mkdir git-stash 
cd git-stash

git init
git commit --allow-empty -m "First commit"

echo "temp/" > .gitignore
git add .gitignore
git commit -m "Add gitignore"

echo "# CONTRIBUTING" > CONTRIBUTING.md
git add CONTRIBUTING.md
git commit -m "Add CONTRIBUTING"

echo "# README" > README.md
git add README.md
git commit -m "Add README"

# Staged file: CONTRIBUTING.md
echo "Here is how you can contribute [...]" >> CONTRIBUTING.md
git add CONTRIBUTING.md

# Modified tracked file: README.md
echo "## Installation" >> README.md

# Untracked file: LICENSE
echo "The MIT License (MIT) [...]" > LICENSE

# Ignored file: tmp/stash.out
mkdir temp
touch temp/stash.out
```

Examinons maintenant l'état du répertoire de travail et de l'Index après
exécution de ce script.

## Git Status

Voici la sortie de `git status` juste avant d'exécuter la moindre commande
`git stash`.

![git status](../../images/git_stash/git-stash-status.png "git status")

Ci-dessous, la version texte de l'image précédente.
```shell
git status

On branch master
Changes to be committed:
	(use "git restore --staged <file>..." to unstage)
				modified:   CONTRIBUTING.md

Changes not staged for commit:
	(use "git add <file>..." to update what will be committed)
	(use "git restore <file>..." to discard changes in working directory)
				modified:   README.md

Untracked files:
	(use "git add <file>..." to include in what will be committed)
				LICENSE
```

Il y a trois sections :
- **`Changes to be committed`** désigne le contenu de l'**Index**
  (`CONTRIBUTING.md`).
- **`Changes not staged for commit`** désigne les **fichiers suivis** qui sont
  **modifiés** dans le répertoire de travail (`README.md`).
- **`Untracked files`** désigne les fichiers que git ne connaît pas encore
  (`LICENSE`).


## La commande git stash

Cette section suppose que :
- chaque commande part du même état que celui décrit dans la section
  `Git Status` ;
- un seul stash a été créé, et nous le désignons par `stash@{0}`.

Le tableau ci-dessous indique quels fichiers sont mis de côté, et où (dans quel
commit), selon la commande `git stash` employée.

| Commande git stash | Fichier suivi modifié (rép. de travail) | Index             | Fichier non suivi | Ignoré            |
| :---               | ---                                     | ---               | :---:             | :---:             |
|                    | `README.md`                             | `CONTRIBUTING.md` | `LICENSE`         | `temp/stash.out`  |
| `git stash`        | ☑️   `stash@{0}`                         | ☑️   `stash@{0}^2` | ⤬                 | ⤬                 |
| `git stash -u`     | ☑️  `stash@{0}`                          | ☑️  `stash@{0}^2`  | ☑️  `stash@{0}^3`  | ⤬                 |
| `git stash -a`     | ☑️  `stash@{0}`                          | ☑️   `stash@{0}^2` | ☑️  `stash@{0}^3`  | ☑️   `stash@{0}^3` |


Voyons maintenant ce que fait chacune de ces commandes.

### git stash

Par défaut, `git stash` met de côté :
- tout fichier **suivi** qui est modifié et non ignoré : `README.md` ;
- l'**Index** : `CONTRIBUTING.md`.

Il ne met pas de côté les fichiers non suivis ou ignorés, comme respectivement
`LICENSE` et `temp/stash.out`.

```shell
git stash
```

```shell
git status

On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
	(use "git add <file>..." to include in what will be committed)

	LICENSE

nothing added to commit but untracked files present (use "git add" to track)
```

### git stash -u

Pour mettre également de côté les fichiers non suivis, utilisez l'option `-u`.

`git stash -u` met de côté :
- les **fichiers suivis et modifiés** : `README.md` ;
- l'**Index** : `CONTRIBUTING.md` ;
- les **fichiers non suivis** : `LICENSE`.

C'est-à-dire tous les fichiers, à l'exception de ceux qui sont ignorés.

```shell
git stash -u
```

```shell
git status

On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working directory clean
```

### git stash -a

Pour mettre aussi de côté les fichiers ignorés, utilisez l'option `-a` au lieu
de `-u`.

`git stash -a` met de côté **tous** les fichiers, à savoir :
- les **fichiers modifiés** que git suit : `README.md` ;
- l'**Index** : `CONTRIBUTING.md` ;
- les **fichiers non suivis** : `LICENSE` ;
- les **fichiers ignorés** : `temp/stash.out`.



## La pile de stashs

Lorsqu'il ajoute un stash, git crée un *commit de stash* et l'empile au sommet de
la pile de stashs. Les entrées déjà présentes, s'il y en a, sont décalées vers le
bas. La référence **`stash@{0}`** désigne toujours le **sommet de la pile**.
Chaque nouveau stash repousse les précédents vers le bas, d'où :
- `stash@{0}` désigne le stash le plus récent,
- `stash@{1}` désigne l'avant-dernier stash créé,
- `stash@{2}` désigne l'antépénultième, et ainsi de suite.

Maintenant que nous savons ce qui est mis de côté, voyons comment c'est stocké en
interne.

## Que contient un stash ?

Cherchons à savoir ce que contient notre stash le plus récent.  
Supposons que nous ayons exécuté `git stash -u` dans le dépôt de l'exemple : nous
obtenons alors ce journal.

![git stash - log](../../images/git_stash/git-stash-internals-graph_log.png)


Examinons à présent le commit stash@{0}.

```Shell
git log --format=raw -1 stash@{0}

commit 49482afa4ab999deada67c65dc5d38be89aed867
tree 936c8b08ac5a8e91bb6cc38387d2cca93167e0ae
parent 031ca106c13b1603675ea1ce8da8b3da852e27cd
parent b558b9e7621fe508c7c18713cd62c78e80e2017e
parent dfac0d769262fa4b8ea40003d24052c4509a7f3a
author Eric Bouchut <ebouchut@gmail.com> 1627056522 +0200
committer Eric Bouchut <ebouchut@gmail.com> 1627056522 +0200

    WIP on master: 031ca10 Add README
```

![git stash commit parents](../../images/git_stash/git-stash-internals-commit_parents.png)

Le **commit de stash `stash@{0}`** (`49482a`) est un **commit de fusion** à trois
parents dans ce cas, parce que nous avons mis de côté les fichiers non suivis
(deux parents par défaut).  
Il contient également les fichiers non ignorés du répertoire de travail qui
étaient modifiés au moment du stash.

Faisons connaissance avec les parents :
- **`stash@{0}^1`** (`031ca10`) désigne le **premier** parent du commit de stash.  
  C'était le commit courant (`HEAD`) au moment du stash.  
- **`stash@{0}^2`** (`b558b9e`) désigne le **deuxième** parent du commit de stash.  
  Il contient les modifications présentes dans l'**Index** au moment du stash.  
  L'_Index_ est aussi appelé _staging area_ : c'est là que sont stockés les
  fichiers ajoutés par `git add`, avant de pouvoir être commités.  
- **`stash@{0}^3`** (`dfac0d7`) désigne le **troisième** parent du commit de
  stash.  
  Il contient les **fichiers non suivis** (`-u`) et les **fichiers ignorés**
  (`-a`) présents dans l'arbre de travail au moment du stash.  
  `git stash` ne le crée que si vous employez l'option `-u` ou `-a`.

> Pourquoi faut-il entrer dans le détail du fonctionnement de `git stash` ?

Jusqu'à la version 2.32, git n'offrait aucun moyen simple de lister et d'afficher
les fichiers non suivis d'un commit de stash. D'où la nécessité de connaître son
fonctionnement interne pour y parvenir. Vous voilà armé pour la suite.

Listons maintenant le contenu du stash.

## Les fichiers d'un commit de stash

Voyons comment lister, en ligne de commande, les fichiers enregistrés dans un
stash :
- les fichiers modifiés du répertoire de travail,
- les « fichiers » de l'Index,
- les fichiers non suivis et ignorés.


### Fichiers modifiés du répertoire de travail d'un commit de stash

Voici comment **lister les fichiers modifiés du répertoire de travail** du commit
de stash le plus récent :

```shell
 git log -m --first-parent -1  --format='' --name-only 'stash@{0}'
```
Ici, on détaille le commit de fusion (`-m`) en se limitant au premier commit
(`-1`) du premier parent (`--first-parent`), c'est-à-dire le commit de stash
lui-même.

ℹ️  Par défaut, `git log` n'affiche aucun détail sur les parents d'un commit de
fusion, sauf si l'on emploie `-m` — et dans ce cas il affiche ce qui est demandé
pour chacun des parents. Comme ce n'est pas ce que nous voulons ici, nous nous
restreignons au premier parent.


Pour une raison qui m'échappe, même avec `--name-only`, `git log` affiche des
informations non demandées (SHA1 du commit, date et auteur) en plus des noms de
fichiers. J'ai constaté ce comportement avec git 2.32.0. C'est pourquoi
j'utilise `--format=''` comme contournement pour les supprimer.

Voici maintenant comment consulter **ce qui a changé dans les fichiers modifiés
du répertoire de travail** du commit de stash le plus récent :
```shell
git log -m --first-parent -1   -p 'stash@{0}'
```

### Fichiers de l'Index d'un commit de stash

La commande ci-dessous **liste** les **fichiers de l'Index** du commit de stash
le plus récent.
```shell
git log  --name-only -1 --format='' 'stash@{0}^2'
```

Pour obtenir le **contenu** des modifications présentes dans l'**Index** de ce
commit de stash :
```shell
git log  -1  -p 'stash@{0}^2'
```


### Fichiers non suivis d'un commit de stash

Voici comment **lister** les **fichiers non suivis** du commit de stash le plus
récent.

Depuis [git 2.32](https://github.com/git/git/blob/v2.32.0/Documentation/RelNotes/2.32.0.txt#L30),
`git show` dispose de l'option `--only-untracked` pour lister les fichiers non
suivis d'un stash.

ℹ️
Cela liste également les fichiers ignorés si vous avez utilisé `git stash -a`
pour les mettre de côté eux aussi.


```Shell
git stash show --only-untracked --name-only 'stash@{0}'
```

Avant git 2.32, il fallait recourir à l'une des deux alternatives suivantes :

```Shell
git show --name-only 'stash@{0}^3:'
```
Notez bien le deux-points (`:`) à la fin.

```Shell
git ls-tree -r 'stash@{0}^3' --name-only
```


Voici comment consulter le **contenu des fichiers non suivis** (et des fichiers
ignorés, le cas échéant) du commit de stash le plus récent.

Depuis [git 2.32](https://github.com/git/git/blob/v2.32.0/Documentation/RelNotes/2.32.0.txt#L30),
vous pouvez utiliser l'option `--only-untracked` de `git show`.

```Shell
git stash show --only-untracked -p 'stash@{0}'
```

Avant git 2.32, utilisez plutôt :

```Shell
git log -p 'stash@{0}^3'
```


[git-stash-show_untracked_files]: 
https://stackoverflow.com/questions/12681529/in-git-is-there-a-way-to-show-untracked-stashed-files-without-applying-the-stas
[git trees]: http://scottchacon.com/2011/07/11/reset.html
