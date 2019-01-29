class help {
  String[] texthelp;
  
  help() {

  }

  void inithelp() {
    texthelp=loadStrings("DOC.txt");
  }

  void affhelp() {  
   //  textFont(police[3],13);
    
    stroke(255);
    fill(0);
    rect(420, height-200,width-440, 190);
    fill(255);
    for (int i=0; i<texthelp.length; i++)text(texthelp[i], 430,(height-180)+i*10);
    // textFont(police[2],10);

  }

}
