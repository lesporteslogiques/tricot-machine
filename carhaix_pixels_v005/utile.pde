/* Remplir la map de points blancs et noirs au hasard */
void randomMap() {
  map.beginDraw();
  map.background(100, 0);
  map.stroke(0, 255);
  for (int i = 0; i < 2000; i++) {
    map.point(random(map.width), random(map.height));
  }
  map.stroke(255, 255);
  for (int i = 0; i < 2000; i++) {
    map.point(random(map.width), random(map.height));
  }
  map.endDraw();
}



void chargerMotifs() {
  // Charger tous les motifs du répertoire "motifs"
  String[] filenames = listFileNames(dataPath("")+"/motifs/");
  motifs = new PImage [filenames.length]; //array of original images
  println("Chargement des motifs");
  for (int i=0; i<motifs.length; i++) { 
    println(filenames[i]);
    motifs[i] = loadImage("./data/motifs/" + filenames[i]); //load each image
  }
  println("-------------------");
}

void construireIconeMotif(int i) {
  println("construireIconeMotif : " + i);
  

  i = i%motifs.length;
  int c = coef_agrandissement;
  println("motifs[i].width * c : " + motifs[i].width*c + " / motifs[i].height * c : " + motifs[i].height*c);
  motif = createGraphics(motifs[i].width * c, motifs[i].height * c);
  //motif.loadPixels();
  motif.beginDraw();
  motif.background(255, 0, 0, 100);
  motif.copy(motifs[i], 0, 0, motifs[i].width, motifs[i].height, 0, 0, motif.width, motif.height);
  motif.endDraw();
}

// Charger tous les motifs du répertoire "persos"
void chargerPersos() {
  String[] filenames = listFileNames(dataPath("")+"/persos/");
  persos = new PImage[filenames.length]; //array of original images
  println("Chargement des persos");
  for (int i=0; i<persos.length; i++) { 
    println(filenames[i]);
    persos[i] = loadImage("./data/persos/" + filenames[i]); //load each image
  }
  println("-------------------");
}

void construireIconePerso(int i) {
  i = i%persos.length;
  int c = coef_agrandissement;
  perso = createGraphics(persos[i].width * c, persos[i].height * c);
  //perso.loadPixels();
  perso.beginDraw();
  perso.background(255, 0, 0, 100);
  perso.copy(persos[i], 0, 0, persos[i].width, persos[i].height, 0, 0, perso.width, perso.height);
  perso.endDraw();
}

// Charger tous les motifs du répertoire "batiments"
void chargerBatiments() {
  String[] filenames = listFileNames(dataPath("")+"/batiments/");
  batiments = new PImage[filenames.length]; //array of original images
  println("Chargement des batiments");
  for (int i=0; i<batiments.length; i++) { 
    println(filenames[i]);
    batiments[i] = loadImage("./data/batiments/" + filenames[i]); //load each image
  }
  println("-------------------");
}

void construireIconeBatiment(int i) {
  i = i%batiments.length;
  int c = coef_agrandissement;
  batiment = createGraphics(batiments[i].width * c, batiments[i].height * c);
  //batiment.loadPixels();
  batiment.beginDraw();
  batiment.background(255, 0, 0, 100);
  batiment.copy(batiments[i], 0, 0, batiments[i].width, batiments[i].height, 0, 0, batiment.width, batiment.height);
  batiment.endDraw();
}

// Charger tous les motifs du répertoire "batiments"
void chargerGommes() {
  String[] filenames = listFileNames(dataPath("")+"/gommes/");
  gommes = new PImage[filenames.length]; //array of original images
  println("Chargement des gommes");
  for (int i=0; i<gommes.length; i++) { 
    println(filenames[i]);
    gommes[i] = loadImage("./data/gommes/" + filenames[i]); //load each image
  }
  println("-------------------");
}

