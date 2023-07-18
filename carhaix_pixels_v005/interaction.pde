void keyReleased() {
  if (key == CODED) {
    if (keyCode == CONTROL) ctrlPressed = false;
    if (keyCode == ALT)      altPressed = false;
    if (keyCode == SHIFT)  shiftPressed = false;
  }
}

void keyPressed() {
 
  if (key == CODED) {
    if (keyCode == CONTROL) ctrlPressed = true;
    if (keyCode == ALT)      altPressed = true;
    if (keyCode == SHIFT)  shiftPressed = true;
    if (keyCode == LEFT) position -= 8;
    if (keyCode == RIGHT) position += 8;
    if (position < 0) position = 0;
    if (position > 1280-portion_w) position = 1280-portion_w;
    quelquechose_change = true;
  }
  // cadrer sur les différents parties du tricot
  if (key == '1') cadrerFragment(1);
  if (key == '2') cadrerFragment(2);
  if (key == '3') cadrerFragment(3);
  if (key == '4') cadrerFragment(4);
  if (key == '5') cadrerFragment(5);
  if (key == '6') cadrerFragment(6);
  if (key == '7') cadrerFragment(7);
  if (key == '8') cadrerFragment(8);
  
  // sauver et masquer les différents parties du tricot
  if (altPressed && key == '1') sauverFragment(1);
  if (altPressed && key == '2') sauverFragment(2);
  if (altPressed && key == '3') sauverFragment(3);
  if (altPressed && key == '4') sauverFragment(4);
  if (altPressed && key == '5') sauverFragment(5);
  if (altPressed && key == '6') sauverFragment(6);
  if (altPressed && key == '7') sauverFragment(7);
  if (altPressed && key == '8') sauverFragment(8);
  /*
  if (key == ' ') {
    compteur_image ++;
    construireIconeMotif(compteur_image);
    construireIconePerso(compteur_image);
    construireIconeBatiment(compteur_image);
    construireIconeGomme(compteur_image);
  }*/
  if (key == 's') map.save(image_base);
  /*
  if (key == 't') {
    boutons[0].setOn();
    println(boutons[0].isOn());
  }*/
  if (key == 'g') println("gloup");
  
  if (sur_le_dessin && mode == "texte") {
    println(key + " " + keyCode);
    map.beginDraw();
    if (keyCode >= 65 && keyCode <= 90) {
      map.image(lettres[keyCode-65], ox + position, oy);
    }
    if (keyCode == 33)  map.image(lettres[26], ox + position, oy); // !
    if (keyCode == 42)  map.image(lettres[27], ox + position, oy); // *
    if (keyCode == 45)   map.image(lettres[29], ox + position, oy); // -
    if ((keyCode == 61) && shiftPressed)  map.image(lettres[28], ox + position, oy); // +
    if ((keyCode == 44) && shiftPressed)  map.image(lettres[30], ox + position, oy); // ?
    map.endDraw();
    quelquechose_change = true;
  }
}

void mousePressed() {
  
  if ((mouseX > 20) && (mouseX < 110) && (mouseY > 400) && (mouseY < 490)) {
    position -= 8;
    if (position < 0) position = 0;
    if (position > 1280-portion_w) position = 1280-portion_w;
    quelquechose_change = true;
  }
  if ((mouseX > 120) && (mouseX < 210) && (mouseY > 400) && (mouseY < 490)) {
    position += 8;
    if (position < 0) position = 0;
    if (position > 1280-portion_w) position = 1280-portion_w;
    quelquechose_change = true;
  }
  
  if (mouseButton == RIGHT) {
    compteur_image ++;
    construireIconeMotif(compteur_image);
    construireIconePerso(compteur_image);
    construireIconeBatiment(compteur_image);
    construireIconeGomme(compteur_image);
    if (mode.equals("motif") == true) {
       int cc = compteur_image%motifs.length;
       motif_w = motifs[cc].width;
       motif_h = motifs[cc].height;
    }
    if (mode.equals("perso") == true) {
       int cc = compteur_image%persos.length;
       motif_w = persos[cc].width;
       motif_h = persos[cc].height;
    }
    if (mode.equals("batiment") == true) {
       int cc = compteur_image%batiments.length;
       motif_w = batiments[cc].width;
       motif_h = batiments[cc].height;
    }
    if (mode.equals("gomme") == true) {
       int cc = compteur_image%gommes.length;
       motif_w = gommes[cc].width;
       motif_h = gommes[cc].height;
    }
    println("motif_w : " + motif_w + " / motif_h : " + motif_h);
  }
  
  println("mode : " + mode);
  /*
  if (sur_le_dessin && mode == "pixel") {
    map.beginDraw();
    if (mouseButton == LEFT)  map.set(ox + position, oy, color(0));
    if (mouseButton == RIGHT) map.set(ox + position, oy, color(255));
    map.endDraw();
    quelquechose_change = true;
  }*/

  if (sur_le_dessin && mode == "motif" && mouseButton == LEFT) {
    println("compteur_image : " + compteur_image);
    int cc = compteur_image%motifs.length;
    map.beginDraw();
    map.image(motifs[cc], ox - int(motifs[cc].width / 2) + position, oy - int(motifs[cc].height / 2));
    map.endDraw();
    quelquechose_change = true;
  }
  
  if (sur_le_dessin && mode == "perso" && mouseButton == LEFT) {
    println("compteur_image : " + compteur_image);
    int cc = compteur_image%persos.length;
    map.beginDraw();
    map.image(persos[cc], ox - int(persos[cc].width / 2) + position, oy - int(persos[cc].height / 2));
    map.endDraw();
    quelquechose_change = true;
  }
  
  if (sur_le_dessin && mode == "batiment" && mouseButton == LEFT) {
    println("compteur_image : " + compteur_image);
    int cc = compteur_image%batiments.length;
    map.beginDraw();
    map.image(batiments[cc], ox - int(batiments[cc].width / 2) + position, oy - int(batiments[cc].height / 2));
    map.endDraw();
    quelquechose_change = true;
  }
  
  if (sur_le_dessin && mode == "gomme" && mouseButton == LEFT) {
    println("compteur_image : " + compteur_image);
    int cc = compteur_image%gommes.length;
    map.beginDraw();
    map.image(gommes[cc], ox - int(gommes[cc].width / 2) + position, oy - int(gommes[cc].height / 2));
    map.endDraw();
    quelquechose_change = true;
  }
}
