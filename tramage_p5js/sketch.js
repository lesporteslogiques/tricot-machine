/* Tramage d'image pour produire des images adaptées au tricot machine :
 *   - 200 mailles (=pixels) de large maximum
 *   - noir et blanc 1-bit, format PNG
 * 
 *   Quimper, Dour Ru, 11 avril 2020
 *   Pierre Commenge / pierre@lesporteslogiques.net
 *   (Basé sur la version java : sk_20180905_tricot_dither_008.pde)
 * 
 * p5.js version 1.0.0
 *   + lib. quicksettings.js 3.0.2  https://github.com/bit101/quicksettings  http://bit101.github.io/quicksettings/doc/module-QuickSettings.html
 * 
 * version 007 : une sorte de beta
 * 
 * TODO
 *   ajouter une chaine de caractères bien formatée pour l'enregistrement de fichiers (pour l'instant c'est un timestamp)
 *   vérifier que le png qui sort est bien 1-bit... (et fonctionne correctement dans knittington)
 *   pourquoi est ce qu'il n'y a jamais de blanc dans les ordered dithers ?
 *   OK hauteur de l'image originale à adapter
 *   ajouter des champs number pour les 4 params de Floyd Steinberg Glitch + resset (peut-être un autre panel)
 * 
 * NOTES
 *   l'upload d'images m'a donné beaucoup de fil à retordre, la solution utilisée avec un compteur temporaire a été mise en place
 *     car les le buffer d'image n'était pas accessible même après l'utilisation d'un callback avec loadImage 
 *     cf. https://github.com/processing/p5.js/issues/3117 
 */

var DEBUG = true;

// buffers d'images
// imgo -> imgr -> imgd -> imgm -> imgmgf

let cmp = -1;            // compteur utilisé pour le buffer temporaire imgt
let imgt;                // buffer temporaire
let imgo;                // image originale
let imgn;                // image negatif
let imgd;                // image déformée
let imgr;                // image retouchée
let imgm;                // image moirée
let imgmgf;              // image moirée grand format SANS interpolation

// paramètres de manipulation d'image

var contraste   = 1;     // actif sur imgr
var luminosite  = 0;     // actif sur imgr
var bruit       = 0;     // actif sur imgr
var inversion   = false; // actif sur imgr
var posterize   = 0;     // actif sur imgd
var largeur     = 200;   // actif sur imgd
var deformation = 1.5;   // actif sur imgd
var seuil       = 128;   // actif sur imgm
var algo        = "";    // actif sur imgm
var zoom        = 1;     // actif sur imgm grand format

// algorithmes de dithering

var algorithme = [];           
algorithme['no-dither']              =  0;
algorithme['floyd-steinberg']        =  1;
algorithme['floyd-steinberg glitch'] =  2;
algorithme['false floyd-steinberg']  =  3;
algorithme['bayer 2x2']              =  4;
algorithme['bayer 4x4']              =  5;
algorithme['bayer 8x8']              =  6;
algorithme['clustered 4x4']          =  7;
algorithme['random']                 =  8;
algorithme['stucki']                 =  9;
algorithme['jarvis-judice-ninke']    = 10;
algorithme['burkes']                 = 11;
algorithme['sierra']                 = 12;
algorithme['two row sierra']         = 13;
algorithme['sierra lite']            = 14;
algorithme['atkinson']               = 15;

algo = "no-dither";
var dither_type = algorithme[algo];

// déclencheurs de recalcul

var imgo_recalcul   = true;  // nouvelle image originale
var imgr_recalcul   = true;
var imgd_recalcul   = true;
var imgm_recalcul   = true;
var imgmgf_recalcul = true;

// interface graphique

let gui;           // plaette flottante quicksettings pour les réglages
let guihelp;       // palette flottante quicksettings pour les infos
let input;         // bouton d'upload de fichier
let bgc = 180;     // couleur de fond

// Tableau à deux dimensions contenant une valeur pour chaque pixel, plus économe que le type 'color'

var pix;



