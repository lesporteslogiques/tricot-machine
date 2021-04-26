/* Répétition de motifs (pour l'atelier Tricot Machine à Carhaix)
 Quimper, Dour Ru, 6 juin 2019 / pierre@lesporteslogiques.net
 processing 3.4 @ kirin
 + lib. controlP5 2.2.6 : http://www.sojamo.de/libraries/controlP5/
 
 version 001 : décalage bugué!
 version 002 : décalage ok
 version 003 : chargements d'image avec CTRL + 0...9, effacement limité à la zone définie
 version 004 : transparence

 */

boolean DEBUG = true;

// importer la lib. pour les éléments d'interface
import controlP5.*;
ControlP5 cp5;
PFont font;

int elements_x = 80;         // nombre de colonnes composant le motif
int elements_y = 64;         // nombre de rangées composant le motif
int decalage_x = 0;          // décalage de la zone active du motif
int decalage_y = 0;
// Le tableau motif peut contenir 3 valeurs : 0 pour transparent, 1 pour blanc, 2 pour noir
int[][] motif = new int[elements_y][elements_x];       // [rangee][colonne]
PGraphics brouillon;                // la zone complète de travail
String brouillon_travail = "data/brouillon.png";


int motif_largeur, motif_hauteur;        // dimensions maximales du motif 
int motif_taille = 10;                   // taille du carré représentant un pixel dans l'éditeur de motif
int xs = 50;                             // coordonnée horizontale du début de l'affichage du motif
int ys = 100;                            // coordonnée verticale du début de l'affichage du motif

int repetition_echelle = 1;              // échelle d'agrandissement du motif répété
int decalage_repetition_x = 950;         // coordonnée horizontale du début de l'affichage du motif répété   

boolean quelquechose_change = true;      // utilisée pour mettre à jour l'image uniquement quand il y a modif
PGraphics motif_image_brut;              // image du motif qui peut être enregistrée à échelle 1
PGraphics motif_image;                   // image du motif qui peut être enregistrée    

String nom_fichier = "";                 // nom du fichier qui sera enregistré
String nom_fichier_brut = "";            // nom du fichier qui sera enregistré (pour l'échelle 1)
boolean fichier_enregistre = false;      // état des sauvegardes : motif enregistré
boolean fichier_enregistre_brut = false; // état des sauvegardes : motif échelle 1 enregistré
boolean brouillon_enregistre = false;    // état des sauvegardes : brouillon de travail enregistré

boolean ctrlPressed = false;
boolean altPressed  = false;

int compteur_clic = 0;              // pour enregistrer l'image de travail de temps en temps


void setup() {
  size(1400, 800, P2D);
  font = createFont("arial", 12);
  textFont(font);
  cp5 = new ControlP5(this);
  initialiserInterface();
  motif_image = createGraphics(motif_largeur, motif_hauteur, P2D);
  
  // L'appli s'ouvre dans l'état ou on l'a laissée
  brouillon = createGraphics(elements_y, elements_x, P2D);
  chargerImage("brouillon.png");
}

