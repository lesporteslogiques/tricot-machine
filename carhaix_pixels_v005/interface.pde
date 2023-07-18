void initialiserInterface() {
  
  boutons[0] = cp5.addButton("texte")
     .setPosition(50,200)
     .setSize(50,20)
     .setOff() 
     ;
  boutons[1] = cp5.addButton("pixel")
     .setPosition(50,230)
     .setSize(50,20)
     .setOff() 
     ;
  boutons[2] = cp5.addButton("perso")
     .setPosition(50,260)
     .setSize(50,20)
     .setOff() 
     ;
  boutons[3] = cp5.addButton("batiment")
     .setPosition(50,290)
     .setSize(50,20)
     .setOff() 
     ;
  boutons[4] = cp5.addButton("motif")
     .setPosition(50,320)
     .setSize(50,20)
     .setOff() 
     ;
  boutons[5] = cp5.addButton("gomme")
     .setPosition(50,350)
     .setSize(50,20)
     .setOff() 
     ;

  /*
  boutons[5] = cp5.addButton("joker")
     .setPosition(50,350)
     .setSize(50,20)
     .setOff() 
     ;   
  boutons[6] = cp5.addButton("motif")
     .setPosition(50,380)
     .setSize(50,20)
     .setOff() 
     ;
  boutons[7] = cp5.addButton("tuile")
     .setPosition(50,410)
     .setSize(50,20)
     .setOff() 
     ;
  */
  
  
}

public void controlEvent(ControlEvent theEvent) {
  compteur_image = 0; // remettre le compteur à zéro
  construireIconeMotif(compteur_image);
  construireIconePerso(compteur_image);
  construireIconeBatiment(compteur_image);
  construireIconeGomme(compteur_image);
  println(theEvent.getController().getName());
  mode = theEvent.getController().getName();
  //String[] bouton = {"texte", "motif", "tuile", "pixel","perso", "batiment", "gomme"};
  for (int i = 0; i < boutons.length; i++) {
    if (boutons[i].getName() == mode) {
      boutons[i].setColorBackground(color(255,0,0));
    } else {
      boutons[i].setColorBackground(color(0,0,255));
    }
  }
}
