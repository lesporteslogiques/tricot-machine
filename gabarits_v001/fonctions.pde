// Afficher un masque gris sur les zones hors gabarit

public void gabaritMasque() {
  fill(200, 200);
  noStroke();
  rect(pos_po.x, pos_po.y, map_w * coef, gab_dec_y * coef);
  rect(pos_po.x, 
    pos_po.y + gab_dec_y * coef, 
    gab_dec_x * coef, 
    gab_dim_y * coef);
  rect(pos_po.x + (gab_dec_x + gab_dim_x) * coef, 
    pos_po.y + gab_dec_y * coef, 
    (map_w - gab_dec_x - gab_dim_x) * coef, 
    gab_dim_y * coef);
  rect(pos_po.x, 
    pos_po.y + (gab_dec_y + gab_dim_y) * coef, 
    map_w * coef, 
    (map_h - gab_dec_y - gab_dim_y) * coef);
}

// Afficher les contours du gabarit

public void gabaritContour() {
  noFill();
  stroke(255, 0, 0);
  strokeWeight(3);
  rect(pos_po.x + gab_dec_x*coef, pos_po.y + gab_dec_y*coef, gab_dim_x*coef, gab_dim_y*coef);
}

// Afficher la grille, ligne tous les 16 pixels

public void grille() {
  strokeWeight(1);
  stroke(255, 128, 0);
  for (int y = 0; y <= map_h; y+=16) {
    for (int x = 0; x <= map_w; x+=16) {
      line(pos_po.x + x * coef, pos_po.y, pos_po.x + x * coef, pos_po.y + y * coef);
    }
    line(pos_po.x, pos_po.y + y * coef, pos_po.x + map_w * coef, pos_po.y + y * coef);
  }
}

void switchCollection(int c) {
  collec_en_cours = 0;
  println("collection en cours : " + collec_en_cours + " : " + collec[collec_en_cours].nom);
}

// Curseurs adaptés au mode de dessin

void modeDessin(String mode) {
  if ( (mode == "texte") || (mode == "texteX2") ) {
    stroke(255, 0, 0);
    strokeWeight(3);
    line(px+pos_po.x, py+pos_po.y, px+pos_po.x+16, py+pos_po.y);
    line(px+pos_po.x, py+pos_po.y, px+pos_po.x, py+pos_po.y+16);
  }
  if (mode == "texture") {
    fill(255, 0, 0);
    rectMode(CENTER);
    rect(mouseX, mouseY, 3, 3);
    rectMode(CORNER);
  }
  if (mode == "pixel") {
    fill(255, 0, 0);
    rect(px + pos_po.x, py + pos_po.y, coef, coef);
  }
  for (int i = 0; i < toutes_collections.length; i++) {
    if (mode.equals(toutes_collections[i])) {
      collec[collec_en_cours].afficher(px + pos_po.x, py + pos_po.y);
    }
  }
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

void effacerMotif(color c) {
  map.beginDraw();
  map.noStroke();  
  map.fill(c);
  map.rect(gab_dec_x, gab_dec_y, gab_dim_x, gab_dim_y);
  map.endDraw();
  quelquechose_change = true;
}



// Sauver le motif à l'échelle 1
void sauverMotif() {
  motif_image_brut = createGraphics(int(gab_dim_x), int(gab_dim_y), P2D);
  motif_image_brut.loadPixels();
  motif_image_brut.beginDraw();
  motif_image_brut.copy(map, gab_dec_x, gab_dec_y, gab_dim_x, gab_dim_y, 0, 0, gab_dim_x, gab_dim_y);
  motif_image_brut.endDraw();
  motif_image_brut.save(nom_fichier_brut);
  fichier_enregistre_brut = true;
}

// Sauver le brouillon
void sauverBrouillon() {
  map.save(image_base);
  brouillon_enregistre = true;
}


public void textureTracerForme(float ox, float oy, float dx, float dy) {
  //println("tracer : " + forme_on);
  // Chercher les angles NO et SE, puis NE et SO
  PVector p1, p2, p3, p4;
  p1 = new PVector(0,0);
  p3 = new PVector(0,0);
  if (ox < dx) {
    p1.x = ox;
    p3.x = dx;
  } else {
    p1.x = dx;
    p3.x = ox;
  }
  if (oy < dy) {
    p1.y = oy;
    p3.y = dy;
  } else {
    p1.y = dy;
    p3.y = oy;
  }
  p2 = new PVector(0,0);
  p4 = new PVector(0,0);
  p2.x = p3.x;
  p2.y = p1.y;
  p4.x = p1.x;
  p4.y = p3.y;
  fill(255);
  //stroke(255,0,0);
  noStroke();
  stroke(255,0,0);
  strokeWeight(2);
  beginShape();
  texture(texcoef);
  vertex(p1.x, p1.y, 0, 0);
  vertex(p2.x, p2.y, p2.x - p1.x, 0);
  vertex(p3.x, p3.y, p2.x - p1.x, p3.y - p2.y);
  vertex(p4.x, p4.y, 0, p3.y - p2.y);
  endShape(CLOSE);
}

public void mapTextureTracerForme(float ox, float oy, float dx, float dy) {

  // Calculer la coordonnée dans l'image d'origine en fonction de la position de la souris
  ox = int((ox - pos_po.x) / coef);
  oy = int((oy - pos_po.y) / coef);
  dx = int((mouseX - pos_po.x) / coef);
  dy = int((mouseY - pos_po.y) / coef);
  
  println("ox : " + ox + " oy : " + oy + " dx : " + dx + " dy : " + dy);
  
  // Chercher les angles NO et SE, puis NE et SO
  PVector p1, p2, p3, p4;
  p1 = new PVector(0,0);
  p3 = new PVector(0,0);
  if (ox < dx) {
    p1.x = ox;
    p3.x = dx;
  } else {
    p1.x = dx;
    p3.x = ox;
  }
  if (oy < dy) {
    p1.y = oy;
    p3.y = dy;
  } else {
    p1.y = dy;
    p3.y = oy;
  }
  p2 = new PVector(0,0);
  p4 = new PVector(0,0);
  p2.x = p3.x;
  p2.y = p1.y;
  p4.x = p1.x;
  p4.y = p3.y;
  print(  "p1x : " + p1.x + " p1y : " + p1.y + " p2x : " + p2.x + " p2y : " + p2.y);
  println("p3x : " + p3.x + " p3y : " + p3.y + " p4x : " + p4.x + " p4y : " + p2.y);
  fill(255);
  //stroke(255,0,0);
  map.beginDraw();
  map.noStroke();
  map.beginShape();
  map.texture(tex);
  map.vertex(p1.x, p1.y, 0, 0);
  map.vertex(p2.x, p2.y, p2.x - p1.x, 0);
  map.vertex(p3.x, p3.y, p2.x - p1.x, p3.y - p2.y);
  map.vertex(p4.x, p4.y, 0, p3.y - p2.y);
  map.endShape(CLOSE);
  map.endDraw();
  //quelquechose_change = true;
  
}
