class myosc {
  OscP5 oscP5;
  NetAddress myRemoteLocation;
  String textget="";
  String[] texttocom;
  String[] push;
  String[] pull = new String[369];
  int nbosc;

  myosc() {
    oscP5 = new OscP5(this, 12001); ///////////CANAL DE RECEPTION
    myRemoteLocation = new NetAddress("255.255.255.255", 12000); ///////CANAL D EMISSION
  }

  void oscEvent(OscMessage theOscMessage) {

    if (theOscMessage.checkAddrPattern("/com")==true) {
    //  println(theOscMessage.get(0).stringValue());
      com.analysecommande(theOscMessage.get(0).stringValue(), false);
      clav.historique.append(theOscMessage.get(0).stringValue());
    }

    if (theOscMessage.checkAddrPattern("/push")==true) {

      nbosc= int((theOscMessage.get(0).stringValue()));

      for (int i=0; i<nbosc+2; i++) {
        pull[i]=(theOscMessage.get(i).stringValue());
      }  

      mysave.createpushsauv(pull);
      myreload.loading("PUSH");
    }
    
        if (theOscMessage.checkAddrPattern("/currentline")==true) {
          clav.theotherguyline=(theOscMessage.get(0).stringValue());

        }
    
  }


  void oscsendcom(String commande) {

    OscMessage com = new OscMessage("/com"); 
    com.add(commande);
    oscP5.send(com, myRemoteLocation);
  }

  void oscpush() {
    push=loadStrings(sketchPath()+"/sauvegardes/"+"PUSH.txt");
    OscMessage pushin = new OscMessage("/push"); 
    for (int i=0; i<push.length; i++) pushin.add(push[i]);
    oscP5.send(pushin, myRemoteLocation);
  }

  void currentline() {

    OscMessage line = new OscMessage("/currentline"); 
    line.add(clav.currentline);
    oscP5.send(line, myRemoteLocation);
  }
}
