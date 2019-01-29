class sauvegarde {

  PrintWriter sauv;
  String line="";
  
  sauvegarde() {
  }  

  void createsauvegarde(String name) {
    sauv=createWriter(sketchPath()+"/sauvegardes/"+name+".txt");
    sauv.print(nboscilos+"\n");
   for (int i=0;i<temps.nbtimelines;i++) sauv.print(temps.duree[i]+"\n");
  }

void addtoline(String boutdephrase){
  line+=boutdephrase;
}

  void addtosauvegarde() {
    sauv.print(line+"\n");
    sauv.flush();
    line="";
  }

  void createpushsauv(String[] list) {
    sauv=createWriter(sketchPath()+"/sauvegardes/PUSH.txt");
    for (int i=0; i<osc.nbosc+2; i++) {
      sauv.print(list[i]+"\n");
    //  println(list[i]);
    
  }
  sauv.flush();
  //println("PUSHsaved");
}

}
