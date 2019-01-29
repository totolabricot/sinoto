class randomize {

  IntList idrandom;
  FloatList freqrandom;
  FloatList volrandom;
  FloatList pansrandom;
  FloatList togglesrandom;
  int nbtoggles=0;
  int coinPans=0;
  int time1=0;
    StringList cesuRandom;


  randomize() {
    idrandom= new IntList();
    freqrandom= new FloatList();
    volrandom= new FloatList();
    pansrandom= new FloatList();
    togglesrandom= new FloatList();
    cesuRandom= new StringList();
  } 


  void createrandom(int Id, int incrId, float noyau, int harmonic, float diviseur) {

    time1++;
    float difFreq=random(3);

    idrandom.append(Id);
    idrandom.append(incrId);
    cesuRandom.append("+");


    freqrandom.append(noyau+(noyau*harmonic)/diviseur);////////////////////  ajouter une variable ici à la place du 2
    //freqrandom.append(noyau+pow(harmonic,2));
    freqrandom.append(difFreq);
    cesuRandom.append("+");


    volrandom.append(1000/(freqrandom.get(0)/10));
    volrandom.append(random(-freqrandom.get(0)/1000, freqrandom.get(0)/1000));
    cesuRandom.append("+");

    pansrandom.append(map(noise(time1),0,1,-1,1));
    coinPans=int(random(4));////////////////////////////////////////////////////: pièce pour panings
    if (coinPans==0) {
      pansrandom.append(pansrandom.get(0)*-1);
      cesuRandom.append(">");
    } else { 
      cesuRandom.append("X");
    }
    
      setcom.editall(idrandom, freqrandom, volrandom,pansrandom, cesuRandom);
      setcom.editfade(idrandom, 0.01, "+");///////////////////////////////////////////////////////:editfade => a revoir très vite 

      //  setcom.mutemode(idrandom, "+");

      idrandom.clear();
      freqrandom.clear();
      volrandom.clear();
      //pansrandom.clear();
      //togglesrandom.clear();
      cesuRandom.clear();
    }

    void createToggles(int Id, int incrId, int idtimeline) {

      idrandom.append(Id);
      idrandom.append(incrId);
      //  println("id: "+Id+"incrId : "+incrId);

      for (int i=0; i<4; i++) togglesrandom.append((temps.duree[idtimeline]*int(random(1, 8)))/7);////////////////////// ça plante ici
      setcom.editfade(idrandom, map(idtimeline, 0, 500, 0.05, 0.001), "+");

      //  setcom.editfade(idrandom, map(idtimeline, 0, 500, 1, 0.00001), "+");
      setcom.erasetoggles(idrandom, "+", "e"); 
      setcom.edittoggles(idrandom, "+", idtimeline, togglesrandom, ">"); 
      idrandom.clear();
      togglesrandom.clear();
    }


    void reset(int Id) {
      idrandom.append(Id);
      setcom.reset(idrandom, "X", false);
      println("oscilo n°"+idrandom+" is clear now");
      idrandom.clear();
    }
  }
