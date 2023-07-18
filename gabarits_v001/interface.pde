public void initialiserInterface() {

  // Créer les boutons
  //cp5 = new ControlP5(this);
  boutons = new Button[toutes_collections.length + 4];
  for (int i = 0; i < toutes_collections.length; i++) {
    float bx = pos_bout.x;
    float by = pos_bout.y + i * 30;
    boutons[i] = cp5.addButton(toutes_collections[i]).setPosition(bx, by).setSize(50, 20).setOff();
  }

  // Bouton pour le mode pixel
  float bx = pos_bout.x;
  float by = pos_bout.y + toutes_collections.length * 30;
  boutons[toutes_collections.length] = cp5.addButton("pixel")
    .setPosition(bx, by)
    .setSize(50, 20)
    .setOff() 
    ;

  // Bouton pour le mode texte
  bx = pos_bout.x;
  by = pos_bout.y + toutes_collections.length * 30 + 30;
  boutons[toutes_collections.length + 1] = cp5.addButton("texte")
    .setPosition(bx, by)
    .setSize(50, 20)
    .setOff() 
    ;

  // Bouton pour le mode texte X2
  bx = pos_bout.x;
  by = pos_bout.y + toutes_collections.length * 30 + 60;
  boutons[toutes_collections.length + 2] = cp5.addButton("texteX2")
    .setPosition(bx, by)
    .setSize(50, 20)
    .setOff() 
    ;
    
  // Bouton pour le mode texture
  bx = pos_bout.x;
  by = pos_bout.y + toutes_collections.length * 30 + 90;
  boutons[toutes_collections.length + 3] = cp5.addButton("texture")
    .setPosition(bx, by)
    .setSize(50, 20)
    .setOff() 
    ;

  // Activer le mode pixel par défaut
  boutons[toutes_collections.length].setOn();
  boutons[toutes_collections.length].setColorBackground(color(255, 0, 0));
  mode = "pixel";
  updateBoutonVisible(mode);

  cp5.addTextfield("fichier")
    .setPosition(pos_inter.x, pos_inter.y)
    .setSize(100, 20)
    .setValue("image")
    .setFont(font)
    .setFocus(false)
    .setColor(color(255))    ;
    
  List l = tous_gabarits.getList();

  /* add a ScrollableList, by default it behaves like a DropdownList */
  cp5.addScrollableList("taille_gabarit")
    .setPosition(pos_inter.x - 200, pos_inter.y + 50)
    .setSize(100, 260)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(l)
    .setType(ScrollableList.DROPDOWN) // currently supported DROPDOWN and LIST
    .setOpen(false)
    ;
}

void taille_gabarit(int n) {
  println(n, cp5.get(ScrollableList.class, "taille_gabarit").getItem(n));
  String id = cp5.get(ScrollableList.class, "taille_gabarit").getItem(n).get("name").toString();
  println("nom : " + id);
  int[] arr = tous_gabarits.getDimensions(id);
  gab_dim_x = arr[0];
  gab_dim_y = arr[1];
  gabarit_description = tous_gabarits.getDescription(id);
  fichier_enregistre_brut = false;
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  if (theEvent.getController().getName() != "taille_gabarit") mode = theEvent.getController().getName();
  if (theEvent.getController().getName() != "texture") texture_on = false;;
  updateBoutonVisible(mode);
}

void updateBoutonVisible(String mode) {
  for (int i = 0; i < toutes_collections.length; i++) {
    if (mode.equals(toutes_collections[i])) {
      collec_en_cours = i;
      index_motif = collec[collec_en_cours].index;
      //collection_ou_pas = true;
    }
  }
  for (int i = 0; i < boutons.length; i++) {
    if (boutons[i].getName() == mode) {
      boutons[i].setColorBackground(color(255, 0, 0));
    } else {
      boutons[i].setColorBackground(color(0, 0, 255));
    }
  }
}

public void afficherInterface() {
  fill(255);

  // Afficher la taille
  text("largeur gabarit : " + gab_dim_x, pos_inter.x - 200, pos_inter.y + 10);
  text("hauteur gabarit : " + gab_dim_y, pos_inter.x - 200, pos_inter.y + 30);

  // Afficher l'état de l'enregistrement des fichiers : enregistré = rond vert, sinon croix orange devant le nom *****************
  fill(255);
  text(nom_fichier_brut, pos_inter.x, pos_inter.y + 80);
  if (fichier_enregistre_brut) {
    fill(0, 255, 0);
    text("o", pos_inter.x - 18, pos_inter.y + 80);
  } else {
    fill(255, 128, 0);
    text("x", pos_inter.x - 18, pos_inter.y + 80);
  }

  fill(255);
  text(image_base, pos_inter.x, pos_inter.y + 100);
  if (brouillon_enregistre) {
    fill(0, 255, 0);
    text("o", pos_inter.x - 18, pos_inter.y + 100);
  } else {
    fill(255, 128, 0);
    text("x", pos_inter.x - 18, pos_inter.y + 100);
  }

  fill(255);
  text("mode : " + mode, pos_inter.x, pos_inter.y + 150);
   
  fill(255);
  text("touche h : pour afficher/masquer l'aide", pos_inter.x - 200, height-50);
}

void afficherAide() {
  // Afficher les touches d'interaction
  int aide_x = 100;
  int aide_y = 100;
  fill(118, 35, 35);
  stroke(255, 255, 0);
  strokeWeight(3);
  rect( aide_x, aide_y, 680, height - aide_y - 60 ); // TODO tout parametrique
  fill(255);
  textSize(20);
  text("AIDE / Raccourcis clavier",                                 aide_x + 100, aide_y + 100);
  text("h : afficher/masquer l'aide (sauf en mode texte)",          aide_x + 100, aide_y + 180);
  text("alt+b : passer l'espace du motif en blanc ",                aide_x + 100, aide_y + 220);
  text("alt+n : passer l'espace du motif en noir",                  aide_x + 100, aide_y + 260);
  text("s : enregistrer le motif échelle 1 (sauf en mode texte)",   aide_x + 100, aide_y + 300);
  text("f : enregistrer la table de travail (sauf en mode texte)",  aide_x + 100, aide_y + 340);
  text("i,j,k,l : mode expert pour choisir les motifs",             aide_x + 100, aide_y + 380);
  text("fleches : déplacer le cadre du motif",                      aide_x + 100, aide_y + 480);
  text("blanc : couleur de fond",                                   aide_x + 100, aide_y + 580);
  text("noir : couleur de contraste",                               aide_x + 100, aide_y + 620);
  textSize(12);
}
