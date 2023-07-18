/* Truc pour l'atelier Tricot Machine à Carhaix
 Quimper, Dour Ru, 16 mai 2019 / pierre@lesporteslogiques.net / processing 3.4 @ kirin
 Révisé pour processing 4.0b2 / 18 juillet 2023 @ OAVL Orléans
 
 version 001 : défilement de la grande image, dessin pixel par pixel, motif simple
 version 002 : changement de dimensions, on passe à 1280x96 
 version 003 : mode texte + motifs chargés d'un répertoire : motif, perso, batiment, gomme
 version 004 : 
 * sauvegarde automatique, 
 * réduction de la tailel de fenêtre pour que cela tienne dans 1280x800,
 * enregistrement des fragments du tricot + masque
 * interface réduite au nécessaire
 
 interaction
 <-, -> déplacement de l'image
 mode pixel : bouton gauche (sur le dessin) : rendre le pixel noir
 mode pixel : bouton droit (sur le dessin) : rendre le pixel blanc
 autres modes : bouton gauche (sur le dessin) : dessiner le motif
 autres modes : bouton droit (sur le dessin) : changer de motif
 MAJ + 1, 2, 3 ... 8 : cadrer le fragment de l'image
 ALT + MAJ + 1, 2, 3 ... 8 : enregistrer le fragment + masquer
 pour les caractères possibles, voir la fonction chargerTexte() dans l'onglet utile
 */

boolean DEBUG = true;

// importer la lib. pour les éléments d'interface
import controlP5.*;
ControlP5 cp5;
Button[] boutons = new Button[6];

PFont font;

PImage original;                    // image de départ
PGraphics map;                      // image principale complète 
PGraphics map_masque;               // masque des fragments sauvés de l'image principale
PGraphics masque_portion;           // zone du masque à afficher en surimpression
PGraphics portion;                  // portion de l'image principale complète sur laquelle on zoome 
PGraphics portion_resized;          // image zoomée de la portion
PGraphics masque_resized; 
int position = 0;                   // position de le fenêtre portion sur l'image principale
boolean sur_le_dessin = false;      // la souris est elle sur la partie zoomée éditable ?
int portion_w = 160;                // largeur en pixel de la partie à agrandir / éditer
int portion_h = 96;                 // hauteur en pixel de la partie à agrandir / éditer
int portion_x = 240;                // coordonnée d'affichage de la zone editable
int portion_y = 128;    
int coef_agrandissement = 6;        // nombre de pixels de la portion agrandie pour un pixel de l'iamge originale
//int fragments_nb = 8;               // nombre de morceaux à découper pour le tricot


PImage[] lettres = new PImage[31];
boolean ctrlPressed  = false;
boolean altPressed   = false;
boolean shiftPressed = false;

int compteur_image = 0;             // Utilisé pour parcourir les séries d'images (motif, perso, etc.)
PImage[] motifs;                    // tableau des motifs à dessiner
PGraphics motif;                    // motif actuel

PImage[] persos;                    // tableau des persos
PGraphics perso;                    // perso actuel

PImage[] batiments;                 // tableau des batiments
PGraphics batiment;                 // batiment actuel

PImage[] gommes;                    // tableau des gommes
PGraphics gomme;                    // gomme actuelle

int motif_w, motif_h;               // dimensions du motif actuel, utilisé pour l'affichage du curseur

boolean quelquechose_change = true; // utilisé pour recalculer les images uniquement quand c'est nécessaire

String mode = "";

int ox, oy;                         // coordonnées du pixel dans l'image d'origine 
int px, py;                         // coordonnées du pixel dans l'image portion

String image_base = "data/imagebase.png";
int compteur_clic = 0;              // pour enregistrer l'image de travail automatiquement

PImage gauche, droite;              // image pour les déplacements gauche droite, 90x90 px