void draw() {
  background(150, 50, 50);

  // mettre à jour le nom de fichier *********************************************************************************************
  nom_fichier = cp5.get(Textfield.class, "fichier").getText() + "_" + motif_largeur + "x" + motif_hauteur + "_x" + repetition_echelle + ".png";
  nom_fichier_brut = cp5.get(Textfield.class, "fichier").getText() + "_" + motif_largeur + "x" + motif_hauteur + "_x1.png";

  // Afficher l'état de l'enregistrement des fichiers : enregistré = rond vert, sinon croix orange devant le nom *****************
  fill(255);
  text(nom_fichier, 780, 20);
  if (fichier_enregistre) {
    fill(0, 255, 0);
    text("o", 762, 20);
  } else {
    fill(255, 128, 0);
    text("x", 762, 20);
  }

  fill(255);
  text(nom_fichier_brut, 780, 40);
  if (fichier_enregistre_brut) {
    fill(0, 255, 0);
    text("o", 762, 40);
  } else {
    fill(255, 128, 0);
    text("x", 762, 40);
  }
  
  fill(255);
  text(brouillon_travail, 780, 60);
  if (brouillon_enregistre) {
    fill(0, 255, 0);
    text("o", 762, 60);
  } else {
    fill(255, 128, 0);
    text("x", 762, 60);
  }
  
  
  
  // Dessiner avec la souris dans la grille de pixels ****************************************************************************
  if (mousePressed) {
    if ( (mouseX >= xs)
      && (mouseX <= xs + (elements_x * motif_taille))
      && (mouseY >= ys)
      && (mouseY <= ys + (elements_y * motif_taille)) ) {
      int xchange = int((mouseX - xs) / motif_taille); 
      int ychange = int((mouseY - ys) / motif_taille); 
      if (xchange < 0) xchange = 0;
      if (xchange > elements_x - 1) xchange = elements_x - 1;
      if (ychange < 0) ychange = 0;
      if (ychange > elements_y - 1) ychange = elements_y - 1;
      //motif[ychange][xchange] = !motif[ychange][xchange];
      if (mouseButton == CENTER)  motif[ychange][xchange] = 0;
      if (mouseButton == LEFT)    motif[ychange][xchange] = 1;
      if (mouseButton == RIGHT)   motif[ychange][xchange] = 2;
      quelquechose_change = true;
    }
  }

  // dessiner les contours de la grille (à gauche) *********************************************************************************
  noStroke();
  for (int y = 0; y < elements_y; y++) {
    for (int x = 0; x < elements_x; x++) {
      int alpha = 255;
      if (x < decalage_x || x >= (decalage_x + motif_largeur) || y < decalage_y || y >= (decalage_y + motif_hauteur)) {
        alpha = 100;
      }
      // Remplir selon la valeur de motif
      if (motif[y][x] == 0) {
        stroke(200, 50, 50);
        strokeWeight(1);
        line(xs+x*motif_taille, ys+y*motif_taille, xs+x*motif_taille+motif_taille, ys+y*motif_taille+motif_taille);
        line(xs+x*motif_taille, ys+y*motif_taille+motif_taille, xs+x*motif_taille+motif_taille, ys+y*motif_taille);
      } else {
        noStroke();
        if (motif[y][x] == 1) fill(255, alpha);
        else fill(0, alpha);
        rect(xs+x*motif_taille, ys+y*motif_taille, motif_taille-1, motif_taille-1);
      }
    }
  }

  // dessiner la limite des dimensions ***********************************************************************************************
  noFill();
  stroke(255, 255, 0);
  strokeWeight(3);
  rect(xs + decalage_x*motif_taille, ys + decalage_y*motif_taille, motif_largeur*motif_taille, motif_hauteur*motif_taille);

  // Dessiner des épaisseurs pour la grille tous les 16 pixels
  strokeWeight(1);
  stroke(255, 128, 0);
  for (int y = 0; y <= elements_y; y+=16) {
    for (int x = 0; x <= elements_x; x+=16) {
      line(xs + x * motif_taille, ys, xs + x * motif_taille, ys + y * motif_taille);
      //line(xs, ys, xs + x * motif_taille, ys + y * motif_taille);
    }
    line(xs, ys + y * motif_taille, xs + elements_x * motif_taille, ys + y * motif_taille);
  }
  // recalculer l'image si nécessaire ************************************************************************************************

  if (quelquechose_change) {

    fichier_enregistre = false;
    fichier_enregistre_brut = false;
    brouillon_enregistre = false;
    compteur_clic ++;

    motif_image = createGraphics(motif_largeur*repetition_echelle, motif_hauteur*repetition_echelle, P2D);
    motif_image.beginDraw();
    motif_image.noStroke();
    for (int y = decalage_y; y < elements_y; y++) {
      for (int x = decalage_x; x < elements_x; x++) {
        if (motif[y][x] == 0) {
          motif_image.fill(0, 0);
        }
        if (motif[y][x] == 1) {
          motif_image.fill(255, 255);
        }
        if (motif[y][x] == 2) {
          motif_image.fill(0, 255);
        }
        //if (motif[y][x]) motif_image.fill(255);
        //else motif_image.fill(0);
        motif_image.rect((x-decalage_x)*repetition_echelle, (y-decalage_y)*repetition_echelle, repetition_echelle, repetition_echelle);
      }
    }
    motif_image.endDraw();

    quelquechose_change = false;
  }
  
  // Sauver l'image de brouillon *******************************************************************************************************
  if (compteur_clic > 10) { 
    sauverBrouillon();
    compteur_clic = 0;
  }

  // dessiner le motif répété **********************************************************************************************************
  noFill();
  noStroke();
  int image_largeur = motif_image.width;
  int image_hauteur = motif_image.height;
  int xmax = int ((width - 500) / image_largeur) + 1;
  int ymax = int (height / image_hauteur) + 1;
  for (int y = 0; y < ymax; y++) {
    for (int x = 0; x < xmax; x++) {
      image(motif_image, decalage_repetition_x + (x * image_largeur), y * image_hauteur);
    }
  }
  
  
  // Afficher les touches d'interaction
  fill(255);
  text("alt+t : effacer l'espace du motif", 950, 610);
  text("alt+b : passer l'espace du motif en blanc", 950, 630);
  text("alt+n : passer l'espace du motif en noir", 950, 650);
  text("alt+0...9 : charger une image sur la table de travail", 950, 670);
  text("s : enregistrer le motif échelle 1", 950, 690);
  text("S : enregistrer le motif", 950, 710);
  text("f : enregistrer la table de travail", 950, 730);
}


