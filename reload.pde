class reload {

  String[] loadfile= new String[1];
  StringList laligne;
  int nbosci;
  FloatList pansback;
  IntList togglesback;
  StringList potback;
  StringList parampotback;

  FloatList freqback;
  FloatList volback;
  String line;

  reload() {
    laligne = new StringList();
    pansback = new FloatList();
    togglesback = new IntList();
    potback = new StringList();
    parampotback = new StringList();


    freqback = new FloatList();
    volback = new FloatList();
  }

  void loading(String name) { ////////////////////////////////ici il faut mettre un try


    String path = sketchPath()+"/sauvegardes/"+name+".txt";
    loadfile=loadStrings(path);
    if (loadfile!=null)setting();
  }

  void setting() { 
    com.idanalyse.clear();
    com.idanalyse.append(0);
    com.idanalyse.append(nboscilos-1);

    setcom.reset(com.idanalyse, ">", true);
    nbosci=int(loadfile[0]);
    if (nbosci>nboscilos)nbosci=nboscilos;

    for (int i=temps.nbtimelines+1; i<nbosci+temps.nbtimelines+1; i++) {
      laligne.clear();
      pansback.clear();
      togglesback.clear();
      potback.clear();
      parampotback.clear();
      freqback.clear();
      volback.clear();



      laligne.append(split(loadfile[i], '|'));
      freqback.append(float(split(laligne.get(0), '>')));
      volback.append(float(split(laligne.get(1), '>')));
      pansback.append(float(split(laligne.get(2), '>')));
      togglesback.append(int(split(laligne.get(3), '>')));
      togglesback.get(0);

      if (laligne.get(4).equals("")==false)potback.append(split(laligne.get(4), '>'));
      if (potback.equals("")==false) {
        for (int j=0; j<potback.size(); j++) {
          parampotback.clear();
          parampotback.append(split(potback.get(j), ','));
          oscilos[i-(temps.nbtimelines+1)].osciloeditpotar(int(parampotback.get(0)), parampotback.get(1), float(parampotback.get(2)));
        }
      }
      
      oscilos[i-(temps.nbtimelines+1)].relativeTimer=(togglesback.get(0));
      togglesback.remove(0);
      for (int j=0; j<togglesback.size(); j++)oscilos[i-(temps.nbtimelines+1)].mytoggles.append(togglesback);
      oscilos[i-(temps.nbtimelines+1)].coeffadevol=(volback.get(2));
      oscilos[i-(temps.nbtimelines+1)].osciloeditall(freqback.get(0), volback.get(0), pansback);
      oscilos[i-(temps.nbtimelines+1)].freq=(freqback.get(1));  //// pas de fade
      oscilos[i-(temps.nbtimelines+1)].vol=(volback.get(1));    //// pas de fade
    }


    // println("togglesback "+togglesback);
    for (int i=0; i<temps.nbtimelines; i++)temps.edittime(i, int(loadfile[i+1]));
    // println("temps.duree"+temps.duree[0]);

    //  }
  }
}