function preload() {
  let rr = int(random(100));
  if (rr < 14)             imgo = loadImage("data/einstein.jpg");
  if (rr >= 14 && rr < 28) imgo = loadImage("data/banane.jpg");
  if (rr >= 28 && rr < 42) imgo = loadImage("data/lion.jpg");
  if (rr >= 42 && rr < 56) imgo = loadImage("data/panda.jpg");
  if (rr >= 56 && rr < 70) imgo = loadImage("data/tigre.jpg");
  if (rr >= 70 && rr < 84) imgo = loadImage("data/aphrodite.png");
  if (rr >= 84)            imgo = loadImage("data/thetrip.png");
}

function setup() {
  const c = createCanvas(windowWidth,windowHeight);
  pixelDensity(1)
  frameRate(25);
  fill(0);
  background(bgc);
  textSize(36);
  
  // variables pour l'upload d'image (par bouton ou drop de fichier)
  input = createFileInput(handleFile);
  input.position(0, 600);
  c.drop(gotFile);
  
  // palette flottante pour les réglages 
  gui = QuickSettings.create(windowWidth - 300, 50, "moirage (afficher/masquer : m)");
  gui.setDraggable(true);
  gui.setCollapsible(true);
  gui.setWidth(250);
  gui.addRange("largeur (en mailles)", 2, 200, largeur, 1, function(value) {imgd_recalcul = true; largeur = value; console.log("largeur " + largeur); redraw();});
  gui.addRange("deformation", 1, 2, deformation, 0.02, function(value) {imgd_recalcul = true; deformation = value; console.log("deformation " + deformation); redraw();});
  gui.addRange("zoom", 1, 10, zoom, 1, function(value) {imgmgf_recalcul = true; zoom = value; console.log("zoom " + zoom); redraw();});
  gui.addRange("contraste", 0, 5, contraste, 0.1, function(value) {imgr_recalcul = true; contraste = value; console.log("contraste " + contraste); redraw();});
  gui.addRange("luminosite", -128, 128, luminosite, 0.1, function(value) {imgr_recalcul = true; luminosite = value; console.log("luminosite " + luminosite); redraw();});
  gui.addRange("seuil", 0, 255, seuil, 1, function(value) {imgd_recalcul = true; seuil = value; console.log("seuil " + seuil); redraw();});
  gui.addRange("bruit", 0, 127, bruit, 1, function(value) {imgr_recalcul = true; bruit = value; console.log("bruit " + bruit); redraw();});
  gui.addRange("posterize", 0, 16, posterize, 1, function(value) {imgd_recalcul = true; posterize = value; console.log("posterize " + posterize); redraw();});
  gui.addBoolean("inversion", inversion, function(value) {imgr_recalcul = true; inversion = value; console.log("inversion " + inversion); redraw();});
  gui.addDropDown("algorithme", ['no-dither', 'floyd-steinberg', 'floyd-steinberg glitch', 'false floyd-steinberg', 'bayer 2x2',
             'bayer 4x4', 'bayer 8x8', 'clustered 4x4', 'random', 'stucki', 'jarvis-judice-ninke', 'burkes',
             'sierra', 'two row sierra', 'sierra lite', 'atkinson'], function(value) {imgd_recalcul = true; algo = value.value; console.log("algo " + algo); redraw();});  
  gui.setKey('m'); // pour masquer / afficher les paramètres
  
  // palette flottante d'aide & infos
  guihelp = QuickSettings.create((windowWidth - 600) / 2, windowHeight - 350, "aide (afficher/masquer avec la touche 'h')");
  guihelp.setDraggable(true);
  guihelp.setWidth(600);
  guihelp.addHTML("Application de tramage d'images pour machine à tricoter électronique","");
  guihelp.addHTML("interaction", "touche 's' : enregistrer en PNG 1-bit l'image en petit format (pour machine à tricoter)<br>touche 'g' : enregistrer en PNG 1-bit l'image en grand format (zoom)<br> envoi de fichier par glisser déposer ou par le bouton");
  guihelp.addHTML("licence", "GNU-GPL v3 : 2020, Pierre Commenge, pierre @ lesporteslogiques.net <a href='https://github.com/lesporteslogiques/tricot-machine'>code</a>");
  guihelp.addHTML("version", "beta 20200412 : certains tramages ne sont pas tout à fait au point + à tester en profondeur");
  guihelp.setKey('h'); // pour masquer / afficher les paramètres
  
  //noLoop();
}

