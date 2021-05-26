/*
  Classe permettant de charger un répertoire d'images sur le même thème
  ex : batiments, persos, motifs, etc.
*/



class Collection {

  String nom;               // nom de la collection pour debug
  String repertoire;        // répertoire contenant les images à charger
  String[] fichiers;        // tous les fichiers du répertoire
  PImage[] motifs;          // tableau contenant toutes les images
  PGraphics motif;          // motif en cours
  int index = 0;            // index du motif en cours
  int coef_agrandissement;  // coefficient d'agrandissement de l'image

  Collection (String _r, String _n, int _c) {
    repertoire = _r;
    nom = _n;
    coef_agrandissement = _c;
    init();
    construireIconeMotif(index);
  }

  void init() {
    fichiers = listFileNames( dataPath("") + "/" + repertoire + "/" ); 
    motifs = new PImage[fichiers.length];
    println("Chargement des motifs de la collection " + nom);
    for (int i = 0; i < motifs.length; i++) {
      println(i + "  :  " + fichiers[i]);
      motifs[i] = loadImage( "./data/" + repertoire + "/" + fichiers[i] );
    }
    println("------------------------ collection " + nom + " chargée -----");
  }

  void construireIconeMotif(int i) {
    index = i%motifs.length;
    int c = coef_agrandissement;
    println("index : " + index + "   /  motifs.length : " + motifs.length);

    motif = createGraphics(motifs[index].width * c, motifs[index].height * c);
    motif.beginDraw();
    motif.background(255, 0, 0, 100);
    motif.copy(motifs[index], 0, 0, motifs[index].width, motifs[index].height, 0, 0, motif.width, motif.height);
    motif.endDraw();
  }

  void updateIndex(int _i) {
    index = _i;
    construireIconeMotif(index);
  }

  void afficher(float x, float y) {
    stroke(255, 0, 0);
    fill(255, 100);
    strokeWeight(3);
    rectMode(CENTER);
    rect(x, y, motif.width, motif.height);
    rectMode(CORNER);
    imageMode(CENTER);
    image(motif, x, y);
    imageMode(CORNER);
  }
  
  PImage getMotif() {
    return motifs[index];
  }

  //function to get all files in the data folder
  String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      StringList filelist = new StringList();
      for (String s : names) {
        if (!s.contains("DS_Store")) {
          filelist.append(s);
        }
      }
      return filelist.array();
    } else {
      // if it's not a directory
      return null;
    }
  }

  PGraphics resizeImg(PGraphics in, int factor) {
    PGraphics out = createGraphics(in.width * factor, in.height * factor, P2D);
    in.loadPixels();
    out.loadPixels();
    for (int y=0; y<in.height; y++) {
      for (int x=0; x<in.width; x++) {
        int index = x + y * in.width;
        for (int h=0; h<factor; h++) {
          for (int w=0; w<factor; w++) {
            int outdex = x * factor + w + (y * factor + h) * out.width;
            out.pixels[outdex] = in.pixels[index];
          }
        }
      }
    }
    out.updatePixels();
    return out;
  }
}
