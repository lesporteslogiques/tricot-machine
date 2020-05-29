void initialiser_interface() {
  
  cp5.addButton("chargerFichier")
     .setBroadcast(false)  // pour éviter que ça s'ouvre au lancement du programme
     .setValue(1)
     .setPosition(30, 60)
     .setSize(80,15)
     .setBroadcast(true)
     ;
  
  cp5.addSlider("largeur")
     .setPosition(50, 20)
     .setWidth(400)
     .setRange(2, 200)
     .setValue(200)
     .setDecimalPrecision(0)
     .setNumberOfTickMarks(100)
     .snapToTickMarks(true) 
     .showTickMarks(false) 
     ;
  
 cp5.addSlider("zoom")
     .setPosition(550, 20)
     .setWidth(320)
     .setRange(1, 32)
     .setValue(2)
     .setDecimalPrecision(0)
     .setNumberOfTickMarks(32)
     .snapToTickMarks(true) 
     ;
 
  cp5.addSlider("deformation")
     .setPosition(50, 35)
     .setWidth(150)
     .setRange(1, 2)
     .setValue(1.5)
     .setDecimalPrecision(2)
     ;
  
  cp5.addSlider("contraste")
     .setPosition(250, 410)
     .setWidth(150)
     .setRange(0, 5)
     .setValue(1)
     ;
     
  cp5.addSlider("luminosite")
     .setPosition(250, 425)
     .setWidth(150)
     .setRange(-128, 128)
     .setValue(0)
     ;
     
  cp5.addSlider("seuil")
     .setPosition(250, 440)
     .setWidth(150)
     .setRange(0, 255)
     .setValue(128)
     .setDecimalPrecision(0)
     ;
     
  cp5.addSlider("bruit")
     .setPosition(250, 455)
     .setWidth(150)
     .setRange(0, 127)
     .setValue(0)
     .setDecimalPrecision(0)
     ;
     
  cp5.addSlider("posterize")
     .setPosition(250, 470)
     .setWidth(150)
     .setRange(0, 16)
     .setValue(0)
     .setDecimalPrecision(0)
     ;

  cp5.addToggle("inversion")
     .setPosition(250, 500)
     .setSize(30,10)
     ;
     
  cp5.addRadioButton("ditherType")
     .setPosition(300,480)
     .setSize(20,10)
     .setColorForeground(color(255))
     .setColorActive(color(255))
     .setColorLabel(color(255))
     .setItemsPerRow(1)
     .setSpacingRow(5)
     .addItem("No Dither",0)
     .addItem("Floyd-Steinberg",1)
     .addItem("Atkinson",2)
     .addItem("Bayer 2x2",3)
     .addItem("Bayer 4x4",4)
     .addItem("Clustered 4x4",5)
     .addItem("Random",6)
     .addItem("Stucki",7)
     .addItem("Jarvis-Judice-Ninke",8)
     .addItem("Floyd-Steinberg Glitch",9)
     .addItem("Bayer 8x8",10)
     .addItem("False Floyd-Steinberg",11)
     .addItem("Burkes",12)
     .addItem("Sierra",13)
     .addItem("Two-Row Sierra",14)
     .addItem("Sierra Lite",15)
     .activate(0)
     ;
}

public void chargerFichier(int theValue) {
  if (DEBUG) println("a button event from chargerFichier : " + theValue);
  selectInput("Select file : ", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Fenêtre fermée ou cancel.");
  } else {
    println("fichier sélectionné : " + selection.getAbsolutePath() );
    fichier = selection.getAbsolutePath();
    initialiser_buffer_images();
    quelquechose_change = true;
  }
}

void largeur(float valeur) {
  largeur = int(valeur);
  quelquechose_change = true;
}

void zoom(float valeur) {
  zoom = valeur;
}

void deformation(float valeur) {
  deformation = valeur;
  quelquechose_change = true;
}

void contraste(float valeur) {
  contraste = valeur;
  quelquechose_change = true;
}

void luminosite(float valeur) {
  luminosite = valeur;
  quelquechose_change = true;
}

void seuil(float valeur) {
  seuil = int(valeur);
  quelquechose_change = true;
}

void bruit(float valeur) {
  bruit = int(valeur);
  quelquechose_change = true;
}

void posterize(float valeur) {
  posterize = int(valeur);
  quelquechose_change = true;
}

void inversion(boolean valeur) {
  inverse = valeur;
  /*
  if(theFlag==true) {
    col = color(255);
  } else {
    col = color(100);
  }
  println("a toggle event.");*/
  quelquechose_change = true;
}

void ditherType(int valeur) {
  dither_type = valeur;
  quelquechose_change = true;
}