function draw() {
  
  // Une nouvelle image a t'elle été uploadée ?
  // alors on attend un peu avant de la traiter (magie noire)
  cmp --;
  
  if (cmp == 0) {
    console.log("imgt :::: " + imgt.width + " " + imgt.height);
    //imgo = imgt;
    let iw;
    let ih;
    if (imgt.width <= 200) {
      iw = imgt.width;
      ih = imgt.height;
    } else {
      iw = 200;
      ih = int(imgt.height / (imgt.width / 200));
    }
    imgo = createImage(iw, ih);
    imgo.copy(imgt, 0, 0, imgt.width, imgt.height, 0, 0, iw, ih); 
    imgo_recalcul = true;
    imgr_recalcul = true;
  }
  
  // Préparer les déclencheurs en cascade!
  if (imgo_recalcul) {
    imgr_recalcul   = true;
    imgd_recalcul   = true;
    imgm_recalcul   = true;
    imgmgf_recalcul = true;
  }
  if (imgr_recalcul) {
    imgd_recalcul   = true;
    imgm_recalcul   = true;
    imgmgf_recalcul = true;
  }
  if (imgd_recalcul) {
    imgm_recalcul   = true;
    imgmgf_recalcul = true;
  }
  if (imgm_recalcul) {
    imgmgf_recalcul = true;
  }
  
  // Changement de l'image originale
  
  if (imgo_recalcul) {

    imgo_recalcul = false;
    
    image(imgo, 0, 0, imgo.width, imgo.height);
  }
  
  
  // Changement de l'image retouchée
  
  if (imgr_recalcul) {
    
    imgr = createImage(imgo.width, imgo.height);
    
    if (DEBUG) console.log("232 imgo " + imgo.width + ", " + imgo.height);
    if (DEBUG) console.log("232 imgr " + imgr.width + ", " + imgr.height);
    
    imgr.loadPixels();
    imgo.loadPixels();
    
    for (let y = 0; y < imgo.height; y++) {
      for (let x = 0; x < imgo.width; x++) {

        let p = (imgo.width * y + x) * 4;
        let r = imgo.pixels[p];
        let v = imgo.pixels[p+1];
        let b = imgo.pixels[p+2];
        
        // appliquer contraste et luminosite
        let hasard = random(-bruit, bruit)
        r = r * contraste + luminosite + hasard;
        v = v * contraste + luminosite + hasard;
        b = b * contraste + luminosite + hasard;
        
        // tester si on sort des limites, 
        r = r < 0 ? 0 : r > 255 ? 255 : r;
        v = v < 0 ? 0 : v > 255 ? 255 : v;
        b = b < 0 ? 0 : b > 255 ? 255 : b;
        
        imgr.pixels[p]   = r;
        imgr.pixels[p+1] = v;
        imgr.pixels[p+2] = b;
        imgr.pixels[p+3] = 255;
      }
    }
    imgo.updatePixels();
    imgr.updatePixels();
    if (inversion) imgr.filter(INVERT);
    imgr_recalcul = false;  
    
    image(imgr, 0 , imgo.height, imgr.width, imgr.height);
  }
   
  if (imgd_recalcul) {

    let w = largeur;
    let h = int(imgr.height * deformation * (largeur / 200) );
    
    imgd = createImage(w, h);
    imgd.copy(imgr, 0, 0, imgr.width, imgr.height, 0, 0, imgd.width, imgd.height);
    if (posterize >= 3) imgd.filter(POSTERIZE, int(posterize));
    
    // Création du tableau 2D pix qui sera utilsié plus tard pour calculer les ditherings
    pix = new Array(imgd.width);
    for (var i = 0; i < pix.length; i++) {
      pix[i] = new Array(imgd.height);
    }
    
    if (DEBUG) console.log("dimensions du tableau pix : x :" + w + " , y : " + h);
    
    imgd.loadPixels();
    for (let y = 0; y < imgd.height; y++) {
      for (let x = 0; x < imgd.width; x++) {
        let p = (imgd.width * y + x) * 4;
        let c = imgd.pixels[p];
        //if (x%50 == 0) console.log(c);
        pix[x][y] = c;
      }
    }
    imgd.updatePixels();
    
    imgd_recalcul = false;  
    
    fill(bgc);
    noStroke();
    rect(imgo.width, 0, imgr.width, 500);
    image(imgd, imgo.width , 0, imgd.width, imgd.height);
  }
   
  if (imgm_recalcul) {
    
    dither_type = algorithme[algo];
    if (DEBUG) console.log("dither_type : " + dither_type);
    
    imgm = createImage(imgd.width, imgd.height);
    calculerDither();
    imgm_recalcul = false;  
    
    fill(bgc);
    noStroke();
    rect(imgo.width * 2, 0, imgr.width, 500);
    image(imgm, imgo.width * 2 , 0, imgm.width, imgm.height);
  }
  
  if (imgmgf_recalcul) {       
    imgmgf = createGraphics(int(imgm.width * zoom), int(imgm.height * zoom));
    
    // agrandir SANS interpolation
    imgm.loadPixels();
    imgmgf.loadPixels();
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let p = (imgm.width * y + x) * 4; // index du pixel dans le tableau de pixels de l'image original
        let r = imgm.pixels[p];
        let v = imgm.pixels[p+1];
        let b = imgm.pixels[p+2];
        let a = imgm.pixels[p+3];
        let pp = (imgmgf.width * y * zoom + (x * zoom)) * 4; // index du pixel de départ dans le tableau de pixels de l'image agrandie
        for (let yc = 0; yc < zoom; yc ++) {
          let pc = pp + (imgmgf.width * yc * 4);
          for (let xc = 0; xc < zoom; xc ++) {
            let xd = pc + xc * 4;
            imgmgf.pixels[xd]   = r;
            imgmgf.pixels[xd+1] = v;
            imgmgf.pixels[xd+2] = b;
            imgmgf.pixels[xd+3] = a;
          }
        }
      }
    } 
    imgmgf.updatePixels();
    imgm.updatePixels();
       
    imgmgf_recalcul = false; 
    
    fill(bgc);
    noStroke();
    rect(imgo.width * 3, 0, windowWidth - imgd.width * 3, windowHeight);
    image(imgmgf, imgo.width * 3 , 0, imgmgf.width, imgmgf.height);
  }

  //noLoop();
}

