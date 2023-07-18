/*
 Classe pour charger le fichier des gabarits
 Chaque gabarit est décrit dans un objet dédié par ses dimensions et une description à afficher
 */

class GestionGabarit {

  HashMap<String, Gabarit> gabarits = new HashMap<String, Gabarit>();
  Table table_gabarits;
  String[] noms;

  GestionGabarit() {
  }

  void init() {
    table_gabarits = loadTable("gabarits.csv", "header");
    int gs = table_gabarits.getRowCount();
    noms = new String[gs];
    int cc = 0;
    for (TableRow row : table_gabarits.rows()) {
      String id = row.getString("id");
      int largeur = row.getInt("largeur");
      int hauteur = row.getInt("hauteur");
      String description = row.getString("description");
      println(id + " / " + largeur + " * " + hauteur + " : " + description);
      gabarits.put(id, new Gabarit(largeur, hauteur, description));
      noms[cc] = id;
      cc++;
    }
  }
  
  int[] getDimensions(String _id) {
    Gabarit g = gabarits.get(_id);
    return new int[] {g.largeur, g.hauteur};
  }
  
  String getDescription(String _id) {
    Gabarit g = gabarits.get(_id);
    return g.description;
  }

  List getList() {
    return Arrays.asList(noms);
  }
}

/*
 Classe pour charger le fichier des gabarits
 Chaque gabarit est décrit par ses dimensions et un nom complet à afficher
 */

class Gabarit {

  int largeur;
  int hauteur;
  String description;

  Gabarit(int _l, int _h, String _d) {
    largeur = _l;
    hauteur = _h;
    description = _d;
  }
}
