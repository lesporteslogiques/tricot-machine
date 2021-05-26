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
    if (position > map_w - portion_w) position = map_w - portion_w;
    quelquechose_change = true;
  }
  
  // Cadrer sur les différents parties du tricot
  if (key == '1') cadrerFragment(1);
  if (key == '2') cadrerFragment(2);
  if (key == '3') cadrerFragment(3);
  if (key == '4') cadrerFragment(4);
  if (key == '5') cadrerFragment(5);
  if (key == '6') cadrerFragment(6);
  if (key == '7') cadrerFragment(7);
  if (key == '8') cadrerFragment(8);

  // Sauver et masquer les différents parties du tricot
  if (altPressed && key == '1') sauverFragment(1);
  if (altPressed && key == '2') sauverFragment(2);
  if (altPressed && key == '3') sauverFragment(3);
  if (altPressed && key == '4') sauverFragment(4);
  if (altPressed && key == '5') sauverFragment(5);
  if (altPressed && key == '6') sauverFragment(6);
  if (altPressed && key == '7') sauverFragment(7);
  if (altPressed && key == '8') sauverFragment(8);
  
  // Sauver l'image de base (en supplément de la sauvegarde automatique) 
  if (key == 's') map.save(image_base);

  // Fonctions de texte
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
  if (sur_le_dessin && mode == "texteX2") {
    println(key + " " + keyCode);
    map.beginDraw();
    if (keyCode >= 65 && keyCode <= 90) {
      map.image(lettresX2[keyCode-65], ox + position, oy);
    }
    if (keyCode == 33)  map.image(lettresX2[26], ox + position, oy); // !
    if (keyCode == 42)  map.image(lettresX2[27], ox + position, oy); // *
    if (keyCode == 45)   map.image(lettresX2[29], ox + position, oy); // -
    if ((keyCode == 61) && shiftPressed)  map.image(lettresX2[28], ox + position, oy); // +
    if ((keyCode == 44) && shiftPressed)  map.image(lettresX2[30], ox + position, oy); // ?
    map.endDraw();
    quelquechose_change = true;
  }
  
  // Mode expert ultrafast!
  if (key == 'j') {
      collec_en_cours --;
      if (collec_en_cours < 0) collec_en_cours = collec.length - 1;
      index_motif = collec[collec_en_cours].index;
      updateBoutonVisible(collec[collec_en_cours].nom);
    }
    if (key == 'l') {
      collec_en_cours ++;
      if (collec_en_cours > collec.length - 1) collec_en_cours = 0;
      index_motif = collec[collec_en_cours].index;
      updateBoutonVisible(collec[collec_en_cours].nom);
    }
    if (key == 'i') {
      index_motif ++;
      collec[collec_en_cours].updateIndex(index_motif);
    }
    if (key == 'k') {
      index_motif --;
      if (index_motif < 0) index_motif = collec[collec_en_cours].motifs.length - 1;
      collec[collec_en_cours].updateIndex(index_motif);
    }
  
}

void mousePressed() {
/*
  // Déplacement en cliquant sur les icones "gauche" et "droite"
  if ((mouseX > 100) && (mouseX < 190) && (mouseY > 400) && (mouseY < 490)) {
    position -= 8;
    if (position < 0) position = 0;
    if (position > map_w - portion_w) position = map_w-portion_w;
    quelquechose_change = true;
  }
  if ((mouseX > 240) && (mouseX < 330) && (mouseY > 400) && (mouseY < 490)) {
    position += 8;
    if (position < 0) position = 0;
    if (position > map_w - portion_w) position = map_w - portion_w;
    quelquechose_change = true;
  }
*/
  if (mouseButton == RIGHT) {
    index_motif ++;
    collec[collec_en_cours].updateIndex(index_motif);
  }

  println("mode : " + mode);

  if (sur_le_dessin && mode == "pixel") {
    map.beginDraw();
    if (mouseButton == LEFT)  map.set(ox + position, oy, color(0));
    if (mouseButton == RIGHT) map.set(ox + position, oy, color(255));
    map.endDraw();
    quelquechose_change = true;
  }
  boolean collection_ou_pas = false;
  for (int i = 0; i < toutes_collections.length; i++) {
    if (mode.equals(toutes_collections[i])) {
      collection_ou_pas = true;
    }
  }
  if (collection_ou_pas) {
    if (sur_le_dessin && mouseButton == LEFT) {
      println("index_motif : " + index_motif);
      PImage m = collec[collec_en_cours].getMotif();
      map.beginDraw();
      map.image(m, ox - int(m.width / 2) + position, oy - int(m.height / 2));
      map.endDraw();
      quelquechose_change = true;
    }
  }
}