function handleFile(file) {
  if (file.type === 'image') {
    imgt = loadImage(file.data, () => { image(imgt, 0, 0, width, height); background(bgc); } );
    cmp = 30;
    redraw();
  }
}

function gotFile(file) {
  if (file.type === 'image') {
    imgt = loadImage(file.data, () => { image(imgt, 0, 0, width, height); background(bgc); } );
    cmp = 30;
    redraw();
  } else {
    console.log('Not an image file!');
  }
}

function windowResized() {
  resizeCanvas(windowWidth, windowHeight);
  background(bgc);
  imgo_recalcul = true;
}

function setPix(x, y, v) {
  if (x >= 0 && x < imgm.width && y >= 0 && y < imgm.height) {
    let r = pix[x][y]; 
    r += int(v);
    r = constrain(r, 0, 255);
    pix[x][y] = r;
  }
}

    /*
    algorithme['no-dither']              =  0;
    algorithme['floyd-steinberg']        =  1;
    algorithme['floyd-steinberg glitch'] =  2;
    algorithme['false floyd-steinberg']  =  3;
    algorithme['bayer 2x2']              =  4;
    algorithme['bayer 4x4']              =  5;
    algorithme['bayer 8x8']              =  6;
    algorithme['clustered 4x4']          =  7;
    algorithme['random']                 =  8;
    algorithme['stucki']                 =  9;
    algorithme['jarvis-judice-ninke']    = 10;
    algorithme['burkes']                 = 11;
    algorithme['sierra']                 = 12;
    algorithme['two row sierra']         = 13;
    algorithme['sierra lite']            = 14;
    algorithme['atkinson']               = 15;
  */

