void keyPressed() {
  if ((key == 's') && (!cp5.get(Textfield.class, "fichier").isFocus())) { // enregistrer une image échelle 1
    //motif_image.save(nom_fichier);
    sauverMotif();
    //fichier_enregistre = true;
  }
  if ((key == 'S') && (!cp5.get(Textfield.class, "fichier").isFocus())) { // enregistrer une image
    motif_image.save(nom_fichier);
    fichier_enregistre = true;
  }
  if (key == 'f') { // enregistrer le brouillon de travail
    sauverBrouillon();
    //brouillon_enregistre = true;
    // fichier_enregistre = true;
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
    .setPosition(50, 20)
    .setWidth(420)
    .setRange(3, elements_x)
    .setValue(17)
    .setDecimalPrecision(1)
    .setNumberOfTickMarks(elements_x - 1)
    .snapToTickMarks(true) 
    .showTickMarks(true) 
    ;

  cp5.addSlider("motif_hauteur")
    .setPosition(50, 40)
    .setWidth(420)
    .setRange(3, elements_y)
    .setValue(17)
    .setDecimalPrecision(1)
    .setNumberOfTickMarks(elements_y - 1)
    .snapToTickMarks(true) 
    .showTickMarks(true) 
    ;

  cp5.addSlider("repetition_echelle")
    .setPosition(50, 60)
    .setWidth(420)
    .setRange(1, 20)
    .setValue(5)
    .setDecimalPrecision(1)
    .setNumberOfTickMarks(20)
    .snapToTickMarks(true) 
    .showTickMarks(true) 
    ;

  cp5.addTextfield("fichier")
    .setPosition(550, 20)
    .setSize(200, 20)
    .setValue("motif")
    .setFont(font)
    .setFocus(false)
    .setColor(color(255))
    ;
}

void controlEvent(ControlEvent theEvent) {
  quelquechose_change = true;
  fichier_enregistre = false;
}
