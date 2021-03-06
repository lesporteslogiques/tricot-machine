# Tricot-Machine

Applications et scripts utiles pour utiliser des machines à tricoter Brother Electroknit (KH940 principalement)

Voir aussi http://lesporteslogiques.net/wiki/outil/machine_a_tricoter_brother_kh940/start

## Tramage

Pour tricoter en deux couleurs. Ces applications permettent de modifier interactivement le tramage d'une image de départ, de modifier ses caractéristiques (contraste, luminosité, inversion), d'ajouter une  déformation en longueur et d'enregistrer au format PNG 1-bit (format lu par knittington). Différents algorithmes de tramage sont disponibles : Floyd-Steinberg, Bayer 2x2, Bayer 4x4, Bayer 8x8, Clustered 4x4, Random, Stucki, Jarvis-Judice-Ninke, Burkes, Sierra, Two row Sierra, Sierra lite, Atkinson, etc.

Application en deux versions : processing et p5.js, la version p5.js est utilisable en ligne : [tramage pour tricot-machine](http://lesporteslogiques.net/tricot-machine/tramage/)

Les deux versions sont fonctionnelles, mais la version en ligne est à privilégier car elle est un peu plus aboutie!

### Tramage version processing

![Tramage pour tricot-machine, version processing](./assets/tramage_processing_20200529.png)

### Tramage version p5.js

![Tramage pour tricot-machine, version p5.js](./assets/tramage_p5js_20200529.png)

## Motif

Application processing pour dessiner des motifs. En cours

![screenshot de la version 0.0.5](./assets/motif_v005_screenshot.png)

### motif_v005

Adaptation à des nouvelles contraintes :
* définition fixée à 1024 x 768
* damier porté à 64 x 64, avec 8 pixels par case

Le chemin absolu vers le dossier de sauvegarde des motifs est indiqué dans le fichier config.txt, dans le répertoire data de l'application.

## Collage / dessin

Applications pour dessiner des pièces tricotées à différents formats

### affiche_v002

En partant d'un modèle précédent et d'un type de laine pour avoir une pièce de 40x60cm, on prend une image d'origine de 120 mailles x 202 rangs. C'est toujours à adapter en fonction de la tension de la laine.

![screenshot affiche 0.0.2](./assets/affiche_v002_screenshot.png)
