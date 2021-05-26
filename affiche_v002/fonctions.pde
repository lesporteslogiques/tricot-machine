void switchCollection(int c) {
  collec_en_cours = 0;
  println("collection en cours : " + collec_en_cours + " : " + collec[collec_en_cours].nom);
}


void modeDessin(String mode) {
  if ( (mode == "texte") || (mode == "texteX2") ) {
    stroke(255, 0, 0);
    strokeWeight(3);
    line(px+portion_x, py+portion_y, px+portion_x+16, py+portion_y);
    line(px+portion_x, py+portion_y, px+portion_x, py+portion_y+16);
  }
  if (mode == "pixel") {
    fill(255, 0, 0);
    rect(px + portion_x, py + portion_y, coef_agrandissement, coef_agrandissement);
  }
  for (int i = 0; i < toutes_collections.length; i++) {
    if (mode.equals(toutes_collections[i])) {
      collec[collec_en_cours].afficher(px + portion_x, py + portion_y);
    }
  }
}

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


void chargerTexteX2() {
  lettresX2[0] = loadImage("./data/fippsx2/A.png");
  lettresX2[1] = loadImage("./data/fippsx2/B.png");
  lettresX2[2] = loadImage("./data/fippsx2/C.png");
  lettresX2[3] = loadImage("./data/fippsx2/D.png");
  lettresX2[4] = loadImage("./data/fippsx2/E.png");
  lettresX2[5] = loadImage("./data/fippsx2/F.png");
  lettresX2[6] = loadImage("./data/fippsx2/G.png");
  lettresX2[7] = loadImage("./data/fippsx2/H.png");
  lettresX2[8] = loadImage("./data/fippsx2/I.png");
  lettresX2[9] = loadImage("./data/fippsx2/J.png");
  lettresX2[10] = loadImage("./data/fippsx2/K.png");
  lettresX2[11] = loadImage("./data/fippsx2/L.png");
  lettresX2[12] = loadImage("./data/fippsx2/M.png");
  lettresX2[13] = loadImage("./data/fippsx2/N.png");
  lettresX2[14] = loadImage("./data/fippsx2/O.png");
  lettresX2[15] = loadImage("./data/fippsx2/P.png");
  lettresX2[16] = loadImage("./data/fippsx2/Q.png");
  lettresX2[17] = loadImage("./data/fippsx2/R.png");
  lettresX2[18] = loadImage("./data/fippsx2/S.png");
  lettresX2[19] = loadImage("./data/fippsx2/T.png");
  lettresX2[20] = loadImage("./data/fippsx2/U.png");
  lettresX2[21] = loadImage("./data/fippsx2/V.png");
  lettresX2[22] = loadImage("./data/fippsx2/W.png");
  lettresX2[23] = loadImage("./data/fippsx2/X.png");
  lettresX2[24] = loadImage("./data/fippsx2/Y.png");
  lettresX2[25] = loadImage("./data/fippsx2/Z.png");
  
  lettresX2[26] = loadImage("./data/fippsx2/(exclamation).png");
  lettresX2[27] = loadImage("./data/fippsx2/(asterisque).png");
  lettresX2[28] = loadImage("./data/fippsx2/(plus).png");
  lettresX2[29] = loadImage("./data/fippsx2/(moins).png");
  lettresX2[30] = loadImage("./data/fippsx2/(interrogation).png");
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
  in.updatePixels();
  
  return out;
}

void cadrerFragment(int f) {
  position = portion_w * (f-1);
  if (position < 0) position = 0;
  if (position > map_w - portion_w) position = map_w - portion_w;
  quelquechose_change = true;
}

void sauverFragment(int f) {
  println("fragment " + f + " à sauver");
  PGraphics fragment = createGraphics(portion_h, portion_w);
  fragment.loadPixels();
  int xorig = portion_w * (f - 1);
  int xfin = portion_w * f;
  if (xfin > map_w) {
    println("glups, impossible de sauver le fragment " + f + " xfin : " + xfin + " map_w : " + map_w);
  } else {
    fragment.beginDraw();
    fragment.pushMatrix();
    fragment.translate(0, portion_w);
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

}
