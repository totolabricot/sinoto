class setcommandes {

  int nbpots;
  FloatList setpans;
  IntList potards;
  int thelastId=0; ////// cet variable permettra de fair des ligne comme +5 100>1 10-1 immediatment transformé en id>id+5
  int maxId=0;
  String begin="~";


  setcommandes() {
    setpans=new FloatList();
    potards=new IntList();
  }

  void editpotparams(IntList Id, String pot, FloatList Potards, String param, float pas, String IdCesu) {

    potards.clear();
    for (int i=0; i<Potards.size(); i++)potards.append(int(Potards.get(i)));
    if (potards.size()==1)nbpots=1;
    if (potards.size()==2)nbpots=potards.get(1)-potards.get(0);

    int max= Id.get(0);
    if (IdCesu.equals(">"))max=Id.get(1);
    if (IdCesu.equals("+"))max=Id.get(0)+Id.get(1);

    if (pot.equals("e")) {
      for (int i=Id.get(0); i<=max; i++) oscilos[i].osciloerasepotar();
      if (max==0)clav.addToHisto(begin+" erased potards for oscilo "+Id.get(0));
      else {
        clav.addToHisto(begin+" erase potards for oscilos "+Id.get(0)+" to "+max);
      }
    } else { 

      if (nbpots==1)for (int i=Id.get(0); i<=max; i++)oscilos[i].osciloeditpotar(potards.get(0), param, pas);
      if (nbpots>1)for (int i=Id.get(0); i<=max; i++)oscilos[i].osciloeditpotar(int(map(i, Id.get(0), max+1, potards.get(0), potards.get(1)+1)), param, pas);
      if (max==0)clav.addToHisto(begin+" edited potards for oscilo "+Id.get(0));
      else {
        clav.addToHisto(begin+" edited potards for oscilos "+Id.get(0)+" to "+max);
      }
    }
  }

  void potarisediting(int idpot, float value) {

    for (int j=0; j<nboscilos; j++) {
      for (int i=0; i<oscilos[j].potar.size(); i++) {
        if (oscilos[j].potar.get(i)==idpot) {
          switch(oscilos[j].potarparam.get(i)) {
          case "v":
            oscilos[j].potareditvol(value);
            if ( oscilos[j].checkpotvol==false)oscilos[j].potvolcolor=blue;
            break;
          case "f":
            oscilos[j].potareditfreq(value, oscilos[j].potarpas.get(i));
            if ( oscilos[j].checkpotfreq==false)oscilos[j].potfreqcolor=blue;
            break;
          }
        }
      }
    }
  }


  void editall(IntList Id, FloatList Freq, FloatList Vol, FloatList Pans, StringList Cesu) { //////////////////////////////////////////////// EDITE UN.DES OSCILO.S

    editfreq(Id, Freq, Cesu.get(0), Cesu.get(1));
    editvol(Id, Vol, Cesu.get(0), Cesu.get(2));
    editpan(Id, Pans, Cesu.get(0), Cesu.get(3));
  }

  void editfreqvol(IntList Id, FloatList Freq, FloatList Vol, StringList Cesu) { //////////////////////////////////////////////// EDITE UN.DES OSCILO.S

    boolean edit=false;

    for (int i=0; i<Freq.size(); i++)if (abs(Freq.get(i))>0)edit=true;

    if (edit==true) {
      editfreq(Id, Freq, Cesu.get(0), Cesu.get(1));
      editvol(Id, Vol, Cesu.get(0), Cesu.get(2));
    }
  }

  void editfreq(IntList Id, FloatList Freq, String IdCesu, String myCesu) {

    // if (Freq.get(0)>=0) {
    int max= Id.get(0);
    if (IdCesu.equals(">"))max=Id.get(1);
    if (IdCesu.equals("+"))max=Id.get(0)+Id.get(1);

    for (int i=Id.get(0); i<=max; i++) {//////////////////// <= ???
      if (Freq.size()==1)oscilos[i].osciloeditfreq(Freq.get(0));
      if (Freq.size()==2) {//attention
        if (myCesu.equals("+")) oscilos[i].osciloeditfreq((Freq.get(0)+(i-Id.get(0))*Freq.get(1)));//FONCTIONNE
        if (myCesu.equals("-")) oscilos[i].osciloeditfreq((Freq.get(0)-(i-Id.get(0))*Freq.get(1)));//FONCTIONNE
        if (myCesu.equals(">")) oscilos[i].osciloeditfreq(Freq.get(0)+(i-Id.get(0))*((Freq.get(1)-Freq.get(0))/(Id.get(1)-Id.get(0)))); // NE FONCTIONNE PAS !!!!
        //if (myCesu.equals("$")) oscilos[i].osciloeditfreq(Freq.get(0)+(Freq.get(1)-Freq.get(0))/(Id.get(1)-i+1));
      }
    }

    if (max==0)clav.addToHisto(begin+" edited frequencie for oscilo "+Id.get(0));
    else {
      clav.addToHisto(begin+" edited frequencies for oscilos "+Id.get(0)+" to "+max);
    }
  }


  void editvol(IntList Id, FloatList Vol, String IdCesu, String myCesu) { 

    //   if (Vol.get(0)>=0) {

    int max= Id.get(0);
    if (IdCesu.equals(">"))max=Id.get(1);
    if (IdCesu.equals("+"))max=Id.get(0)+Id.get(1);

    for (int i=Id.get(0); i<=max; i++) {
      if (Vol.size()==1)oscilos[i].osciloeditvol(Vol.get(0));
      if (Vol.size()==2) {//attention
        if (myCesu.equals("+")) oscilos[i].osciloeditvol((Vol.get(0)+(i-Id.get(0))*Vol.get(1)));//FONCTIONNE
        if (myCesu.equals("-")) oscilos[i].osciloeditvol((Vol.get(0)-(i-Id.get(0))*Vol.get(1)));//FONCTIONNE
        if (myCesu.equals(">")) oscilos[i].osciloeditvol(Vol.get(0)+(i-Id.get(0))*((Vol.get(1)-Vol.get(0))/(Id.get(1)-Id.get(0)))); //FONCTIONNE
      }
    }

    if (max==0)clav.addToHisto(begin+" edited volume for oscilo "+Id.get(0));
    else {
      clav.addToHisto(begin+" edited volumes for oscilos "+Id.get(0)+" to "+max);
    }
  }


  void editpan(IntList Id, FloatList inPans, String IdCesu, String myCesu) {

    setpans.clear();
    for (int i=0; i<inPans.size(); i++) setpans.append(inPans.get(i));

    int max= Id.get(0);
    if (IdCesu.equals(">"))max=Id.get(1);
    if (IdCesu.equals("+"))max=Id.get(0)+Id.get(1);
    clav.addToHisto(begin+" edited panings for oscilos "+Id.get(0)+" to "+max);
    for (int i=Id.get(0); i<=max; i++) oscilos[i].osciloeditpans(inPans);

    if (max==0)clav.addToHisto(begin+" edited pannings for oscilo "+Id.get(0));
    else {
      clav.addToHisto(begin+" edited pannings for oscilos "+Id.get(0)+" to "+max);
    }
  }

  void mutemode(IntList Id, String IdCesu) {

    int max= Id.get(0);
    if (IdCesu.equals(">"))max=Id.get(1);
    if (IdCesu.equals("+"))max=Id.get(0)+Id.get(1);
    for (int i=Id.get(0); i<=max; i++) oscilos[i].mute();
    clav.addToHisto(begin+" oscilos "+Id.get(0)+" to "+max+" has been mute / unmute");

    if (max==0)clav.addToHisto(begin+" oscilo "+Id.get(0)+" has been mute / unmute");
    else {
      clav.addToHisto(begin+" oscilos "+Id.get(0)+" to "+max+" has been mute / unmute");
    }
  }

  void unmute() { 
    clav.addToHisto(begin+" unmute all oscilos");
    for (int i=0; i<nboscilos; i++) if (oscilos[i].muteon==true) oscilos[i].mute();
  }

  void saveosci(String Name) {
    String begin="";
    if (Name.length()>6) begin= Name.substring(0, 6);
    println(begin);
    if (begin.equals("backup")==false)clav.addToHisto(begin+" the set has been saved as : "+Name);
    mysave.createsauvegarde(Name);
    for (int i=0; i<nboscilos; i++) oscilos[i].saveoscilo();
  }

  void erasetoggles(IntList Id, String IdCesu, String forerase) {

    int max= Id.get(0);
    if (IdCesu.equals(">"))max=Id.get(1);
    if (IdCesu.equals("+"))max=Id.get(0)+Id.get(1);

    if (forerase.equals("e")) {
      for (int i=Id.get(0); i<=max; i++) {
        oscilos[i].mytoggles.clear();
        oscilos[i].relativeTimer=2;
      }
      if (max==0)clav.addToHisto(begin+" erase toggles for oscilos "+Id.get(0));
      else {
        clav.addToHisto(begin+" erase toggles for oscilos "+Id.get(0)+" to "+max);
      }
    }
  }


  void edittoggles(IntList Id, String IdCesu, int idTimer, FloatList toggles, String ToggleCesu) { ////////////////// a réétudier /////////////////////////////

  if(idTimer>1 && idTimer<temps.nbtimelines){

    int max= Id.get(0);
    if (IdCesu.equals(">"))max=Id.get(1);
    if (IdCesu.equals("+"))max=Id.get(0)+Id.get(1);
    
    println("id=> "+Id.get(0)+" max=> "+max);

    for (int i=Id.get(0); i<=max; i++) oscilos[i].relativeTimer=idTimer;
    if (ToggleCesu.equals(">")) for (int i=Id.get(0); i<max; i++) for (int j=0; j<toggles.size(); j++)oscilos[i].mytoggles.append(int(toggles.get(j)));
    else if (ToggleCesu.equals("+")) for (int i=Id.get(0); i<max; i++) oscilos[i].mytoggles.append(int(toggles.get(0))+int(toggles.get(1))*i);
    else {
      for (int i=Id.get(0); i<max; i++) oscilos[i].mytoggles.append(int(toggles.get(0))); //// c'est débile ça , tortille du cul mon pote
    }

    if (max==0)clav.addToHisto(begin+" edited toggles for oscilo "+Id.get(0));
    else {
      clav.addToHisto(begin+" edited toggles for oscilos "+Id.get(0)+" to "+max);
    }
  }
  }

  void editfade(IntList Id, float fadevol, String idCesu) {

    if (fadevol>0) {

      int max= Id.get(0)+1;//////////// cause potentielle de bug
      float multiplifade=0;
      if (idCesu.equals(">")) max=Id.get(1);
      if (idCesu.equals("+"))max=Id.get(0)+Id.get(1);
      for (int i=Id.get(0); i<max; i++) {
        multiplifade=oscilos[i].coeffadevol/fadevol;
        oscilos[i].coeffadevol=fadevol;
        oscilos[i].speedfadevol/=multiplifade;
      }

      if (max==0)clav.addToHisto(begin+" edited fade volume for oscilos "+Id.get(0));

      else {
        clav.addToHisto(begin+" edited fade volume for oscilos "+Id.get(0)+" to "+max);
      }
    }
  }

  void reset(IntList Id, String idCesu, boolean globalReset) {

    setpans.clear();
    setpans.append(0);

    boolean oktogo=true;

    for (int i=0; i<Id.size(); i++)if (Id.get(i)<0 && Id.get(i)>nboscilos)oktogo=false;


    if (oktogo==true) {
      if (Id.size()==1) {
        oscilos[Id.get(0)].resetoscilo(setpans);
        clav.addToHisto(begin+" oscilo "+Id.get(0)+" has been reset");
      }
      if (Id.size()==2) {
        int max= Id.get(0);
        //float multiplifade=0;
        if (idCesu.equals(">")) max=Id.get(1);
        if (idCesu.equals("+"))max=Id.get(0)+Id.get(1);
        for (int i=Id.get(0); i<=max; i++)oscilos[i].resetoscilo(setpans);
        clav.addToHisto(begin+" oscilos "+Id.get(0)+" to "+Id.get(1)+" has been reset");
      }
    }

    if (globalReset) {

      clav.addToHisto(begin+" timelines reset");

      for (int i=0; i<temps.nbtimelines; i++) {
        temps.duree[i]=0;
        temps.go[i]=false;
      }
    }
  }

  void totimeline(int idtimeline, int duree, String othercommand) {

    if (othercommand.equals("go")) {
      temps.go[idtimeline]=true;
      if (idtimeline==1)for (int i=2; i<temps.nbtimelines;i++)temps.go[i]=true;
      clav.addToHisto(begin+"timeline n° "+idtimeline+" is now running");
    } else if (othercommand.equals("stop")) {
      temps.stoptime(idtimeline);
      clav.addToHisto(begin+"timeline n° "+idtimeline+" is stoped");
    } else {
      if (duree>=0) {
        temps.duree[idtimeline]=duree;
        clav.addToHisto(begin+"timeline n° "+idtimeline+" is set to "+duree);
      }
    }
  }
}
