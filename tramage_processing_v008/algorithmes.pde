
void setPix(int x, int y, float v) {
  //if (DEBUG) println(x + ", " + y + " : " + v);
  if (x >= 0 && x < imgmw && y >= 0 && y < imgmh) {
    int r = pix[x][y] + 128; 
    r += int(v);
    r = constrain(r, 0, 255);
    pix[x][y] = byte(r - 128);
  }
}


void calculerDither() {

  imgd.loadPixels();
  
  if (dither_type == 0) {     
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128;
        if (r > seuil) imgm.pixels[i] = color(c1); 
        else           imgm.pixels[i] = color(c2); 
      }
    }   
  } else if (dither_type == 1) {   
    float w1 = 7.0/16.0;
    float w2 = 3.0/16.0;
    float w3 = 5.0/16.0;
    float w4 = 1.0/16.0;
    if (DEBUG) println("Appliquer dither Floyd Steinberg");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;
        if (DEBUG && i%777 == 0) {
          println("QE : " + quant_error + " " + w1 * quant_error + " " + w2 * quant_error);
        }
        setPix(x+1, y,   w1 * quant_error);
        setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w3 * quant_error);
        setPix(x+1, y+1, w4 * quant_error);
        //color cd = getColor(x+1, y, w1 * quant_error, imgd);
      }
    }
  } else if (dither_type == 11) {   // False Floyd Steinberg
    float w1 = 3.0/8.0;
    //float w2 = 3.0/16.0;
    float w3 = 3.0/8.0;
    float w4 = 2.0/8.0;
    if (DEBUG) println("Appliquer dither Floyd Steinberg");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;

        setPix(x+1, y,   w1 * quant_error);
       // setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w3 * quant_error);
        setPix(x+1, y+1, w4 * quant_error);
        //color cd = getColor(x+1, y, w1 * quant_error, imgd);
      }
    }
  } else if (dither_type == 9) {   
    float w1 = 6.0/16.0;
    float w2 = 6.0/16.0;
    float w3 = 6.0/16.0;
    float w4 = 6.0/16.0;
    if (DEBUG) println("Appliquer dither Floyd Steinberg Glitch");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;
        if (DEBUG && i%777 == 0) {
          println("QE : " + quant_error + " " + w1 * quant_error + " " + w2 * quant_error);
        }
        setPix(x+1, y,   w1 * quant_error);
        setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w3 * quant_error);
        setPix(x+1, y+1, w4 * quant_error);
        //color cd = getColor(x+1, y, w1 * quant_error, imgd);
      }
    }
  } else if (dither_type == 2) {   
    float w1 = 1.0/8.0;
    if (DEBUG) println("Appliquer dither Atkinson");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;
        if (DEBUG && i%777 == 0) {
          println("QE : " + quant_error + " " + w1 * quant_error );
        }
        setPix(x+1, y,   w1 * quant_error);
        setPix(x+2, y,   w1 * quant_error);
        setPix(x-1, y+1, w1 * quant_error);
        setPix(x,   y+1, w1 * quant_error);
        setPix(x+1, y+1, w1 * quant_error);
        setPix(x,   y+2, w1 * quant_error);
      }
    }
  } else if (dither_type == 7) {   
    float w1 = 1.0/42.0;
    float w2 = 2.0/42.0;
    float w4 = 4.0/42.0;
    float w5 = 5.0/42.0;
    float w7 = 7.0/42.0;
    float w8 = 8.0/42.0;
    if (DEBUG) println("Appliquer dither Stucki");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;
        if (DEBUG && i%777 == 0) {
          println("QE : " + quant_error + " " + w1 * quant_error );
        }
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
  } else if (dither_type == 12) {  // Burkes 
    float w1 = 8.0/32.0;
    float w2 = 4.0/32.0;
    float w3 = 2.0/32.0;
    if (DEBUG) println("Appliquer dither Burkes");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;

        setPix(x+1, y,   w1 * quant_error);
        setPix(x+2, y,   w2 * quant_error);
        setPix(x-2, y+1, w3 * quant_error);
        setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w1 * quant_error);
        setPix(x+1, y+1, w2 * quant_error);
        setPix(x+2, y+1, w3 * quant_error);
      }
    }
  } else if (dither_type == 13) {  // Sierra 
    float w1 = 5.0/32.0;
    float w2 = 3.0/32.0;
    float w3 = 2.0/32.0;
    float w4 = 4.0/32.0;
    if (DEBUG) println("Appliquer dither Sierra");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;

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
  } else if (dither_type == 14) {  // Two-Row Sierra
    float w1 = 1.0/16.0;
    float w2 = 2.0/16.0;
    float w3 = 3.0/16.0;
    float w4 = 4.0/16.0;
    if (DEBUG) println("Appliquer dither Two-Row Sierra");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;

        setPix(x+1, y,   w4 * quant_error);
        setPix(x+2, y,   w3 * quant_error);
        setPix(x-2, y+1, w1 * quant_error);
        setPix(x-1, y+1, w2 * quant_error);
        setPix(x,   y+1, w3 * quant_error);
        setPix(x+1, y+1, w2 * quant_error);
        setPix(x+2, y+1, w1 * quant_error);
      }
    }
  } else if (dither_type == 15) {  // Sierra Lite
    float w1 = 1.0/4.0;
    float w2 = 2.0/4.0;
    if (DEBUG) println("Appliquer dither Sierra Lite");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;

        setPix(x+1, y,   w2 * quant_error);
        setPix(x-1, y+1, w1 * quant_error);
        setPix(x,   y+1, w1 * quant_error);
      }
    }
  } else if (dither_type == 8) { // Jarvice-Judice-Ninke   
    float w1 = 1.0/48.0;
    float w3 = 3.0/48.0;
    float w5 = 5.0/48.0;
    float w7 = 7.0/48.0;
    if (DEBUG) println("Appliquer dither Jarvice-Judice-Ninke");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        if (r < seuil) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
        float quant_error = r - cm;
        if (DEBUG && i%777 == 0) {
          println("QE : " + quant_error + " " + w1 * quant_error );
        }
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
  } else if (dither_type == 3) {   
    
    int[] coefficients = {2, 3, 4, 1};
    for (int i = 0; i < coefficients.length; i++) {
      coefficients[i] = coefficients[i] * 64 - 1;
    }
    if (DEBUG) println("Appliquer dither Bayer 2x2");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        int index = y%2 * 2 + x%2;
        if (r > coefficients[index]) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
      }
    }
  } else if (dither_type == 4) {   // Ordered , Bayer 4 x 4
    
    float[] coefficients = {0.1250, 1.0000, 0.1875, 0.8125, 
                            0.6250, 0.3750, 0.6875, 0.4375,
                            0.2500, 0.8750, 0.0625, 0.9375,
                            0.7500, 0.5000, 0.5625, 0.3125};
                          
    for (int i = 0; i < coefficients.length; i++) {
      coefficients[i] = coefficients[i] * 255.0;
    }
    if (DEBUG) println("Appliquer dither Bayer 4x4");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        int index = y%4 * 4 + x%4;
        if (r > coefficients[index]) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
      }
    }
  } else if (dither_type == 10) {   // Ordered , Bayer 8 x 8
    
    float[] coefficients = { 1, 33,  9, 41, 3,  35, 11, 43, 
                            49, 17, 57, 25, 51, 19, 59, 27, 
                            13, 45,  5, 37, 15, 47,  7, 39, 
                            61, 29, 53, 21, 63, 31, 55, 23,
                             4, 36, 12, 44,  2, 34, 10, 42, 
                            52, 20, 60, 28, 50, 18, 58, 26, 
                            16, 48,  8, 40, 14, 46,  6, 38, 
                            64, 32, 56, 24, 62, 30, 54, 22};
                          
    for (int i = 0; i < coefficients.length; i++) {
      coefficients[i] = coefficients[i] * 4.0 - 1.0;
    }
    if (DEBUG) println("Appliquer dither Bayer 4x4");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        int index = y%8 * 8 + x%8;
        if (r > coefficients[index]) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
      }
    }
  } else if (dither_type == 5) {   // Ordered , Clustered 4 x 4
    
    float[] coefficients = {0.7500, 0.3750, 0.6250, 0.2500, 
                            0.0625, 1.0000, 0.8750, 0.4375,
                            0.5000, 0.8125, 0.9375, 0.1250,
                            0.1875, 0.5625, 0.3125, 0.6875};
                          
    for (int i = 0; i < coefficients.length; i++) {
      coefficients[i] = coefficients[i] * 255.0;
    }
    if (DEBUG) println("Appliquer dither Clustered 4x4");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        int index = y%4 * 4 + x%4;
        if (r > coefficients[index]) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
      }
    }
  } else if (dither_type == 6) {   // Random
    
    if (DEBUG) println("Appliquer dither Random");
    for (int x = 0; x < imgd.width; x++) {
      for (int y = 0; y < imgd.height - 1; y++) {
        int i = x + y * imgd.width;
        int r = pix[x][y] + 128; 
        int cm;
        int index = y%4 * 4 + x%4;
        if (r > random(255)) cm = c1;
        else cm = c2;
        imgm.pixels[i] = color(cm); 
      }
    }
  }

  imgd.updatePixels();
}
