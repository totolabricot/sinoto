//class oscilo implements Comparable<oscilo> {

class oscilo {
  float freq=0;
  float editfreq=0;
  float lastfreq;
  float poteditvol;
  boolean checkpotvol=false;
  boolean checkpotfreq=false;
  boolean potalreadyexist=false;

  color potvolcolor=grey;
  color potfreqcolor=grey;

  float editvol=0;
  float lasteditvol;
  float mutevol=0;
  float vol=0;
  boolean goingup=false;
  float speedfadevol;
  float coeffadevol=0.01;

  float editpan=0;
  float pan=0;
  boolean aversb=true;
  boolean fadepanon=false;

  IntList potar;
  FloatList potarpas;
  StringList potarparam;
  float potarincfreq;
  float potarfreq;
  float potarvol;
  String potardstosave="";

  int relativeTimer=2;

  int x;
  int id;
  int y=25;
  float posytoggles;
  int xjump=0;
  int motheight=10;
  int nbosciheight;
  int xwidth=200;
  int yheight;


  FloatList pans;
  String panstosave="";


  IntList mytoggles;
  String togglestosave="";

  boolean muteon=false;
  boolean fadevol=true;

  float ydatavis=0;
  float incdatavis=0;

  oscilo() {

    pans = new FloatList();
    mytoggles=new IntList();
    potar=new IntList();
    potarparam=new StringList();
    potarpas=new FloatList();
  }

  ////////////////////////////////////////////////// AFFICHAGE ECRAN

  void setdatavis() {

    //    incdatavis= map(freq, 50, 15000, PI/10, PI);
    ydatavis = ydatavis + incdatavis;
  }

  void affoscilo(int Id) {

    id=Id;

    textAlign(RIGHT);
    nbosciheight=int((height-220)/(motheight+4));
    xjump=xwidth;
    x= 10+ int(id/nbosciheight)*xjump;
    y=id*(motheight+4)+20-((int(id/nbosciheight))*(height-226));
    //println(nbosciheight);
    noStroke();
    fill(255);
    text(freq, x+75, y);
    for (int i=0; i<potar.size(); i++) {


      fill(potfreqcolor);  

      if (potarparam.get(i).equals("f")) text(potar.get(i), x+90, y);

      fill(potvolcolor); 
      if (potarparam.get(i).equals("v")) text(potar.get(i), x+135, y);
      fill(255);
    }

    if (vol>0)fill(255, 0, 0);
    if (muteon==true && vol<=0) {
      fill(125);
      text("mute", x+120, y);
    } else {
      text(vol, x+120, y);
    }

    fill(255);
    if (fadepanon==true)fill(255, 0, 0);    

    text(pan, x+165, y);

    stroke(0);
    fill(255);
    rect(x-2, y-motheight, 25, motheight+2);
    fill(0);
    text(id, x+20, y);
    stroke(255);
    noFill();

    viz+=map(freq, 30, 15000, 0.01, PI*10);
  }
  float viz=0;

  void afftoggles() {
    noFill();
    stroke(255);
    for (int i=0; i<mytoggles.size(); i++) {
      posytoggles=map(float(mytoggles.get(i)), 0, temps.duree[relativeTimer], temps.y[relativeTimer], temps.y[relativeTimer]+temps.haut);
      if (posytoggles<temps.haut+temps.y[0] && posytoggles>temps.y[0]) {
        line(temps.x[relativeTimer], posytoggles, temps.x[relativeTimer]+temps.larg, posytoggles);
        fill(255);
        text(id,temps.x[relativeTimer]+30+map(id,0,nboscilos,0,40),posytoggles+map(id,0,nboscilos,0,40));
      }
    }
  }


  //////////////////////////////////////////////////////// AFFECTATIONS
  void osciloeditall(float editFreq, float editVol, FloatList Pan) {

    osciloeditvol(editVol);
    osciloeditfreq(editFreq);
    //osciloeditvol(editVol);
    osciloeditpans(Pan);


    incdatavis= map(freq, 50, 15000, PI/10, PI);
  }

  void osciloeditfreq(float editFreq) {

    editfreq=editFreq;
    freq=editfreq;
    sine[id].freq(freq);
    checkpotfreq=false;

    incdatavis= map(freq, 50, 15000, PI/10, PI);
  }

  void osciloeditvol(float editVol) {

    editvol=editVol;
    poteditvol=editvol;
    mutevol=0;
    muteon=false;/////////////////////sans doute pas suffisant
    speedfadevol=(editvol-vol)*coeffadevol;
    if (editvol>vol)goingup=true;
    if (editvol<vol)goingup=false;
  }

  void potareditvol(float potareditVol) {/////////////////////////////un potar edite de volume

    potarvol=map(potareditVol, 100, 0, 0, poteditvol);        
    // println("edit : "+poteditvol+" | potar : "+potarvol);
    if ((abs(potarvol-editvol))<lasteditvol/10)checkpotvol=true;

    if (checkpotvol ==true) {  
      editvol=potarvol;
      speedfadevol=(editvol-vol)*coeffadevol/10;
      if (editvol>vol)goingup=true;
      if (editvol<vol)goingup=false;
      potvolcolor=green;
    }

    lasteditvol=editvol;
  }

