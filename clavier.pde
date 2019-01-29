class clavier {
  String currentline; //phrase active
  char lettre;
  String newline=""; //phrase validée
  //  int nblines; // nombres de phrases validées (pour affichage)
  int outlines=0;
  int realnblines; // nombres de phrases validées (pour affichage)
  int globalhistonblines; // nombres de phrases validées (pour affichage)

  StringList historique;
  StringList cmdhistorique;
  StringList affhistorique;  
  int moveinhisto=0;
  String theotherguyline="";
  StringList splitcurrentline;
  int countCom=0;
  int timerBarre=0;


  clavier(String currentLine) {

    currentline=currentLine;
    historique = new StringList();
    cmdhistorique = new StringList();
    affhistorique = new StringList();
    splitcurrentline = new StringList();
  }


  void keyAnalyse() {

    // println(keyCode);
    // if (keyCode!=BACKSPACE && keyCode!=20 && keyCode!=16 && keyCode!=37 && keyCode!=38 && keyCode!=40 
    //   && keyCode!=10 && keyCode!=61 || keyCode<48 && keyCode>57)addletter(key);
    if (keyCode==10)enter();
    else if (keyCode==BACKSPACE)retour();
    else if (keyCode==37)cleanline();
    else if (keyCode==38)loadbackline();
    else if (keyCode==40)loadnextline();
    else if (keyCode==61)currentline+="-";
    else if (keyCode>=48 && keyCode<=57)currentline+=(keyCode-48);
    else if (keyCode==16 || keyCode==20);
    else if (keyCode==192)currentline+=">";
    else if (keyCode==47)currentline+="+";
    else if (keyCode==44)currentline+=".";


    else {
      addletter(key);
    }

    osc.currentline();
  }

  void addletter(char lalettre) {

    lettre=lalettre;   
    currentline+=lettre;
  }

  void addsentence(String sentence) {

    currentline+=sentence;
    for (int i=0; i<3; i++)osc.currentline();
  }

  void enter() {


    newline=currentline;
    addToHisto(newline);
    setcom.saveosci("backup/backup"+countCom);
    countCom++;
    // osc.oscsendcom(newline);
    historique.append(newline);
    moveinhisto=0;
    com.analysecommande(newline, true);
    currentline="";
  }

  void addToHisto(String line) {

    affhistorique.append(line);
    globalhistonblines++;
  }



  void retour() {
    if (currentline.length()>0) {
      currentline=currentline.substring(0, currentline.length()-1);
    }
    return;
  }

  void cleanline() {
    splitcurrentline.clear();
    splitcurrentline.append(split(currentline, " "));
    if (splitcurrentline.size()>=2)currentline=splitcurrentline.get(0);
    else {
      currentline="";
      moveinhisto=0;
    }
  }

  void loadbackline() {
    if (moveinhisto<historique.size()) {
      moveinhisto++;
      currentline=historique.get(historique.size()-moveinhisto);
    }
  }

  void loadnextline() {
    if (moveinhisto>1) {
      moveinhisto--;
      // println(moveinhisto);
      currentline=historique.get(historique.size()-moveinhisto);
    }
  }


  ///////////////////////////////////////////AFFICHAGE


  void affclavier() {

    timerBarre++;
    // println(timerBarre);
    if (timerBarre>60)timerBarre=0;


    fill(255);
    rect(10, height-30, 390, 20);
    fill(0);
    textAlign(LEFT);
    text(currentline, 15, height-16);
    stroke(0);
    if (timerBarre>30)line(15+currentline.length()*6, height-16, 15+currentline.length()*6, height-24);  
    stroke(125);
    fill(125);
    // line(200, height-30, 200, height-10);
    text(theotherguyline, 220, height-16);
  }




  void affconsole() {

    noFill();
    stroke(255);
    rect(10, height-200, 390, 170);
    noStroke();
    fill(255);
    textAlign(LEFT, BOTTOM);
    if (affhistorique.size()>15) outlines=affhistorique.size()-15;

    for (int i=outlines; i<affhistorique.size(); i++) {
      text(affhistorique.get(i), 20, height-180+10*(i-outlines));
    }
  }
}
