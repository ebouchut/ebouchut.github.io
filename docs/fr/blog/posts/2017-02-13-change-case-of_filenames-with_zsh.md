---
date: 2017-02-13
slug: changer-la-casse-des-noms-de-fichiers-avec-zsh
categories:
  - shell
keywords:
  - zsh
  - fichier
  - nom de fichier
  - renommer
  - convertir
  - minuscules
  - majuscules
tags:
  - zsh
  - shell
  - fichier
  - nom de fichier
  - renommer
  - convertir
  - minuscules
  - majuscules
thumbnailImage: /images/change_case_filenames_ with_zsh.png
---

# Changer la casse des noms de fichiers avec Zsh

Aujourd'hui, après avoir importé des photos de mon iPhone vers mon Mac, j'ai
constaté que leurs noms étaient tout en majuscules, alors que je les veux en
minuscules. C'est une tâche que `zsh` règle facilement, en une seule ligne.
<!-- more -->

Les fichiers avant le renommage.
``` bash
IMG_4575.PNG
IMG_4576.PNG
IMG_4577.PNG
```

Cette ligne parcourt les fichiers dont le nom commence par `IMG` et se termine
par `.PNG`, et renomme chacun d'eux en minuscules.
``` shell
for file in IMG*.PNG ; do  mv $file ${file:l}  ; done
```
L'astuce tient dans `${file:l}` (avec un « l » comme *lowercase*), qui renvoie
le contenu de la variable `file` entièrement en minuscules.

Les fichiers ont bien été renommés en minuscules.
``` shell
img_4575.png
img_4576.png
img_4577.png
```

Si vous avez besoin de l'opération inverse, c'est-à-dire convertir les noms de
fichiers en **majuscules**, utilisez `${file:u}` à la place, comme ceci :


``` shell
for file in img*.png ; do  mv $file ${file:u}  ; done
```
