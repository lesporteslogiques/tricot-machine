
public void controlEvent(ControlEvent theEvent) {
  println(theEvent.getController().getName());
  mode = theEvent.getController().getName();
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
      boutons[i].setColorBackground(color(255,0,0));
    } else {
      boutons[i].setColorBackground(color(0,0,255));
    }
  }
}
