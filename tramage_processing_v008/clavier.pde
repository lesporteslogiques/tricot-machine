void keyPressed() {
  if (key == 's') { // enregistrer une image
    Date now = new Date();
    SimpleDateFormat formater = new SimpleDateFormat("yyyyMMdd_HHmmss");
    System.out.println(formater.format(now));
    String type = "_unknown";
    switch (dither_type) {
      case 0:
        type = "_nodither";
        break;
      case 1:
        type = "_floyd-steinberg";
        break;
      case 2:
        type = "_atkinson";
        break;
      case 3:
        type = "_bayer2x2";
        break;
      case 4:
        type = "_bayer4x4";
        break;
      case 5:
        type = "_clustered4x4";
        break;
      case 6:
        type = "_random";
        break;
      case 7:
        type = "_stucki";
        break;
      case 8:
        type = "_jarvis-judice-ninke";
        break;
      case 9:
        type = "_floyd-steinberg-glitch";
        break;
      case 10:
        type = "_bayer8x8";
        break;
      case 11:
        type = "_false-floyd-steinberg";
        break;
      case 12:
        type = "_burkes";
        break;
      case 13:
        type = "_sierra";
        break;
      case 14:
        type = "_two-row-sierra";
        break;
      case 15:
        type = "_sierra-lite";
        break;
    }
    
    imgm.save(SKETCH_NAME + "_" + formater.format(now) + type + "_" + dimensions + ".png");
  }
}
