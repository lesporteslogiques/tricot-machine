void keyReleased() {
  if (key == CODED) {
    // if (keyCode == CONTROL) ctrlPressed = false; // Pas réussi à faire fonctionner CTRL ...
    if (keyCode == ALT)      altPressed = false;
    if (keyCode == SHIFT)  shiftPressed = false;
  }
}

void keyPressed() {

  if (mode != "texte" && mode != "texteX2") {
    if (key == 'h' || key == 'H') {
      help_mode = !help_mode;
      quelquechose_change = true;
    }
    if ((key == 's'|| key == 'S') && (!cp5.get(Textfield.class, "fichier").isFocus())) { // enregistrer une image échelle 1
      sauverMotif();
    }
    if (key == 'f' || key == 'F') { // enregistrer le brouillon de travail
      sauverBrouillon();
    }
  }



  if (key == CODED) {
    /*
    if (keyCode == KeyEvent.VK_CONTROL) {
      ctrlPressed = true;
      println("ctrl pressed");
    }*/
    if (keyCode == ALT)      altPressed = true;
    if (keyCode == SHIFT)  shiftPressed = true;
    if (position < 0) position = 0;
    if (position > map_w - map_w) position = map_w - map_w;
    quelquechose_change = true;
  }

  if (key == CODED) {
    if (keyCode == LEFT) changerDecalage(-1, 0);
    if (keyCode == RIGHT) changerDecalage(1, 0);
    if (keyCode == UP) changerDecalage(0, -1);
    if (keyCode == DOWN) changerDecalage(0, 1);

    //if (keyCode == CONTROL) ctrlPressed = true;
    //if (keyCode == ALT) altPressed = true;
  }

  if (altPressed) {
    //if (key == 't') effacerMotif(0);
    if (key == 'b') effacerMotif(color(255, 255));
    if (key == 'n') effacerMotif(color(0, 255));
    
    if (key == 'z') {
      int hs = historique.historySize();
      println("images dans l'historique : " + hs);
    }
  }
/*
  if (ctrlPressed) {
    println("youhou ctrl");
    if (key == 'y') {
      int hs = historique.historySize();
      println("images dans l'historique : " + hs);
    }
  }*/

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

  if (mouseButton == RIGHT) {
    index_motif ++;
    collec[collec_en_cours].updateIndex(index_motif);
  }

  println("mode : " + mode);

  if (mode == "texture") {
    if (!texture_on) {
      println("youp");
      tex_orig.set(mouseX, mouseY);
      texture_on = true;
    } else {
      println("pla");
      tex_dest.set(mouseX, mouseY);
      mapTextureTracerForme(tex_orig.x, tex_orig.y, mouseX, mouseY);
      quelquechose_change = true;
      texture_on = false;
    }
  }

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
      tampon_w = m.width;
      tampon_h = m.height;
      map.beginDraw();
      map.image(m, ox - int(m.width / 2) + position, oy - int(m.height / 2));
      map.endDraw();
      quelquechose_change = true;
    }
  }
}

void changerDecalage(int x, int y) {
  println("decalage : x " + x + " y " + y);
  if ((x < 0) && (gab_dec_x > 0)) gab_dec_x --;
  if ((x > 0) && (gab_dec_x + gab_dim_x < map_w)) gab_dec_x++;
  if ((y < 0) && (gab_dec_y > 0)) gab_dec_y --;
  if ((y > 0) && (gab_dec_y + gab_dim_y < map_h)) gab_dec_y++;
  quelquechose_change = true;
}