void effacerMotif(int valeur) {
  for (int y = decalage_y; y < decalage_y + motif_hauteur; y++) {
    for (int x = decalage_x; x < decalage_x + motif_largeur; x++) {
      motif[y][x] = valeur;
    }
  }
  quelquechose_change = true;
}

void changerDecalage(int x, int y) {
  println("decalage : x " + x+ " y " + y);
  if ((x < 0) && (decalage_x > 0)) decalage_x --;
  if ((x > 0) && (decalage_x + motif_largeur < elements_x)) decalage_x++;
  if ((y < 0) && (decalage_y > 0)) decalage_y --;
  if ((y > 0) && (decalage_y + motif_hauteur < elements_y)) decalage_y++;
  quelquechose_change = true;
}

// Sauver le motif à l'échelle 1
void sauverMotif() {
  motif_image_brut = createGraphics(motif_largeur, motif_hauteur, P2D);
  motif_image_brut.beginDraw();
  motif_image_brut.noStroke();
  for (int y = decalage_y; y < elements_y; y++) {
    for (int x = decalage_x; x < elements_x; x++) {
      if (motif[y][x] == 0) {
        motif_image_brut.fill(0, 0);
      }
      if (motif[y][x] == 1) {
        motif_image_brut.fill(255, 255);
      }
      if (motif[y][x] == 2) {
        motif_image_brut.fill(0, 255);
      }
      motif_image_brut.rect(x-decalage_x, y-decalage_y, 1, 1);
    }
  }
  motif_image_brut.endDraw();
  motif_image_brut.save(nom_fichier_brut);
  fichier_enregistre_brut = true;
}

// Sauver le brouillon
void sauverBrouillon() {
  brouillon = createGraphics(elements_x, elements_y, P2D);
  brouillon.beginDraw();
  brouillon.noStroke();
  for (int y = 0; y < elements_y; y++) {
    for (int x = 0; x < elements_x; x++) {
      if (motif[y][x] == 0) {
        brouillon.fill(0, 0);
      }
      if (motif[y][x] == 1) {
        brouillon.fill(255, 255);
      }
      if (motif[y][x] == 2) {
        brouillon.fill(0, 255);
      }
      brouillon.rect(x, y, 1, 1);
    }
  }
  brouillon.endDraw();
  brouillon.save(brouillon_travail);
  brouillon_enregistre = true;
}




void chargerImage(String fichier) {
  println("fichier à charger : " + fichier);
  File f = dataFile(fichier);
  String filePath = f.getPath();
  boolean exist = f.isFile();

  if (f.isFile()) {

    PImage modele = loadImage(fichier);

    // Définir les dimensions max en fonction de l'image chargée
    int dimx = modele.width;
    int dimy = modele.height;
    if (dimx > 48) dimx = 48;
    if (dimy > 48) dimy = 48;

    // Transférer les valeurs de pixels dans le tableau du motif
    for (int y = 0; y < dimy; y++) {
      for (int x = 0; x < dimx; x++) {
        if (alpha(modele.get(x, y)) < 128) motif[y][x] = 0;
        else {
          if (red(modele.get(x, y)) < 128) motif[y][x] = 2;
          else motif[y][x] = 1;
        }
      }
    }
    quelquechose_change = true;
  } else {
    println("Le fichier " + filePath + " est introuvable.");
  }
}
