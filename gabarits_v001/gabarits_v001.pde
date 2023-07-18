/*  gabarits_v001
 
 Dessins sur gabarits en tricot-machine 
 Orléans, OAVL, 18-22 juillet 2023 / pierre@lesporteslogiques.net
 processing 4.0b2 @ kirin
 
 Plusieurs gabarits de tricot sont proposés
 On peut dessiner sur la grande page et déplacer le gabarit
 Modes de dessin : pixel, tampons, texture
 
  ** historique **
 (dérivé de mymaillecollection_v006, affiche_v002, dérivé de tricotmachin_kemper_edn_003, dérivé de carhaix_pixels_005 )
 
 ** version **
 mymaillecollection_v001 : *
 mymaillecollection_v002 : modification des tailles de gabarit
 mymaillecollection_v003 : réduction / simplification (version transitoire)
 mymaillecollection_v004 : réduction / simplification (version complète)
 mymaillecollection_v005 : ajout du mode texture 
 mymaillecollection_v006 : gestion des gabarits (chargés depuis un fichier csv) + début d'historique
 gabarits_v001 = mymaillecollection_v006
 
 ** TODO **
   * permettre des textures multiples en classe (même principe que pour les tampons)
   * finir la gestion d'historique (cf. classe Historique + ALT-Z )
     * ajouter un arraylist pour conserver les versions différents de map (niveaux d'annulation)
     * CTRL-Z pour annuler (conserver la version précédente du buffer)
   * TODO developper textures / touche pour annuler la texture quand l'origine est placée
   * renommer motifs en tampons (les petites collections d'image) pour éviter la confusion avec le motif de la machine
   * bug quand on change de mode, l'étiquette texte n'est pas mise à jour 
   * revoir l'interface graphique qui n'est pas claire
   * permettre agrandissement ou réduction de l'espace de motif
     * remettre les sliders pour changer la taille du cadre
   * permettre de changer couleur de contraste et couleur de fond pour tester
   * appui sur une touche pour afficher l'iamge avec des mailles simulées
   * ajouter un mode remplissage avec motif
   * ajouter un éditeur de motif intégré (enregistré dans perso)
   * zoom
   * afficher zones "mortes" (car découpées apres tricot)

 ** problèmes rencontrés **
 sun.java2d.SunGraphics2D cannot be cast to java.awt.Image : https://github.com/processing/processing/issues/4127
 -> utiliser get(x,y,w,h) plutot que 
 The pixels array is null. : https://forum.processing.org/one/topic/what-can-cause-the-pixel-array-of-a-pgraphics-to-be-null.html
 -> initialiser les buffers graphiques ( buffer.loadPixels(); juste apres createGraphics )
 
 ** interaction **
 mode pixel : bouton gauche (sur le dessin) : rendre le pixel noir
 mode pixel : bouton droit (sur le dessin) : rendre le pixel blanc
 autres modes : bouton gauche (sur le dessin) : dessiner le motif
 autres modes : bouton droit (sur le dessin) : changer de motif
 mode texte/texte2 pour les caractères possibles, voir la fonction chargerTexte() dans l'onglet utile
 mode texture : clic gauche pour commencer, clic pour terminer
 J, L : changer de collection de motif
 I, K : changer de motif
 
 **vocabulaire, variables**
 map : image principale 
 zoom : image zoomée
 gab : tout ce qui concerne le gabarit (espace de la zone de travail pour un ouvrage particulier)
 motif : partie exportée pour l'ouvrage
 
 **fichiers associés nécessaires**
 - data/gabarits.csv
 - dossiers avec les tampons et les lettres
 - (dossier avec les textures : TODO pour l'instant un seul fichier possible)
  
 */

boolean DEBUG = true;

//import java.awt.event.KeyEvent;

// Interface *******************************

import controlP5.*;
import java.util.*;
ControlP5 cp5;
PFont font;                                   // police utilsiée pour les éléments d'interface

// Elements principaux *********************

