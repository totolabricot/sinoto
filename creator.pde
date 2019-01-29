class creator {

  int id=0;
  int resetId=0;
  int resetDelay=0;
  
  int nbRandomOscilos=3;
  int nbmaxRandomOscilo=30;
  float noyau=60;
  float divinumber=1;
  // float multiplinoyau=1.1;
  int harmonic=0;
  String matiere="air";
  int nowtimeline=2;
  String currentPhase="creating";  // StringList ou bien liste de Int 0=creator 1=volume player 2=perlincreator 3=inactive
  int countBreak=0;
  boolean allMuted=false;
  int togglecount=0;
  int breakmax=10;
  int timer=0; 
  boolean creatorIsReseting=false;

  int  myNbOscilos=1;

  creator() {
  }


  void act() {


    if (currentPhase.equals("creating")) {
      myNbOscilos=int(random(1, nboscilos));


      timer++;
      nbRandomOscilos=int(map(noise(timer), 0, 1, 1, myNbOscilos/8));/////////////////////////////////////////////mettre un noise nbrandomOscilos
    //  println("noise :"+noise(timer)); 
      // nbRandomOscilos=int(random(1, 30));/////////////////////////////////////////////mettre un noise nbrandomOscilos

      if (id+nbRandomOscilos<myNbOscilos) {
        myrandom.createrandom(id, nbRandomOscilos, noyau, harmonic, divinumber);
        harmonic+=int(random(4));

        id+=1+nbRandomOscilos;///////////////////////////// actuellement ça supprime un oscilo precedement creer id+=RandomOscilos+1 ???
      } else {
        currentPhase="togglephase";
        id=0;
        harmonic=0;

        int noyauduree=int(random(30));//////////////////////////////noyauduree
        for (int i=2; i<temps.nbtimelines; i++) {
          temps.duree[i]=noyauduree*int(random(1, 1000));////////////////////////coefduree
          temps.go[i]=true;
        }
      }
    }

    if (currentPhase.equals("togglephase")) {
      nbRandomOscilos=int(random(1, 5));

      if (id+nbRandomOscilos<myNbOscilos) {
        //  temps.duree[1]=int(random(200));
        int idlooper=int(random(2, temps.nbtimelines));
        myrandom.createToggles(id, nbRandomOscilos, idlooper);
        id+=1+nbRandomOscilos;
        // println("ids : "+id);
       // println("idLooper : "+idlooper );
      } else {
        countBreak=0;
        temps.duree[1]=100;
        breakmax= int(random(2, 10)); ////////////////////////////////////////////count break max
        currentPhase="takeABreak";
        id=0;
      }
    }

    if (currentPhase.equals("fadePhase")) {
    }

    if (currentPhase.equals("takeABreak")) {
      countBreak++;
      if (countBreak>breakmax) {
        if (togglecount<1) {//////////////////////////////////////// togglecount
          id=0;
          togglecount++;
          countBreak=0;
          temps.duree[1]=0;

          int noyauduree=int(random(10));
          for (int i=2; i<temps.nbtimelines; i++) {
            temps.duree[i]=noyauduree+noyauduree*int(random(1, 50));
            temps.go[i]=true;
          }
          currentPhase="togglephase";
        } else { 
          temps.duree[1]=40;
          countBreak=0;
          togglecount=0;
          noyau=(int(random(60, 100)));
          divinumber=random(0.3, 8);
          id=0;
          for (int i=2; i<temps.nbtimelines; i++)temps.go[i]=false;
          currentPhase="creating";
          creatorIsReseting=true;
        }
      }
    }
  }

  void switchMaterial(String incomingMaterial) {

    if (incomingMaterial.equals("air") || incomingMaterial.equals("bois")|| incomingMaterial.equals("try"))matiere=incomingMaterial;
  }

  void reset() {
    
    resetDelay++;
    if (resetDelay>60){

    if (resetId<nboscilos) {
      myrandom.reset(id);
      resetId++;
    } 
    if (resetId>nboscilos) {
      creatorIsReseting=false;
      resetId=0;
    }
    
    resetDelay=0;
  }
  }

  void aff() {

    int ytexte=height-175;
    int incytexte=13;
    int xtexte=width-40;

    textAlign(RIGHT);
    text("(noyau) : "+round(noyau), xtexte, ytexte);
    ytexte+=incytexte;
    text("(divinumber) : "+divinumber, xtexte, ytexte);
    ytexte+=incytexte;
    text("(maxNbHarmonics) : "+harmonic, xtexte, ytexte);
    ytexte+=incytexte;
    text("(maxNbOsci) : "+nbRandomOscilos, xtexte, ytexte);
    ytexte+=incytexte;
    text("(matiere) : "+matiere, xtexte, ytexte);
    ytexte+=incytexte;
    text("(phase) : "+currentPhase, xtexte, ytexte);
    ytexte+=incytexte;
    text("(counterForWait) : "+countBreak, xtexte, ytexte);
    ytexte+=incytexte;
    text("(breakmax) : "+breakmax, xtexte, ytexte);
    ytexte+=incytexte;
    text("(togglecount) : "+togglecount, xtexte, ytexte);


    textAlign(LEFT);
  }
}
