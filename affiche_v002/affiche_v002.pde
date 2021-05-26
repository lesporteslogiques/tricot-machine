/*  affiche_001 (dérivé de tricotmachin_kemper_edn_003, dérivé de carhaix_pixels_005 )
 Affiches en tricot-machine pour le centre des Abeilles, 26 mai 2021
 Quimper, 25 mai 2021 / pierre@lesporteslogiques.net
 processing 3.5.4 @ kirin
 
 ** version **
 001 : adaptation : les affiches font 120 mailles de large sur 202 rangs
 002 : tentative pour régler le probleme "The pixels array is null"
   qui empêche d'afficher l'image enregistrée en grand...
   (qui fonctionnait très bien avec processing 3.4) -> OK, il faut initialiser les buffers, voir ci-dessous
 
 ** problèmes rencontrés **
 sun.java2d.SunGraphics2D cannot be cast to java.awt.Image : https://github.com/processing/processing/issues/4127
   -> utiliser get(x,y,w,h) plutot que 
 The pixels array is null. : https://forum.processing.org/one/topic/what-can-cause-the-pixel-array-of-a-pgraphics-to-be-null.html
   -> initialiser les buffers graphiques

 ** interaction **
 <-, -> déplacement de l'image
 mode pixel : bouton gauche (sur le dessin) : rendre le pixel noir
 mode pixel : bouton droit (sur le dessin) : rendre le pixel blanc
 autres modes : bouton gauche (sur le dessin) : dessiner le motif
 autres modes : bouton droit (sur le dessin) : changer de motif
 MAJ + 1, 2, 3 ... 8 : cadrer le fragment de l'image
 ALT + MAJ + 1, 2, 3 ... 8 : enregistrer le fragment + masquer
 pour les caractères possibles, voir la fonction chargerTexte() dans l'onglet utile
 J, L : changer de collection de motif
 I, K : changer de motif
 */

boolean DEBUG = true;

// Interface *******************************

import controlP5.*;
ControlP5 cp5;

boolean ctrlPressed  = false;
boolean altPressed   = false;
boolean shiftPressed = false;
PFont font;
PImage gauche, droite;              // image pour les déplacements gauche droite, 90x90 px


// Elements principaux *********************

String image_base = "./data/imagebase.png";
PImage original;                    // image/map de départ
PGraphics map;                      // image/map principale complète 
int map_w = 120;                    // largeur de l'image/map principale
int map_h = 202;                    // hauteur de l'image/map principale
int map_x = 100;                    // point d'accroche de l'affichage de l'image/map principale
int map_y = 485;
PGraphics map_masque;               // masque des fragments sauvés de l'image principale
PGraphics masque_portion;           // zone du masque à afficher en surimpression
PGraphics portion;                  // portion de l'image principale complète sur laquelle on zoome 
PGraphics portion_resized;          // image zoomée de la portion
PGraphics masque_resized; 
int position = 0;                   // position de le fenêtre portion sur l'image principale
boolean sur_le_dessin = false;      // la souris est elle sur la partie zoomée éditable ?
int portion_w = 120;                // largeur en pixel de la partie à agrandir / éditer
int portion_h = 202;                // hauteur en pixel de la partie à agrandir / éditer
int portion_x = 432;                // point d'accroche de l'affichage de la zone editable
int portion_y = 81;    
int coef_agrandissement = 3;        // nombre de pixels de la portion agrandie pour un pixel de l'iamge originale
//int fragments_nb = 8;             // nombre de morceaux à découper pour le tricot
int ox, oy;                         // coordonnées du pixel dans l'image d'origine 
int px, py;                         // coordonnées du pixel dans l'image portion
int motif_w, motif_h;               // dimensions du motif actuel, utilisé pour l'affichage du curseur


// Assets ***********************************

PImage[] lettres = new PImage[31];            // Utilisé pour le mode texte
PImage[] lettresX2 = new PImage[31];          // Utilisé pour le mode texte
Button[] boutons;                             // Tableau de bouton généré automatiquement
PVector boutons_orig = new PVector(100, 100); // Coordonnées de départ des boutons
Collection[] collec;                          // Chaque collection contient un répertoire thémtique d'images
String[] toutes_collections = { "persos", "motifs", "batiments", "gommes", "special"}; 
int index_motif = 0;                          // Utilisé pour parcourir les séries d'images (motif, perso, etc.)
int collec_en_cours;


// Logique ************************************

boolean quelquechose_change = true; // utilisé pour recalculer les images uniquement quand c'est nécessaire
String mode = "";
int compteur_clic = 0;              // pour enregistrer l'image de travail automatiquement



