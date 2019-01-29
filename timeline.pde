class timeline {

  //  temps= new timeline(width-70, 30, 50, height-250);

  int nbtimelines=8;

  int[] time= new int[nbtimelines];
  int[] duree= new int[nbtimelines];
  int[] x= new int[nbtimelines];
  float[] y= new float[nbtimelines];
  float[] posytimer = new float[nbtimelines];
  boolean[] go=new boolean[nbtimelines];

  int larg=20;
  int haut=height-400;
  float pieceforoto;
  String[] loopName=new String[nbtimelines];
  timeline() {

    for (int i=0; i<nbtimelines; i++) {
      time[i]=0;
      duree[i]=0;
      go[i]=false;
      x[i]=width-100-70*i;
      y[i]=60;
      loopName[i]="loop°"+i+"\n";
    }

    loopName[0]="sinoto\n";
    loopName[1]="creator\n";
  }

  void aff() {

    for (int i=0; i<nbtimelines; i++) {
      fill(255);
      text(loopName[i]+duree[i], x[i], y[i]-30);
      noFill();
      stroke(255);
      rect(x[i], y[i], larg, haut);
      posytimer[i]=map(time[i], 0, duree[i], y[i], y[i]+haut);
      stroke(255, 0, 0);
      line(x[i], posytimer[i], x[i]+larg, posytimer[i]);
    }
  }

  void run() {

    for (int i=0; i<nbtimelines; i++) if (go[i]==true) time[i]+=1; 

    if (time[1]>duree[1]) { ///////////////////////////////////////////////// creator 
      createur.act();
     // duree[1]=int(random(1, 10))*50;
    }

    for (int i=0; i<nbtimelines; i++) if (time[i]>duree[i])time[i]=0;
  }


  void edittime(int idtimer, int Duree) {
    duree[idtimer]=Duree;
  }


  void stoptime(int idtimer) {
    go[idtimer]=false;
    time[idtimer]=0;
  }
}
