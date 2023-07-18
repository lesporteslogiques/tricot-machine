/*
Une classe pour gérer les images d'annulation
*/

class Historique {
 
  ArrayList<PGraphics> maph = new ArrayList<PGraphics>();
  
  Historique() {
    //maph.add(_m);
  }
  
  void addToHistory(PGraphics _m) {
    maph.add(_m);
  }
  
  int historySize() {
    println("debug");
    return maph.size();
  }
}