void setup() {
  size(1280, 740, P2D);

  font = createFont("arial", 12);
  textFont(font);

  cp5 = new ControlP5(this);
  initialiserInterface();

  noSmooth();
  map = createGraphics(1280, 96, P2D);
  map.loadPixels();
  map_masque = createGraphics(map.width, map.height, P2D);
  map_masque.loadPixels();
  masque_portion = createGraphics(portion_w, portion_h, P2D);
  masque_portion.loadPixels();
  masque_resized = createGraphics(portion_w * coef_agrandissement, portion_h * coef_agrandissement, P2D); 
  masque_resized.loadPixels();
  portion = createGraphics(portion_w, portion_h, P2D);
  portion.loadPixels();
  portion_resized = createGraphics(portion_w * coef_agrandissement, portion_h * coef_agrandissement, P2D); 
  portion_resized.loadPixels();
  original = loadImage("imagebase.png");
  //randomMap();
  map.beginDraw();
  map.image(original, 0, 0);
  map.endDraw();
  //motif = loadImage("mouette.png");
  chargerTexte();
  chargerMotifs();
  construireIconeMotif(compteur_image);
  chargerPersos();
  construireIconePerso(compteur_image);
  chargerBatiments();
  construireIconeBatiment(compteur_image);
  chargerGommes();
  construireIconeGomme(compteur_image);

  //activer le mode pixel
  boutons[1].setOn();
  boutons[1].setColorBackground(color(255, 0, 0));
  mode = "pixel";

  gauche = loadImage("gauche.png");
  droite = loadImage("droite.png");
}

void draw() {
  background(128);
  sur_le_dessin = false;

  // Affichage de l'image complète
  image(map, 0, 10);
  image(map_masque, 0, 10);

  // Tracer deux rectangles pour indiquer la zone agrandie
  fill(255, 0, 0);
  noStroke();
  rect(position, 5, portion_w, 5);
  rect(position, 106, portion_w, 5);

  // Afficher la zone éditable
  image(portion_resized, portion_x, portion_y);
  //image(masque_resized, portion_x, portion_y);
  
  // boutons gauche / droite
  image(gauche, 20, 400);
  image(droite, 120, 400);

  

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
    portion_resized = resizeImg(portion, 6);
    /*
    masque_portion.beginDraw();
    //masque_portion.background(128, 255);
    masque_portion.copy(map_masque, position, 0, portion_w, portion_h, 0, 0, portion_w, portion_h);
    masque_portion.endDraw();
    
    masque_resized = resizeImg(masque_portion, 6);
*/
    compteur_clic ++;
  }

  // Sauver l'image de travail automatiquement
  if (compteur_clic > 3) { 
    //sauverImage();
    map.save(image_base);
    compteur_clic = 0;
  }

  // Elements de texte
  fill(255);
  text("mode " + mode, 50, 150);

  



  quelquechose_change = false;
}

void modeDessin(String mode) {
  if (mode == "texte") {
    stroke(255, 0, 0);
    strokeWeight(3);
    line(px+portion_x, py+portion_y, px+portion_x+16, py+portion_y);
    line(px+portion_x, py+portion_y, px+portion_x, py+portion_y+16);
  }
  if (mode == "motif") {
    stroke(255, 0, 0);
    fill(255, 100);
    strokeWeight(3);
    rectMode(CENTER);
    rect(px + portion_x, py + portion_y, motif.width, motif.height);
    rectMode(CORNER);
    imageMode(CENTER);
    image(motif, px + portion_x, py + portion_y);
    imageMode(CORNER);
  }
  if (mode == "tuile") {
    stroke(255, 0, 0);
    fill(255, 100);
    strokeWeight(3);
    rect(px + portion_x, py + portion_y, coef_agrandissement*8, coef_agrandissement*8);
  }
  if (mode == "perso") {
    stroke(255, 0, 0);
    fill(255, 100);
    strokeWeight(3);
    rectMode(CENTER);
    rect(px + portion_x, py + portion_y, perso.width, perso.height);  
    rectMode(CORNER);
    imageMode(CENTER);
    image(perso, px + portion_x, py + portion_y);
    imageMode(CORNER);
  }
  if (mode == "pixel") {
    fill(255, 0, 0);
    rect(px + portion_x, py + portion_y, coef_agrandissement, coef_agrandissement);
  }
  if (mode == "batiment") {
    fill(255, 0, 0, 100);
    strokeWeight(3);
    rectMode(CENTER);
    rect(px + portion_x, py + portion_y, batiment.width, batiment.height);  
    rectMode(CORNER);
    imageMode(CENTER);
    image(batiment, px + portion_x, py + portion_y);
    imageMode(CORNER);
  }
  if (mode == "joker") {
    fill(255, 0, 0);
    rect(px + portion_x, py + portion_y, coef_agrandissement, coef_agrandissement);
  }
  if (mode == "gomme") {
    fill(255, 0, 0, 100);
    stroke(255, 0, 0);
    strokeWeight(3);
    rectMode(CENTER);
    rect(px + portion_x, py + portion_y, gomme.width, gomme.height);  
    rectMode(CORNER);
    imageMode(CENTER);
    image(gomme, px + portion_x, py + portion_y);
    imageMode(CORNER);
  }
}
