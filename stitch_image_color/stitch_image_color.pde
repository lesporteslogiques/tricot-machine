/*
  transformation d'une image en mailles de tricot!
 processing 4.0b2 @ kirin / Debian Stretch 9.5
 20230718 @ Orléans, OAVL de Labomedia / pierre@lesporteslogiques.net

 
 utilisable en ligne de commande :
 xvfb-run /home/emoc/processing-4.0b2/processing-java --sketch="/home/emoc/sketchbook/2023_KI/stitch_image_color/" --run "/home/emoc/sketchbook/2023_KI/stitch_image_color/lalabo.png"
 */

boolean GUIMODE = true;       // GUI ou ligne de commande ? Changé automatiquement si le script est lancé en ligne de commande

PImage img_orig;              // image à traiter
PGraphics img_dest;           // image résultant du traitement

String fichier_orig = "lalabo.png";     // nom du fichier original à traiter
String fichier_dest = "";     // nom du fichier à créer
String chemin_orig = "";      // chemin complet vers le fichier original
String extension = "png";     // extension et format de fichier à créer
String racine = "";           // racine du nom de fichier à créer

// variables spécifiques à ce traitement
float maille_larg = 18;       // largeur d'une maille en pixel
float maille_haut = 12;       // hauteur d'une maille en pixel
float maille_dip  = 6;        // pointe de maille

void setup() {
  size(800, 300);
  init();                     // traitement des arguments associés à la ligne de commande
  racine = fichier_orig.substring(0, fichier_orig.lastIndexOf('.'));
  fichier_dest = racine + "_stitched." + extension;
}

void draw() {

  println("fichier à traiter : " + fichier_orig);
  println("nom du fichier traité : " + fichier_dest);

  img_orig = loadImage(fichier_orig);

  img_dest = createGraphics(img_orig.width * (int)maille_larg, img_orig.height * (int)maille_haut);
  img_dest.beginDraw();
  img_dest.background(127);
  img_dest.stroke(0);

  img_orig.loadPixels();
  for (int j = 0; j < img_orig.width * img_orig.height; j ++) {
    int x = j%img_orig.width;
    int y = floor(j/img_orig.width);
    color c = img_orig.pixels[j];
    float b = brightness(c);
    img_dest.fill(c);
    knit (x * maille_larg, y * maille_haut, maille_larg, maille_haut, maille_dip);
  }
  img_orig.updatePixels();
  img_dest.endDraw();
  img_dest.save(fichier_dest);


  if (!GUIMODE) {
    exit();
  }
  noLoop();
}

// Tracer une maille
// Tracé des courbes d'après sweaterify de Mariko Kosaka https://github.com/kosamari/sweaterify
void knit (float x, float y, float sWidth, float sHeight, float dip) {
  img_dest.beginShape();
  img_dest.vertex(x + (sWidth / 2), y + dip);
  img_dest.quadraticVertex(x + sWidth - (sWidth / 3), y - (sHeight / 12), x + sWidth - (sWidth / 10), y - sHeight / 4);
  img_dest.quadraticVertex(x + sWidth - (sWidth / 50), y, x + sWidth - (sWidth / 70), y + (sHeight / 10));
  img_dest.endShape();

  img_dest.beginShape();
  img_dest.vertex(x + sWidth - (sWidth / 70), y + (sHeight / 10));
  img_dest.bezierVertex(x + sWidth, y + (sHeight / 4), x + sWidth, y + (sHeight * 0.50), x + sWidth - (sWidth / 15), y + (sHeight * 0.66));
  img_dest.bezierVertex(x + sWidth - (sWidth * 0.3), y + sHeight, x + sWidth - (sWidth * 0.3), y + sHeight, x + sWidth - (sWidth / 2) + (sWidth / 20), y + sHeight + sHeight / 3);
  img_dest.endShape();

  img_dest.beginShape();
  img_dest.vertex(x + sWidth - (sWidth / 2) + (sWidth / 20), y + sHeight + sHeight / 3);
  img_dest.quadraticVertex(x + sWidth - (sWidth * 0.55), y + (sHeight * 0.7), x + sWidth - (sWidth / 2), y + dip);
  img_dest.vertex(x + sWidth - (sWidth / 2), y + dip);
  img_dest.endShape();

  img_dest.noStroke();

  img_dest.beginShape();
  img_dest.vertex(x + sWidth - (sWidth / 2), y + dip);
  img_dest.vertex(x + sWidth - (sWidth / 70), y + (sHeight / 10));
  img_dest.vertex(x + sWidth - (sWidth / 2) + (sWidth / 20), y + sHeight + sHeight / 3);
  img_dest.endShape();

  img_dest.beginShape();
  img_dest.vertex(x + (sWidth / 2) - sWidth * 0.03, y + dip);
  img_dest.quadraticVertex(x + (sWidth * 0.4), y + (sHeight / 12), x + (sWidth / 10), y - sHeight / 4);
  img_dest.quadraticVertex(x + (sWidth / 50), y, x + (sWidth / 70), y + (sHeight / 10));
  img_dest.endShape();

  img_dest.beginShape();
  img_dest.vertex(x + (sWidth / 70), y + (sHeight / 10));
  img_dest.bezierVertex(x, y + (sHeight / 4), x, y + (sHeight * 0.50), x + (sWidth / 15), y + (sHeight * 0.66));
  img_dest.bezierVertex(x + (sWidth * 0.3), y + sHeight, x + (sWidth * 0.3), y + sHeight, x + (sWidth / 2) - (sWidth / 40), y + sHeight + sHeight / 3);
  img_dest.quadraticVertex(x + (sWidth * 0.56), y + (sHeight + sHeight / 4), x + (sWidth / 2) - sWidth * 0.05, y + dip);
  img_dest.vertex(x + (sWidth / 2) - sWidth * 0.03, y + dip);
  img_dest.endShape();
}

// *********************************************************************************

// Fonction pour traiter les arguments de la ligne de commande
void init() {
  if (args != null) {
    GUIMODE = false;
    println("Arguments : " + args.length);
    for (int i = 0; i < args.length; i++) {
      println(args[i]);
    }
    if (args.length == 1) {
      fichier_orig = args[0];
    } else {
      println("arguments insuffisants (indiquer dossier de départ et dossier d'arrivée)");
      exit();
    }
  } else {
    println("pas d'arguments transmis par la ligne de commande");
  }
}
