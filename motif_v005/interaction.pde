void keyPressed() {
  if ((key == 's') && (!cp5.get(Textfield.class, "fichier").isFocus())) { // enregistrer une image échelle 1
    sauverMotif();
  }
  if ((key == 'S') && (!cp5.get(Textfield.class, "fichier").isFocus())) { // enregistrer une image
    motif_image.save(repertoire + "/" + nom_fichier);
    fichier_enregistre = true;
  }
  if (key == 'f') { // enregistrer le brouillon de travail
    sauverBrouillon();
  }
  if (key == 'i') { // DEBUG pour placer les éléments
    if (DEBUG) println("x : " + mouseX + " , y : " + mouseY);
  }

  if (key == CODED) {
    if (keyCode == LEFT) changerDecalage(-1, 0);
    if (keyCode == RIGHT) changerDecalage(1, 0);
    if (keyCode == UP) changerDecalage(0, -1);
    if (keyCode == DOWN) changerDecalage(0, 1);

    if (keyCode == CONTROL) ctrlPressed = true;
    if (keyCode == ALT) altPressed = true;
  }
  if (altPressed) {
    if (key == 't') effacerMotif(0);
    if (key == 'b') effacerMotif(1);
    if (key == 'n') effacerMotif(2);
    if (key == 'E') effacerTable();
    if (key == '0') chargerImage("image0.png"); 
    if (key == '1') chargerImage("image1.png"); 
    if (key == '2') chargerImage("image2.png"); 
    if (key == '3') chargerImage("image3.png"); 
    if (key == '4') chargerImage("image4.png"); 
    if (key == '5') chargerImage("image5.png"); 
    if (key == '6') chargerImage("image6.png"); 
    if (key == '7') chargerImage("image7.png"); 
    if (key == '8') chargerImage("image8.png"); 
    if (key == '9') chargerImage("image9.png");
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == CONTROL) ctrlPressed = false;
    if (keyCode == ALT)      altPressed = false;
  }
}

void initialiserInterface() {
  cp5.addSlider("motif_largeur")
    .setPosition(xs, 12)
    .setWidth(420)
    .setRange(3, elements_x)
    .setValue(33)
    .setDecimalPrecision(1)
    .setNumberOfTickMarks(elements_x - 1)
    .snapToTickMarks(true) 
    .showTickMarks(true) 
    ;

  cp5.addSlider("motif_hauteur")
    .setPosition(xs, 32)
    .setWidth(420)
    .setRange(3, elements_y)
    .setValue(33)
    .setDecimalPrecision(1)
    .setNumberOfTickMarks(elements_y - 1)
    .snapToTickMarks(true) 
    .showTickMarks(true) 
    ;

  cp5.addSlider("repetition_echelle")
    .setPosition(xs, 52)
    .setWidth(420)
    .setRange(1, 20)
    .setValue(16)
    .setDecimalPrecision(1)
    .setNumberOfTickMarks(20)
    .snapToTickMarks(true) 
    .showTickMarks(true) 
    ;

  cp5.addTextfield("fichier")
    .setPosition(xs, 630)
    .setSize(200, 20)
    .setValue("motif_" + int(random(10)) + int(random(10)) + int(random(10)) + int(random(10)))
    .setFont(font)
    .setFocus(false)
    .setColor(color(255))
    ;
}

void controlEvent(ControlEvent theEvent) {
  quelquechose_change = true;
  fichier_enregistre = false;
}

void affichageAide() {
  int help_x = 270;
  int help_y = 632;
  fill(255);
  text("alt+t : effacer l'espace du motif",          help_x, help_y);
  text("alt+b : passer l'espace du motif en blanc",  help_x, help_y + 15);
  text("alt+n : passer l'espace du motif en noir",   help_x, help_y + 30);
  text("alt+0...9 : charger une image sur la table", help_x, help_y + 45);
  text("alt+E : effacer la table",                   help_x, help_y + 60);
  text("s : enregistrer le motif échelle 1",         help_x, help_y + 80);
  text("S : enregistrer le motif",                   help_x, help_y + 95);
  text("f : enregistrer la table de travail",        help_x, help_y + 110);
  text("flèches : déplacer la zone de dessin",       help_x, help_y + 125);
}
