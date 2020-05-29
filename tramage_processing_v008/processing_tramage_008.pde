/* jolis ditherings 
    Kemper, La Baleine, 5 septembre 2018
    Processing 3.4 @ Zibu / Ubuntu Studio 16.04
    Pierre Commenge / pierre@lesporteslogiques.net

      + lib. controlP5 2.2.6
    001 : application de valeurs de contraste et de luminosité
      modification de luminosite et constraste d'après dr. mo sur le forum processing (chercher 'increase contrast of an image')
    002 : avec application d'un seuil + sauvegarde
    003 : avec dithering, couleurs inversables, et bouton pour choisir un fichier
    005 : avec différents algo de dithering
    006 : MARCHE PAS! avec application de la déformation
    007 : avec application de la déformation
    
    TODO :
      - correction du bug d'inversion de couleurs
      - pour une orientation plus graphique : choix des 2 couleurs ?
      - (autres algos de dithering)  
      - pouvoir dessiner des points à la volée avec le clic qui inverse!
      - algo : random avec distribution gaussienne
      
    USAGE :
      - les images peuvent faire 200 x ... pixels max
      - et être en niveau de gris
*/

boolean DEBUG = true;

// export d'images : fonctions de dates 
import java.util.Date;
import java.text.SimpleDateFormat;
// export d'images : racine du nom de fichier = nom du sketch
String SKETCH_NAME = getClass().getSimpleName();
String dimensions; // pour ajouter au nom de fichier

// importer la lib. pour les éléments d'interface
import controlP5.*;
ControlP5 cp5;

String fichier = "aphrodite.png"; // ficher par défaut

PImage imgo; // image originale
PImage imgr; // image retouchee
PImage imgd; // image deformee
PImage imgm; // image moiree;

// largeur (w) et hauteur (h) pour chaque buffer d'image utilisé
int imgow, imgoh, imgrw, imgrh, imgdw, imgdh, imgmw, imgmh; 

// Variables utilisées par les éléments d'interface
int largeur;             // pour le curseur de taille
float deformation;       // pour le curseur de deformation
float zoom;              // pour l'image moirée agrandie
float contraste;         // modification du contraste de l'iamge d'origine
float luminosite;        // modification de la luminosité de l'image d'origine
float seuil;             // seuil de passage du noir au blanc
int bruit;               // valeur aléatoire ajoutée à chaque pixel
int posterize;           // effet de posterization, appliqué si supérieur à deux
int dither_type;         // type de moirage à appliquer

// Couleurs
int blanc = 255;
int noir  = 0;
int c1, c2;

// Booléen utilisé pour déclencher les recalculs de buffers d'iamge
boolean quelquechose_change = false;

// Tableau contenant une valeur pour chaque pixel, plus économe que le type 'color'
byte[][] pix;

// Logique pour le bouton d'inversion
boolean inverse = false;
boolean inverse_last = false;


void setup() {
  size(1200, 730);
  noSmooth();
  
  cp5 = new ControlP5(this);
  initialiser_interface();
  
  initialiser_buffer_images();
  miseajour_buffer_images();
}


void draw() {
  background(128);
  
  // Une palette ou l'autre... ********************************** 
  if (inverse != inverse_last) quelquechose_change = true;
  if (inverse) {
    c1 = noir;
    c2 = blanc;
  } else {
    c1 = blanc;
    c2 = noir;
  }
  inverse_last = inverse;
   
  // Faut il recalculer le buffer de l'iamge moirée ?
  if (quelquechose_change) miseajour_buffer_images();
  
  // Affichage **************************************************
  image(imgo,  30, 100);   // image originale
  image(imgr,  30, 400);   // image retouchée
  image(imgd, 250, 100);   // image déformée
  image(imgm, 470, 100);   // image moirée
  
  // Affichage du moirage sans déformation
  image(imgm, 470, 500, imgow, imgoh);
  
  // Affichage grand format du moirage avec déformation *********
  image(imgm, 700, 50, imgmw * zoom, imgmh * zoom );
  
  text("fichier : " + fichier, 120, 75);
  text(largeur + " mailles / " + imgmh + " rangs", 250, 90);
  
  dimensions = imgmw + "x" + imgmh; // utilisé pour l'export
  
  quelquechose_change = false;
}

void initialiser_buffer_images() {
  imgo  = loadImage(fichier);
  imgow = imgo.width;
  imgoh = imgo.height;
  
  imgr = createImage(imgow, imgoh, RGB);
  imgrw = imgr.width;
  imgrh = imgr.height;
  imgr = imgo.copy();
}

void miseajour_buffer_images() {
  
  // Définir le buffer de l'image à l'échelle
  imgdw = largeur;
  imgdh = int( ( (float)largeur / (float)imgow ) * (float)imgoh * deformation);
  imgd  = createImage(imgdw, imgdh, RGB);
  imgd.copy(imgr, 0, 0, imgrw, imgrh, 0, 0, imgdw, imgdh);
  
  // Définir le buffer de l'image moirée
  imgmw = largeur;
  imgmh = imgdh;
  imgm  = createImage(imgmw, imgmh, RGB);
  
  // Définir le tableau de valeurs de pixels
  pix = new byte[imgdw][imgdh];
  
  modifierImage();
  resetValues();
  calculerDither();
}

// Appliquer les modifications de contraste, luminosité à l'image d'origine
void modifierImage() {
  imgr.loadPixels();
  imgo.loadPixels();
  for (int i = 0; i < imgr.pixels.length; i++) {
    
    // récupérer la valeur de couleur du pixel
    color c = imgo.pixels[i];
    
    // version avec appel de fonction, très lent!
    //int r = (int)   red(image_originale.pixels[i]);
    //int v = (int) green(image_originale.pixels[i]);
    //int b = (int)  blue(image_originale.pixels[i]);
    
    // en utilisant du bit-shifting, c'est beaucoup plus rapide
    int r = (c >> 16) & 0xFF;
    int v =  (c >> 8) & 0xFF;
    int b =         c & 0xFF;
    
    // appliquer contraste et luminosite
    r = (int) (r * contraste + luminosite + random(-bruit, bruit));
    v = (int) (v * contraste + luminosite + random(-bruit, bruit));
    b = (int) (b * contraste + luminosite + random(-bruit, bruit));
    
    // tester si on sort des limites, 
    r = r < 0 ? 0 : r > 255 ? 255 : r;
    v = v < 0 ? 0 : v > 255 ? 255 : v;
    b = b < 0 ? 0 : b > 255 ? 255 : b;
    
    // appliquer la nouvelle valeur au pixel, version lente avec fonction
    //image_modifiee.pixels[i] = color(r, v, b);
    
    // ou version rapide en bit-shifting
    imgr.pixels[i] = 0xff000000 | (r << 16) | (v << 8) | b;
  }
  imgo.updatePixels();
  imgr.updatePixels();
  if (posterize > 2) imgr.filter(POSTERIZE, posterize);
  //if (inverse) imgr.filter(INVERT);
}

void resetValues() {
  imgd.loadPixels();
  for (int x = 0; x < imgd.width; x++) {
    for (int y = 0; y < imgd.height; y++) {
      int i = x + y * imgd.width;
      color c = imgd.pixels[i];
      int r = (c >> 16) & 0xFF;
      pix[x][y] = byte(r - 128);
    }
  }
  imgd.updatePixels();
}