void construireIconeGomme(int i) {
  i = i%gommes.length;
  int c = coef_agrandissement;
  gomme = createGraphics(gommes[i].width * c, gommes[i].height * c);
  //gomme.loadPixels();
  gomme.beginDraw();
  gomme.background(255, 0, 0, 100);
  gomme.copy(gommes[i], 0, 0, gommes[i].width, gommes[i].height, 0, 0, gomme.width, gomme.height);
  gomme.endDraw();
}

void chargerTexte() {
  lettres[0] = loadImage("./data/fipps/A.png");
  lettres[1] = loadImage("./data/fipps/B.png");
  lettres[2] = loadImage("./data/fipps/C.png");
  lettres[3] = loadImage("./data/fipps/D.png");
  lettres[4] = loadImage("./data/fipps/E.png");
  lettres[5] = loadImage("./data/fipps/F.png");
  lettres[6] = loadImage("./data/fipps/G.png");
  lettres[7] = loadImage("./data/fipps/H.png");
  lettres[8] = loadImage("./data/fipps/I.png");
  lettres[9] = loadImage("./data/fipps/J.png");
  lettres[10] = loadImage("./data/fipps/K.png");
  lettres[11] = loadImage("./data/fipps/L.png");
  lettres[12] = loadImage("./data/fipps/M.png");
  lettres[13] = loadImage("./data/fipps/N.png");
  lettres[14] = loadImage("./data/fipps/O.png");
  lettres[15] = loadImage("./data/fipps/P.png");
  lettres[16] = loadImage("./data/fipps/Q.png");
  lettres[17] = loadImage("./data/fipps/R.png");
  lettres[18] = loadImage("./data/fipps/S.png");
  lettres[19] = loadImage("./data/fipps/T.png");
  lettres[20] = loadImage("./data/fipps/U.png");
  lettres[21] = loadImage("./data/fipps/V.png");
  lettres[22] = loadImage("./data/fipps/W.png");
  lettres[23] = loadImage("./data/fipps/X.png");
  lettres[24] = loadImage("./data/fipps/Y.png");
  lettres[25] = loadImage("./data/fipps/Z.png");
  lettres[26] = loadImage("./data/fipps/(exclamation).png");
  lettres[27] = loadImage("./data/fipps/(asterisque).png");
  lettres[28] = loadImage("./data/fipps/(plus).png");
  lettres[29] = loadImage("./data/fipps/(moins).png");
  lettres[30] = loadImage("./data/fipps/(interrogation).png");
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

/* Redimensionner sans lissage des pixels, d'après amnon :
 https://forum.processing.org/two/discussion/comment/22918/#Comment_22918
 */
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

void cadrerFragment(int f) {
  position = portion_w * (f-1);
  if (position < 0) position = 0;
  if (position > 1280-portion_w) position = 1280-portion_w;
  quelquechose_change = true;
}

void sauverFragment(int f) {
  println("fragment " + f + " à sauver");
  PGraphics fragment = createGraphics(portion_h, portion_w);
  fragment.loadPixels();
  int xorig = portion_w * (f - 1);
  int xfin = portion_h * f;
  if (xfin > original.width) {
    println("glups, impossible de sauver le fragment " + f);
  } else {
    fragment.beginDraw();
    fragment.pushMatrix();
    fragment.translate(0, 160);
    fragment.rotate(radians(270));
    fragment.copy(map, xorig, 0, portion_w, portion_h, 0, 0, portion_w, portion_h);
    fragment.popMatrix();
    fragment.endDraw();
    fragment.save("tricot_partie_" + f + ".png");
    println("fragment " + f + " sauvé!");
    modifierMasque(f);
  }
}

void modifierMasque(int f) {
  map_masque.beginDraw();
  map_masque.noStroke();
  map_masque.fill(255, 255, 0, 100);
  map_masque.rect(portion_w * (f - 1), 0, portion_w, portion_h);
  map_masque.endDraw();
  quelquechose_change = true;
}