String image_base = "./data/imagebase.png";   // sauvegarde la zone de travail
PImage original;                              // image/map de départ

PGraphics map;                                // image/map principale complète (zone de travail) 
int map_w = 192;                              // largeur de l'image/map principale
int map_h = 192;                              // hauteur de l'image/map principale

PGraphics zoom;                               // image zoomée 
int position = 0;     // TODO nécessaire ?    // position de le fenêtre portion sur l'image principale
int coef = 4;                                 // rapport entre portion agrandie et image originale

int ox, oy;                                   // coordonnées du pixel dans l'image d'origine 
int px, py;                                   // coordonnées du pixel dans l'image portion / zoomée

// Gabarit ***************************************************
// PVector impossible car chaque composante est gardée en float...

GestionGabarit tous_gabarits = new GestionGabarit();

int gab_dec_x = 16;                           // décalage du gabarit
int gab_dec_y = 16;
int gab_dim_x = 16;                           // dimensions du gabarit  
int gab_dim_y = 16;

// Assets (tampons, lettres) *********************************

PImage[] lettres = new PImage[31];            // Utilisé pour le mode texte
PImage[] lettresX2 = new PImage[31];          // Utilisé pour le mode texte taille double
Button[] boutons;                             // Tableau de bouton généré automatiquement
Collection[] collec;                          // Chaque collection contient un répertoire thémtique d'images
String[] toutes_collections = { "persos", "motifs", "gommes", "special"}; // exit "batiments",
int index_motif = 0;                          // Utilisé pour parcourir les séries d'images (motif, perso, etc.)
int collec_en_cours;
int tampon_w, tampon_h;                       // dimensions du motif actuel, utilisé pour l'affichage du curseur uniquement

// Interface ********************************

PVector pos_map = new PVector(1050, 520);     // point d'accroche de l'affichage de l'image/map principale
PVector pos_bout = new PVector(900, 520);     // Coordonnées de départ des boutons
PVector pos_po = new PVector(50, 50);         // point d'accroche de l'affichage de la zone editable
PVector pos_inter = new PVector(1050, 50);    // Coordonnées de base de l'interface
boolean help_mode = false;                    // état pour faire apparaître ou masquer l'aide
String mode = "";                             // utilisé pour l'affichage
String gabarit_description = "";              // TODO

// Logique et interaction ************************************

boolean ctrlPressed  = false;
boolean altPressed   = false;
boolean shiftPressed = false;

boolean quelquechose_change = true;           // recalculer les images uniquement quand c'est nécessaire
boolean sur_le_dessin = false;                // la souris est elle sur la partie zoomée éditable ?
int compteur_clic = 0;                        // pour enregistrer l'image de travail automatiquement

// Export des éléments créés *********************************

PGraphics motif_image_brut;              // image du motif qui peut être enregistrée à échelle 1
String nom_fichier_brut = "";            // nom du fichier qui sera enregistré (pour l'échelle 1)
boolean fichier_enregistre_brut = false; // état des sauvegardes : motif échelle 1 enregistré
boolean brouillon_enregistre = false;    // état des sauvegardes : brouillon de travail enregistré

// Textures ***************************************************

PImage teximg;
PGraphics tex, texcoef;
PVector tex_orig, tex_dest;
boolean texture_on = false;

// Historique *************************************************

Historique historique = new Historique();