void setup() {
  size(1024, 768, P2D);
  noSmooth();

  // Interface
  font = createFont("arial", 12);
  textFont(font);
  cp5 = new ControlP5(this);

  // Créer les éléments graphiques principaux
  map = createGraphics(map_w, map_h, P2D);
  map_masque = createGraphics(map.width, map.height, P2D);
  masque_portion = createGraphics(portion_w, portion_h, P2D);
  masque_resized = createGraphics(portion_w * coef_agrandissement, portion_h * coef_agrandissement, P2D); 
  portion = createGraphics(portion_w, portion_h, P2D);
  portion_resized = createGraphics(portion_w * coef_agrandissement, portion_h * coef_agrandissement, P2D); 
  
  // Initialisation les buffers graphiques
  map.loadPixels();
  map_masque.loadPixels();
  masque_portion.loadPixels();
  masque_resized.loadPixels();
  portion.loadPixels();
  portion_resized.loadPixels();
  
  // Recréer l'image d'après la dernière sauvegarde 
  original = loadImage(image_base);
  map.beginDraw();
  map.background(255,255);
  map.image(original, 0, 0);
  map.endDraw();

  // Charger les assets texte
  chargerTexte();
  chargerTexteX2();
  
  // Créer les collections
  collec = new Collection[toutes_collections.length];
  for (int i = 0; i < toutes_collections.length; i++) {
    collec[i] = new Collection(toutes_collections[i], toutes_collections[i], coef_agrandissement);
  }
  switchCollection( 0 ); // Collection par défaut

  // Créer les boutons
  cp5 = new ControlP5(this);
  boutons = new Button[toutes_collections.length + 3];
  for (int i = 0; i < toutes_collections.length; i++) {
    float bx = boutons_orig.x;
    float by = boutons_orig.y + i * 30;
    boutons[i] = cp5.addButton(toutes_collections[i]).setPosition(bx, by).setSize(50, 20).setOff();
  }

  // Bouton pour le mode pixel
  float bx = boutons_orig.x;
  float by = boutons_orig.y + toutes_collections.length * 30;
  boutons[toutes_collections.length] = cp5.addButton("pixel")
    .setPosition(bx, by)
    .setSize(50, 20)
    .setOff() 
    ;

  // Bouton pour le mode texte
  bx = boutons_orig.x;
  by = boutons_orig.y + toutes_collections.length * 30 + 30;
  boutons[toutes_collections.length + 1] = cp5.addButton("texte")
    .setPosition(bx, by)
    .setSize(50, 20)
    .setOff() 
    ;
    
  // Bouton pour le mode texte X2
  bx = boutons_orig.x;
  by = boutons_orig.y + toutes_collections.length * 30 + 60;
  boutons[toutes_collections.length + 2] = cp5.addButton("texteX2")
    .setPosition(bx, by)
    .setSize(50, 20)
    .setOff() 
    ;

  // Autres éléments d'interface
  //gauche = loadImage("gauche.png");
  //droite = loadImage("droite.png");

  // Activer le mode pixel
  boutons[toutes_collections.length].setOn();
  boutons[toutes_collections.length].setColorBackground(color(255, 0, 0));
  mode = "pixel";
  updateBoutonVisible(mode);
}



void draw() {
  background(150, 50, 50);
  sur_le_dessin = false;

  // Affichage de l'image complète
  image(map, map_x, map_y);
  //image(map_masque, map_x, map_y);

  // Tracer deux rectangles pour indiquer la zone agrandie
  fill(255, 0, 0);
  noStroke();
  rect(position + map_x, map_y - 5, portion_w, 5);
  rect(position + map_x, map_y + portion_h, portion_w, 5);

  // Afficher la zone éditable
  image(portion_resized, portion_x, portion_y);
  //image(masque_resized, portion_x, portion_y);

  // boutons gauche / droite
  /*
  image(gauche, 100, 400);
  image(droite, 240, 400);
  */
  
  // Calculer la coordonnée dans l'image portion en fonction de la position de la souris
  px = int((mouseX - portion_x) / coef_agrandissement) * coef_agrandissement;
  py = int((mouseY - portion_y) / coef_agrandissement) * coef_agrandissement;

  // Calculer la coordonnée dans l'image d'origine en fonction de la position de la souris
  ox = int((mouseX - portion_x) / coef_agrandissement);
  oy = int((mouseY - portion_y) / coef_agrandissement);

  // Si la souris est sur la portion afficher le curseur adapté
  if (mouseX > portion_x - (int(motif_w/2) * coef_agrandissement)
    && mouseX < portion_x + portion_resized.width + (int(motif_w/2) * coef_agrandissement)
    && mouseY > portion_y - (int(motif_h/2) * coef_agrandissement)
    && mouseY < portion_y + portion_resized.height + (int(motif_h/2) * coef_agrandissement)) {
    sur_le_dessin = true;
    noCursor();
    modeDessin(mode);
  } else {
    cursor();
  }

  // Pour le mode pixels, la souris est captée dans draw() 
  if (mousePressed && sur_le_dessin && mode == "pixel") {
    map.beginDraw();
    if (mouseButton == LEFT)  map.set(ox + position, oy, color(0));
    if (mouseButton == RIGHT) map.set(ox + position, oy, color(255));
    map.endDraw();
    quelquechose_change = true;
  }

  if (quelquechose_change) {
    // Récupérer la partie à agrandir
    portion.beginDraw();
    portion.background(128, 255);
    portion.copy(map, position, 0, portion_w, portion_h, 0, 0, portion_w, portion_h);
    portion.endDraw();

    // Agrandir sans interpolation la zone éditable 
    portion_resized = resizeImg(portion, coef_agrandissement);
    compteur_clic ++;
  }

  // Sauver l'image de travail automatiquement
  if (compteur_clic > 3) { 
    map.save(image_base);
    compteur_clic = 0;
  }

  // Elements de texte
  fill(255);
  text("mode " + mode, 200, 100);
  text("definition : " + map_w + " x " + map_h, map_x, map_y + map_h + 60);

  quelquechose_change = false;
}
