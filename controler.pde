

class controler {
  int nbhardpot=4;//nombre de potards
  int nbpot=32;//nombre de potards virtuels
  int nbbout=2; //nombre de boutons

  int oriidpot;
  float[] val= new float[nbpot];
  float[] newval= new float[nbpot];
  float[] boutvalue= new float[nbbout];
  boolean[] push= new boolean[nbbout];
  boolean[] activpush= new boolean[nbbout];
  boolean firstset=false;

  String line;//ligne que je recupère
  StringList splitline;//et que je découpe pour analyse
  String linetocontroler; // ligne que je renvoi à arduino pour affichage


  controler() {

    splitline=new StringList();
    for (int i=0; i<nbpot; i++) {
      val[i]=0;
      newval[i]=0;
    }
    for (int i=0; i<nbbout; i++) {
      boutvalue[i]=1;
      push[i]=false;
      activpush[i]=false;
    }
    oriidpot=0;
  }

  void movin(String inline) {

    line = inline;
    splitline.clear();
    splitline.append(split(line, ':'));

    for (int i=0; i<nbhardpot; i++) {
      //  println(i);
      val[i]=newval[i];
      if (splitline.get(0).equals("pot"+i)) {
        newval[i+oriidpot]=float(splitline.get(1));      
        setcom.potarisediting(i+oriidpot+1, map(newval[i+oriidpot], 0, 1025, 0, 100)); /////// ici i+1 pour eviter qu'il y ai un controlleur n°0
      }
    }

    for (int i=0; i<nbbout; i++) {
      if (boutvalue[i]==1)push[i]=false;
      if (splitline.get(0).equals("bout"+i))boutvalue[i]=float(splitline.get(1));
      trypush();
    }
  }

  void trypush() { ///////////////// peut etre pas tant une bonne idee finalement

    if (boutvalue[0]==0 && push[0]==false && oriidpot>=4) {
      oriidpot-=4;
      activpush[0]=true;
      push[1]=true;
    }
    if (boutvalue[1]==0 && push[1]==false && oriidpot<nbpot-4) {
      oriidpot+=4;
      activpush[1]=true;

    }

    for (int i=0; i<nbbout; i++) {
      if (activpush[i]==true) { /////// y a du boulot ici pour reparer le ctrl il me semble //////////////////////////////////

        linetocontroler="";
        for (int j=0; j<nbhardpot; j++)linetocontroler+=oriidpot+1+j+"<>/";
        in.clear();
        in.write(linetocontroler);
        //println(oriidpot);
        for (int j=0; j<nboscilos; j++)oscilos[j].rebootcheckpot();
        push[i]=true; ///////////// attention, true?????
        activpush[i]=false;
        
      }
    }
  }

  void affctl() {

    fill(0);
    stroke(255);
    rect(360, height-200, 40, 40);
    fill(255);
    text((oriidpot+1), 366, height-184);
    text((oriidpot+2), 384, height-184);
    text((oriidpot+3), 366, height-168);
    text((oriidpot+4), 384, height-168);
  }

  void sendafirstinfo() {
    linetocontroler="";
    oriidpot=0;
    for (int j=0; j<nbhardpot; j++)linetocontroler+=oriidpot+1+j+"<>/";
    in.clear();
    in.write(linetocontroler);
    //println("youhho");
    firstset=true;
  }
}