function calculerDither() {

  if (DEBUG) console.log("calculerDither : imgd : " + imgd.width + "," + imgd.height + ", imgm : " + imgm.width + "," + imgm.height); 

  imgm.loadPixels();
  
  if (dither_type == 0) {  // ****************** no-dither (seuil seulement)
    
    if (DEBUG) console.log("Appliquer no-dither , seuil uniquement");
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y];
        if (r > seuil) {
          imgm.pixels[i] = 255; 
          imgm.pixels[i+1] = 255;
          imgm.pixels[i+2] = 255;
          imgm.pixels[i+3] = 255;
        } else {
          imgm.pixels[i] = 0; 
          imgm.pixels[i+1] = 0; 
          imgm.pixels[i+2] = 0; 
          imgm.pixels[i+3] = 255;
        }
      }
    } 
    
    
  } else if (dither_type == 1) {   // ********** floyd-steinberg
    
    if (DEBUG) console.log("Appliquer dither Floyd Steinberg");
    
    let w1 = 7.0/16.0;
    let w2 = 3.0/16.0;
    let w3 = 5.0/16.0;
    let w4 = 1.0/16.0;
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i]   = cm; 
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        let quant_error = r - cm;
        /*if (DEBUG && i%777 == 0) {
          console.log("QE : " + quant_error + " " + w1 * quant_error + " " + w2 * quant_error);
        }*/
        setPix(x+1, y,   w1 * quant_error);
        setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w3 * quant_error);
        setPix(x+1, y+1, w4 * quant_error);
        //color cd = getColor(x+1, y, w1 * quant_error, imgd);
      }
    }
    
  } else if (dither_type == 2) {   // ********** floyd-steinberg glitch
    
    if (DEBUG) console.log("Appliquer dither Floyd Steinberg Glitch");
    
    let w1 = 6.0/16.0;
    let w2 = 6.0/16.0;
    let w3 = 6.0/16.0;
    let w4 = 6.0/16.0;
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        let quant_error = r - cm;
        /*if (DEBUG && i%777 == 0) {
          println("QE : " + quant_error + " " + w1 * quant_error + " " + w2 * quant_error);
        }*/
        setPix(x+1, y,   w1 * quant_error);
        setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w3 * quant_error);
        setPix(x+1, y+1, w4 * quant_error);
        //color cd = getColor(x+1, y, w1 * quant_error, imgd);
      }
    }
    
  } else if (dither_type == 3) { // TODO ne fonctionne pas
    
    if (DEBUG) console.log("Appliquer dither false floyd-steinberg");
    
    let w1 = 3.0/8.0;
    //float w2 = 3.0/16.0;
    let w3 = 3.0/8.0;
    let w4 = 2.0/8.0;
    
     for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        let quant_error = r - cm;

        setPix(x+1, y,   w1 * quant_error);
        // setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w3 * quant_error);
        setPix(x+1, y+1, w4 * quant_error);
      }
    }
    
  } else if (dither_type == 4) {
    
    if (DEBUG) console.log("Appliquer dither bayer 2x2");
    
    let coefficients = [2, 3, 4, 1];
                          
    for (let i = 0; i < coefficients.length; i++) {
      coefficients[i] = coefficients[i] * 64.0 - 1.0; // TODO
    }
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        let index = y%2 * 2 + x%2;
        if (r > coefficients[index]) cm = 255;
        else cm = 0;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;

      }
    }
    
  } else if (dither_type == 5) {
    
    if (DEBUG) console.log("Appliquer dither bayer 4x4");
    
    let coefficients = [0.1250, 1.0000, 0.1875, 0.8125, 
                        0.6250, 0.3750, 0.6875, 0.4375,
                        0.2500, 0.8750, 0.0625, 0.9375,
                        0.7500, 0.5000, 0.5625, 0.3125];
                          
    for (let i = 0; i < coefficients.length; i++) {
      coefficients[i] = coefficients[i] * 255.0;    // TODO 
    }
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        let index = y%4 * 4 + x%4;
        if (r > coefficients[index]) cm = 255;
        else cm = 0;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;

      }
    }
    
  } else if (dither_type == 6) {
    
    if (DEBUG) console.log("Appliquer dither bayer 8x8");
    
    let coefficients = [ 1, 33,  9, 41, 3,  35, 11, 43, 
                        49, 17, 57, 25, 51, 19, 59, 27, 
                        13, 45,  5, 37, 15, 47,  7, 39, 
                        61, 29, 53, 21, 63, 31, 55, 23,
                         4, 36, 12, 44,  2, 34, 10, 42, 
                        52, 20, 60, 28, 50, 18, 58, 26, 
                        16, 48,  8, 40, 14, 46,  6, 38, 
                        64, 32, 56, 24, 62, 30, 54, 22 ];
                              
    for (let i = 0; i < coefficients.length; i++) {
      coefficients[i] = coefficients[i] * 4.0 - 1.0;    // TODO 
    }
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        let index = y%8 * 8 + x%8;
        if (r > coefficients[index]) cm = 255;
        else cm = 0;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;

      }
    }
    
  } else if (dither_type == 7) {
    
    if (DEBUG) console.log("Appliquer dither clustered 4x4");
    
    let coefficients = [0.7500, 0.3750, 0.6250, 0.2500, 
                        0.0625, 1.0000, 0.8750, 0.4375,
                        0.5000, 0.8125, 0.9375, 0.1250,
                        0.1875, 0.5625, 0.3125, 0.6875];
      
    for (let i = 0; i < coefficients.length; i++) {
      coefficients[i] = coefficients[i] * 255.0;    // TODO 
    }
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        let index = y%4 * 4 + x%4;
        if (r > coefficients[index]) cm = 255;
        else cm = 0;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;

      }
    }
    
  } else if (dither_type == 8) {
    
    if (DEBUG) console.log("Appliquer dither random");
        
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r > random(255)) cm = 255;
        else cm = 0;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;

      }
    }
     
  } else if (dither_type == 9) {
    
    if (DEBUG) console.log("Appliquer dither stucki");
    
    let w1 = 1.0/42.0;
    let w2 = 2.0/42.0;
    let w4 = 4.0/42.0;
    let w5 = 5.0/42.0;
    let w7 = 7.0/42.0;
    let w8 = 8.0/42.0;
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        
        let quant_error = r - cm;
        setPix(x+1, y,   w7 * quant_error);
        setPix(x+2, y,   w5 * quant_error);
        setPix(x-2, y+1, w2 * quant_error);
        setPix(x-1, y+1, w4 * quant_error);
        setPix(x,   y+1, w8 * quant_error);
        setPix(x+1, y+1, w4 * quant_error);
        setPix(x+2, y+1, w2 * quant_error);
        setPix(x-2, y+2, w1 * quant_error);
        setPix(x-1, y+2, w2 * quant_error);
        setPix(x,   y+2, w4 * quant_error);
        setPix(x+1, y+2, w2 * quant_error);
        setPix(x+2, y+2, w1 * quant_error);
      }
    }
    
  } else if (dither_type == 10) {
    
    if (DEBUG) console.log("Appliquer dither jarvis-judice-ninke");
    
    let w1 = 1.0/48.0;
    let w3 = 3.0/48.0;
    let w5 = 5.0/48.0;
    let w7 = 7.0/48.0;
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        
        let quant_error = r - cm;
        setPix(x+1, y,   w7 * quant_error);
        setPix(x+2, y,   w5 * quant_error);
        setPix(x-2, y+1, w3 * quant_error);
        setPix(x-1, y+1, w5 * quant_error);
        setPix(x,   y+1, w7 * quant_error);
        setPix(x+1, y+1, w5 * quant_error);
        setPix(x+2, y+1, w3 * quant_error);
        setPix(x-2, y+2, w1 * quant_error);
        setPix(x-1, y+2, w3 * quant_error);
        setPix(x,   y+2, w5 * quant_error);
        setPix(x+1, y+2, w3 * quant_error);
        setPix(x+2, y+2, w1 * quant_error);
      }
    }
    
  } else if (dither_type == 11) {
    
    if (DEBUG) console.log("Appliquer dither burkes");
    
    let w1 = 8.0/32.0;
    let w2 = 4.0/32.0;
    let w3 = 2.0/32.0;
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        
        let quant_error = r - cm;
        setPix(x+1, y,   w1 * quant_error);
        setPix(x+2, y,   w2 * quant_error);
        setPix(x-2, y+1, w3 * quant_error);
        setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w1 * quant_error);
        setPix(x+1, y+1, w2 * quant_error);
        setPix(x+2, y+1, w3 * quant_error);
      }
    }
    
  } else if (dither_type == 12) {
    
    if (DEBUG) console.log("Appliquer dither sierra");
    
    let w1 = 5.0/32.0;
    let w2 = 3.0/32.0;
    let w3 = 2.0/32.0;
    let w4 = 4.0/32.0;
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        
        let quant_error = r - cm;
        setPix(x+1, y,   w1 * quant_error);
        setPix(x+2, y,   w2 * quant_error);
        setPix(x-2, y+1, w3 * quant_error);
        setPix(x-1, y+1, w4 * quant_error);
        setPix(x,   y+1, w1 * quant_error);
        setPix(x+1, y+1, w4 * quant_error);
        setPix(x+2, y+1, w3 * quant_error);
        setPix(x-1, y+2, w3 * quant_error);
        setPix(x,   y+2, w2 * quant_error);
        setPix(x-1, y+2, w3 * quant_error);
      }
    }
    
  } else if (dither_type == 13) {
    
    if (DEBUG) console.log("Appliquer dither two-row sierra");
    
    let w1 = 1.0/16.0;
    let w2 = 2.0/16.0;
    let w3 = 3.0/16.0;
    let w4 = 4.0/16.0;
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        
        let quant_error = r - cm;
        setPix(x+1, y,   w4 * quant_error);
        setPix(x+2, y,   w3 * quant_error);
        setPix(x-2, y+1, w1 * quant_error);
        setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w3 * quant_error);
        setPix(x+1, y+1, w2 * quant_error);
        setPix(x+2, y+1, w1 * quant_error);
      }
    }
    
  } else if (dither_type == 14) {
    
    if (DEBUG) console.log("Appliquer dither sierra lite");
    
    let w1 = 1.0/4.0;
    let w2 = 2.0/4.0;
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        
        let quant_error = r - cm;
        setPix(x+1, y,   w2 * quant_error);
        setPix(x-1, y+1, w1 * quant_error);
        setPix(x,   y+1, w1 * quant_error);
      }
    }
    
  } else if (dither_type == 15) {
    
    if (DEBUG) console.log("Appliquer dither atkinson");
    
    let w1 = 1.0/8.0;
    
    for (let y = 0; y < imgm.height; y++) {
      for (let x = 0; x < imgm.width; x++) {
        let i = (imgm.width * y + x) * 4;
        let r = pix[x][y]; 
        let cm;
        if (r < seuil) cm = 0;
        else cm = 255;
        imgm.pixels[i] = cm;
        imgm.pixels[i+1] = cm;
        imgm.pixels[i+2] = cm;
        imgm.pixels[i+3] = 255;
        
        let quant_error = r - cm;
        setPix(x+1, y,   w1 * quant_error);
        setPix(x+2, y,   w1 * quant_error);
        setPix(x-1, y+1, w1 * quant_error);
        setPix(x,   y+1, w1 * quant_error);
        setPix(x+1, y+1, w1 * quant_error);
        setPix(x,   y+2, w1 * quant_error);
      }
    }
    
  }

  imgm.updatePixels();
  
}

function keyTyped() {
  if (key === 's') {          // enregistrer l'image
    let strdate = Date.now();
    imgm.save("test_petit_format_" + strdate + ".png");
  } else if (key === 'g') {   // enregistrer l'image grand format
    let strdate = Date.now();
    imgmgf.save("test_grand_format_" + strdate + ".png");
  }
  
  // uncomment to prevent any default behavior
  return false;
}

