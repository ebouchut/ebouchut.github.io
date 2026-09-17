---
date: 2017-02-12
categories:
  - workflow
keywords:
  - favori
  - enregistrer un favori
  - étiquette
  - gestion des favoris
  - pinboard
  - pocket
  - workflow
tags:
  - favori
  - étiquette
  - gestion des favoris
  - workflow
  - pinboard
  - pocket
thumbnailImage: /images/my_bookmarking_workflow/overview.png
---

# Ma méthode de gestion des favoris

Voici comment je mets des liens de côté pour les lire quand j'ai le temps, et
comment je les classe par étiquettes pour les retrouver facilement ensuite.
<!-- more -->

<!-- toc -->

## Introduction

![vue d'ensemble de la méthode][overview]

Ma méthode de gestion des favoris est la suivante :

1. Collecter le lien (URL)
1. Trouver les étiquettes du lien
1. Étiqueter le lien
1. Rechercher
1. Lire
1. Écouter

Les outils que j'utilise, sur Mac comme sur iPhone, se résument à deux services
en ligne, *Pocket* et *Pinboard* :

* [Pocket][pocket] pour *collecter les liens* dans une liste « à lire plus tard »
* [Pinboard][pinboard] comme outil d'étiquetage.


## Collecter avec Pocket

Quand une page Web me paraît intéressante au premier coup d'œil, je l'ajoute à
[Pocket][pocket] sans prendre le temps de la lire en détail à ce stade. Ce peut
aussi être un lien reçu dans Gmail que je veux explorer plus tard. Le but est
d'envoyer les liens vers Pocket le plus vite possible. Même si Pocket permet de
les étiqueter dès cette étape, je ne le fais généralement pas, pour deux raisons.
D'abord parce que Pinboard ne sait malheureusement pas importer les étiquettes
depuis Pocket. Ensuite pour rendre cette première étape aussi rapide et fluide
que possible : elle se répète plusieurs fois par jour et ne doit surtout pas
devenir un frein. À ce stade, vous n'avez probablement ni l'envie ni la
possibilité de lire toutes les pages que vous comptez mettre en favori. L'une des
grandes forces de Pocket est justement d'accumuler des liens pour les lire plus
tard — d'où son nom d'origine, *readitlaterlist.com*. Utilisez-le ainsi et vous
vous en féliciterez. Ce que vous y déposez sera prêt à être lu, voire écouté, le
jour où vous le déciderez. Les deux atouts de Pocket sont, selon moi :
**collecter vite, lire de façon asynchrone**. Pocket (et Pinboard) permettent de
**dissocier la collecte d'une URL de la lecture de la page correspondante**.

**[Pocket][pocket]** est un service Web où vous stockez votre **liste à lire plus
tard**. J'utilise ses extensions pour navigateur de bureau et son application
mobile pour **enregistrer l'URL** des **pages** intéressantes que je veux
étiqueter, lire ou écouter plus tard, quand cela m'arrange. Pocket me permet en
outre de les consulter **hors ligne**.

* L'**extension pour navigateur de bureau** ajoute un bouton *Pocket* qui
  enregistre la page courante pour plus tard.
* L'**application mobile** iOS ajoute l'[extension de partage
  Pocket][pocket_saving_on_iphone], disponible ensuite dans toutes les
  applications depuis lesquelles on peut partager un lien vers Pocket.
* Par ailleurs, [de nombreuses applications mobiles][pocket_app_integrations]
  intègrent nativement « Enregistrer dans Pocket ». C'est le cas d'[Inoreader]
  [inoreader] par exemple, une application iOS que j'utilise pour lire mes flux
  RSS : quand je veux mettre de côté un billet intéressant, je le fais depuis
  Inoreader, sans même passer par l'*extension de partage Pocket*.

Pour les plus visuels d'entre vous, voici une présentation de *Pocket* par
*Steve Dotto*.

<div class="video-embed">
  <iframe src="https://www.youtube-nocookie.com/embed/zGeF5XaQ2tU"
          title="Pocket - App Review for Web Clipping Fun"
          loading="lazy"
          referrerpolicy="strict-origin-when-cross-origin"
          allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          allowfullscreen></iframe>
</div>


## Étiqueter avec Pinboard

J'ai configuré **[Pinboard][pinboard]** pour qu'il importe automatiquement les
nouveaux liens depuis *Pocket*, plusieurs fois par jour. Ainsi, chaque lien
enregistré dans Pocket se retrouve aussi dans Pinboard.

La deuxième étape de ma méthode se déroule dans Pinboard, où j'ouvre chaque lien
pour une lecture rapide (introduction, titres des sections principales, passages
en gras). Une fois que je saisis de quoi parle la page, je choisis puis j'applique
des **étiquettes** pour la classer. J'en profite pour supprimer les liens que
j'ai déjà lus dans Pocket ou que je ne souhaite pas archiver.


### Choisir ses étiquettes

Voici mes principes directeurs pour **choisir des étiquettes** :

* Utilisez les étiquettes qui vous viendraient **intuitivement** pour
    **rechercher** le lien que vous êtes en train d'étiqueter. Ce sont celles que
    vous emploierez réellement le jour où vous aurez oublié les étiquettes
    ultra-concises et parfaitement choisies qui vous avaient demandé tant de
    réflexion. Je ne dis pas qu'il est inutile de chercher la bonne étiquette —
    il faudra bien le faire au début — mais gardez en tête que le but d'une
    étiquette est de servir à retrouver un lien rapidement.

    **Règle empirique** : prendre le temps de déterminer **quelles étiquettes
    vous utiliseriez pour rechercher un lien** vous aidera énormément à trouver
    les bonnes. Certaines s'ancrent très facilement dans la mémoire, d'autres
    pas. Rappelez-vous que l'objectif final est de *retrouver*, pas de posséder
    les étiquettes les plus élégantes.
* Préférez le **singulier** au pluriel pour les noms.
* Écrivez tout en **minuscules** (plus simple et plus rapide à saisir).

    Selon votre service de favoris, la recherche peut être insensible à la casse,
    comme c'est le cas de *Pinboard*. Mais les services en ligne vont et
    viennent : vous devrez peut-être un jour migrer vers un autre qui n'offre pas
    cette souplesse. Je ne déroge à ce principe que pour les sigles, comme
    `HTML`, `HTTP` ou `JSON`.

* Employez les **verbes** au **présent** : par exemple `apprendre` plutôt
  qu'`apprentissage`.
* Utilisez **plusieurs mots** plutôt qu'un mot composé (même avec un tiret).
    Préférez `web` + `site` à `website` ou `web-site`, `moteur` + `recherche` à
    `moteurrecherche` ou `moteur-recherche`.
* Définissez un **noyau d'étiquettes** qui ait du sens pour vous, et tenez-vous-y.
    Par exemple `liste` quand un site ou une page contient une liste de *choses*,
    `multiple` plutôt que `plusieurs`, `recherche`, `trouver`, `vitesse`,
    `rapide`, `lent`.
* Étiquetez de façon **cohérente**.

    Ce dernier conseil aidera votre futur vous à retrouver un lien, en s'appuyant
    sur un noyau d'étiquettes bien connu. C'est pour cette raison qu'il faut
    expérimenter et ajuster sa classification au fil du temps, selon votre domaine
    et votre usage.

### Pinboard

**Pinboard** est un service de favoris en ligne payant. J'y suis passé parce que
*del.icio.us* a complètement changé de cap quand Yahoo l'a vendu à AVOS : il
s'est transformé en quelque chose qui n'était plus ni utile ni efficace pour moi.
Et il est devenu
[beaucoup trop lent](https://del.icio.us/url/1bb6ae4db9f129b3670c7ba1d1e85c5f).

Je peux étiqueter des liens aussi bien avec Pocket qu'avec Pinboard, mais je
trouve cela nettement plus simple avec Pinboard, conçu dans cet esprit dès le
départ et bien plus riche en fonctions d'étiquetage, comme le montre cette
**présentation** de Pinboard par Rhinofeed.

#### Présentation de Pinboard — partie 1

<div class="video-embed">
  <iframe src="https://www.youtube-nocookie.com/embed/mqphSmguiFY"
          title="Présentation de Pinboard - Partie 1"
          loading="lazy"
          referrerpolicy="strict-origin-when-cross-origin"
          allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          allowfullscreen></iframe>
</div>

#### Présentation de Pinboard — partie 2

<div class="video-embed">
  <iframe src="https://www.youtube-nocookie.com/embed/QFTjdEUrYCk"
          title="Présentation de Pinboard - Partie 2"
          loading="lazy"
          referrerpolicy="strict-origin-when-cross-origin"
          allow="accelerometer; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
          allowfullscreen></iframe>
</div>

En 2010, Leo Laporte et Amber MacArthur recevaient Maciej Ceglowski, le créateur
de Pinboard. L'[entretien est visible sur Youtube][pinboard_interview].


## Lire

J'ouvre ensuite les liens dans Pinboard, quand j'ai tout le temps nécessaire pour
lire les pages en entier, cette fois. C'est l'occasion d'affiner les étiquettes
existantes ou d'en ajouter de nouvelles.


## Écouter

Si je conserve **Pocket** comme intermédiaire entre Pinboard et moi, c'est pour
deux raisons.

D'abord parce que c'est une extension de navigateur, qui rend l'ajout d'un lien
immédiat. C'est **rapide**, à un clic. Pas de fenêtre qui met du temps à
s'afficher, pas de champs à remplir, pas de bouton de validation à presser —
contrairement à ce qui se passe quand j'enregistre une page avec le bookmarklet
de Pinboard.

Pocket possède aussi une fonction qui fait toute la différence : la [**synthèse
vocale**][pocket_tts]. Il sait **lire à voix haute** les pages enregistrées. Je
m'en sers souvent dans les transports pour me tenir au courant des actualités et
des articles techniques intéressants. Je choisis un article dans la *liste à lire
plus tard* de Pocket, un bouton, et c'est parti : j'apprends quelque chose qui me
passionne tout en travaillant ma compréhension de l'anglais, porté par une voix
anglaise très réaliste, **Alex**. Cela s'appuie sans doute sur la synthèse vocale
intégrée d'iOS, mais Pocket y ajoute sa touche : il **fait défiler** la page pour
surligner le mot en cours et le garder toujours visible.

C'est la seule chose qui m'empêche d'utiliser Pinboard exclusivement — une
fonction si pratique !


## Rechercher

Pinboard permet de rechercher des liens par étiquette, par titre, par description
ou par une combinaison des trois. La recherche est insensible à la casse et
reconnaît les mots partiels.


## Conclusion

J'espère que vous aurez trouvé dans cet article quelque chose à découvrir, que ce
soit un outil ou une manière de collecter et de traiter vos favoris susceptible
d'améliorer votre organisation.


[inoreader]: https://inoreader.com "Inoreader"
[overview]: ../../images/my_bookmarking_workflow/overview.png 
            "Vue d'ensemble de la méthode de gestion des favoris"
[pinboard]:  https://pinboard.in "Pinboard"
[pinboard_interview]: https://youtu.be/rQ6lW3WlA8s?t=30m30s
[pocket]:    https://getpocket.com "Pocket"
[pocket_app_integrations]: https://help.getpocket.com/category/858-category
                           "Applications mobiles intégrant nativement Pocket"
[pocket_iphone]: https://help.getpocket.com/category/842-category
                 "Pocket pour iPhone"
[pocket_saving_on_iphone]: https://help.getpocket.com/article/891-saving-to-pocket-on-iphone
                           "Enregistrer dans Pocket sur iPhone"
[pocket_tts]: https://help.getpocket.com/article/1081-listening-to-articles-in-pocket-with-text-to-speech
[pocket_web]: https://help.getpocket.com/category/847-category