  void potareditfreq(float potareditFreq, float freqPas) {

    potarfreq=map(potareditFreq, 100, 0, editfreq, editfreq+freqPas);

    if ((abs(potarfreq-freq))<freqPas/50)checkpotfreq=true; ////// ici faire entrer potarpas dans l'equation 
    if (checkpotfreq ==true) { 
      freq=potarfreq;
      //freq=editfreq;
      sine[id].freq(freq);
      incdatavis= map(freq, 50, 15000, PI/10, PI);
      potfreqcolor=green;
    }
    lastfreq=freq;
  }

  void rebootcheckpot() {
    checkpotvol=false;
    checkpotfreq=false;
    potvolcolor=grey;
    potfreqcolor=grey;
  }


  void osciloeditpotar(int potarid, String param, float potarPas) {

    potalreadyexist=false;

    for (int i=0; i<potar.size(); i++) { 
      if (param.equals(potarparam.get(i))) {
        potalreadyexist=true;
        potar.set(i, potarid);
        potarparam.set(i, param);
        potarpas.set(i, potarPas );
      }
    }

    if (potalreadyexist==false) {       
      potar.append(potarid);
      potarparam.append(param);
      potarpas.append(potarPas);
    }
  }

  void osciloerasepotar() {

    //switch(

    potar.clear();
    potarparam.clear();
  }



  void osciloeditpans(FloatList Panings) {

    pans.clear();

    for (int i=0; i<Panings.size(); i++)  pans.append(Panings.get(i));

    pan=pans.get(0);
    sine[id].pan(pan);

    if (pans.size()>1)fadepanon=true;
    if (pans.size()==1)fadepanon=false;
    //    println(fadepanon);
  }


  void fadevol() {

    if (goingup==true && vol<editvol || goingup==false && vol>0)vol+=speedfadevol;
    //if (muteon==false)if (vol>editvol)vol=editvol;
    if (vol<0)vol=0;
    sine[id].amp(oscilos[id].vol/1000);/////////////////////////////////////////////////attention;
  }

  void fadepan() {

    // println("a"+pantab[0]+"b"+pantab[1]);

    if (fadepanon==true) {

      if (pans.get(0)<pans.get(1)) {
        if (aversb==true)pan+=0.001;
        if (aversb==false)pan-=0.001;
        if (pan<pans.get(0) || pan>pans.get(1))aversb=!aversb;
      }

      if (pans.get(0)>pans.get(1)) {
        if (aversb==false)pan+=0.001;
        if (aversb==true)pan-=0.001;
        if (pan>pans.get(0) || pan<pans.get(1))aversb=!aversb;
      }

      sine[id].pan(pan);
    }
  }


  void mute() {
    muteon=!muteon;
    // goingup=!goingup; //////////// attention
    if (muteon==true) {
      goingup=false;
      mutevol=editvol;
      editvol=0;
      potarvol=0;/////////// potar mute ici
      speedfadevol=-(mutevol)*coeffadevol;
    }
    if (muteon==false) {
      goingup=true;
      editvol=mutevol;
      potarvol=mutevol;
      // mutevol=0;
      speedfadevol=(editvol)*coeffadevol;
      // if (editvol>vol)goingup=true;
    }

    // println(muteon+" : "+speedfadevol);
  }



  void oscilochecktoggles() {////////////////////////////: A CHANGER DE PLACE, SUPPPRIMER LA FONCTION
    for (int i=0; i<mytoggles.size(); i++) if (temps.time[relativeTimer]==mytoggles.get(i) && temps.go[relativeTimer]==true)mute();
  }


  void saveoscilo() {

    mysave.addtoline(editfreq+">"+freq+"|");

    if (editvol==0 && mutevol>0)mysave.addtoline(mutevol+">"+vol+">"+coeffadevol+"|");
    else {
      mysave.addtoline(editvol+">"+vol+">"+coeffadevol+"|");/////////////////////////////////////////////// ajouter lasteditvol? potarvol?
    }

    if (pans.size()>0) {
      for (int i=0; i<pans.size(); i++) panstosave+=pans.get(i)+">";  
      mysave.addtoline(panstosave.substring(0, panstosave.length()-1)+"|");
    } else if (pans.size()==0) { 
      mysave.addtoline("0|");
    } 
    //   if (mytoggles.size()>0) {

    togglestosave+=relativeTimer+">"; //////////////////////////////ICI

    for (int i=0; i<mytoggles.size(); i++) togglestosave+=mytoggles.get(i)+">";    
    mysave.addtoline(togglestosave.substring(0, togglestosave.length()-1)+"|"); //////////////////////////////ICI
    // }
    // if (mytoggles.size()==0)mysave.addtoline("|");
    if (potar.size()>0) {
      for (int i=0; i<potar.size(); i++) potardstosave+=potar.get(i)+","+potarparam.get(i)+","+potarpas.get(i)+">";    
      mysave.addtoline(potardstosave.substring(0, potardstosave.length()-1)); //////////////////////////////ICI
    }
    //println(potar);
    mysave.addtosauvegarde();
    togglestosave="";
    panstosave="";
    potardstosave="";
  }



  void resetoscilo(FloatList inpans) {

    if (muteon)mute();
    osciloeditall(0, 0, inpans); 
    vol=0;
    potar.clear();
    potarparam.clear();
    pans.clear();
    mytoggles.clear();
    rebootcheckpot();
    checkpotvol=false;
    checkpotfreq=false;
    coeffadevol=0.01;
  }
}