void setup() {
  size(1280, 850, P2D);
  noSmooth();
  
  tous_gabarits.init();

  // Interface
  font = createFont("arial", 12);
  textFont(font);
  cp5 = new ControlP5(this);
  initialiserInterface();

  // Créer les éléments graphiques principaux
  map = createGraphics(map_w, map_h, P2D);
  map.textureMode(IMAGE);
  map.textureWrap(REPEAT);
  
  historique.addToHistory(map);

  zoom = createGraphics(map_w * coef, map_h * coef, P2D); 

  // Initialisation les buffers graphiques
  map.loadPixels();
  zoom.loadPixels();

  // Recréer l'image d'après la dernière sauvegarde 
  original = loadImage(image_base);
  map.beginDraw();
  map.background(255, 255);
  map.image(original, 0, 0);
  map.endDraw();

  // Charger les assets texte
  chargerTexte();
  chargerTexteX2();

  // Créer les collections
  collec = new Collection[toutes_collections.length];
  for (int i = 0; i < toutes_collections.length; i++) {
    collec[i] = new Collection(toutes_collections[i], toutes_collections[i], coef);
  }
  switchCollection( 0 ); // Collection par défaut

  // Texture
  teximg = loadImage("pattern.png");

  tex = createGraphics(teximg.width, teximg.height, P2D);
  tex.loadPixels();
  tex.beginDraw();
  tex.background(255, 255);
  tex.image(teximg, 0, 0);
  tex.endDraw();

  texcoef = createGraphics(tex.width * coef, tex.height * coef, P2D);
  texcoef.loadPixels();
  texcoef = resizeImg(tex, coef);

  textureMode(IMAGE);
  textureWrap(REPEAT);
  tex_orig = new PVector(0, 0);
  tex_dest = new PVector(0, 0);
  
  //println(tous_gabarits.getGab());
}


void draw() {
  background(50, 150, 50);
  sur_le_dessin = false;

  // mettre à jour le nom de fichier 
  nom_fichier_brut = cp5.get(Textfield.class, "fichier").getText() + "_" + gab_dim_x + "x" + gab_dim_y + "_x1.png";

  // Afficher les éléments d'interface
  afficherInterface();

  // Affichage de l'image complète
  image(map, pos_map.x, pos_map.y);

  // Afficher la zone éditable
  image(zoom, pos_po.x, pos_po.y);

  // dessiner les éléments de gabarit
  gabaritMasque();   // masque gris sur les zones hors gabaarit
  gabaritContour();  // contour du gabarit

  // Dessiner des épaisseurs pour la grille tous les 16 pixels
  grille();

  // Calculer la coordonnée dans l'image portion en fonction de la position de la souris
  px = int((mouseX - pos_po.x) / coef) * coef;
  py = int((mouseY - pos_po.y) / coef) * coef;

  // Calculer la coordonnée dans l'image d'origine en fonction de la position de la souris
  ox = int((mouseX - pos_po.x) / coef);
  oy = int((mouseY - pos_po.y) / coef);

  // Si la souris est sur la portion afficher le curseur adapté
  if (mouseX > pos_po.x - (int(tampon_w/2) * coef)
    && mouseX < pos_po.x + zoom.width + (int(tampon_w/2) * coef)
    && mouseY > pos_po.y - (int(tampon_h/2) * coef)
    && mouseY < pos_po.y + zoom.height + (int(tampon_h/2) * coef)) {

    sur_le_dessin = true;
    noCursor();
    modeDessin(mode); // afficher le curseur adapté au mode
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

  image(tex, 1050, height/2);             // TODO positionner dans l'interface
  image(texcoef, 1100, height/2 - 100);   // TODO positionner dans l'interface
  text(gabarit_description, 1050, 30);    // TODO positionner dans l'interface

  if (texture_on) {
    noStroke();
    noFill();
    rect(tex_orig.x, tex_orig.y, mouseX - tex_orig.x, mouseY - tex_orig.y);
    textureTracerForme(tex_orig.x, tex_orig.y, mouseX, mouseY);
  } else {
    //println("texture off");
  }

  if (quelquechose_change) {
    zoom = resizeImg(map, coef);  // agrandir sans interpolation la zone éditable 
    compteur_clic ++;
    brouillon_enregistre = false;
    fichier_enregistre_brut = false;
  }

  // Sauver l'image de travail automatiquement
  if (compteur_clic > 5) { 
    sauverBrouillon();
    compteur_clic = 0;
  }

  // Afficher l'aide si active
  if (help_mode) afficherAide();

  quelquechose_change = false;
}
