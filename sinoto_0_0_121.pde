 //<>//
// GROS PROBLEMES DE RELOAD !!!  probleme de reload avec le coeffadevol => le volume ou la frequence reste à 0

//  TESTER ET AJOUTER DES LOG SUR LES FADEVOLUME
// CREER DES TOGGLES POUR LES FREQUENCES ET LES PANNINGS
// PROBLEME MUTE +> POTAREDITVOL DEVIENT 0 QUAND MUTE // REGLé?
// AJOUTER DES BRUITS!!!
// DATAVIS CONTROLLER
// REDIGER UNE DOC 
// POUVOIR SAUVEGARDER UN SET LIVE
// CREER PLUSIEUR FACON DE COMPOSER POUR LE SINOTO !!!


import processing.sound.*;
import java.util.*;
import oscP5.*;
import netP5.*;
import processing.serial.*;

timeline temps;
clavier clav= new clavier("");
myosc osc= new myosc();
getcommandes com= new getcommandes();
setcommandes setcom= new setcommandes();
help helpme= new help();
sauvegarde mysave= new sauvegarde();
reload myreload= new reload();
controler mycontroler=new controler();
randomize myrandom=new randomize();
creator createur=new creator();


datavis mydatavis;
Serial in; // je creer in nouveau port serie

PFont[] police=new PFont[4];

color red=#FF0000;
color blue=#03F2FC;
color grey=#9D9D9D;
color green=#0DFA1E;
int nboscilos=10; ///////////////////////////////////////// NOMBRES D'OSCILOS
//int nbnoise=99; ///////////////////////////////////////// NOMBRES DE BRUITS

boolean showhelp=false;
int fadetime=2;
int fadetimer=fadetime;
SinOsc[] sine= new SinOsc[nboscilos];
oscilo[] oscilos = new oscilo[nboscilos];

/*
WhiteNoise[] noise=new WhiteNoise[nbnoise];
 BandPass[] filter = new BandPass[nbnoise];
 bruit[] bruits = new bruit[nbnoise];
 */

boolean bandeau=true;

void setup() {

  fullScreen();
  background(0);

  police[0] = loadFont("Courier-40.vlw");
  police[1] = loadFont("Courier-15.vlw");
  police[2] = loadFont("Courier-10.vlw");
  // police[3] = loadFont("Courier-13.vlw");

  textFont(police[0], 40);
  //textSize(40);
  text("sinoto 0.0.119", 200, height/2);
  //textSize(18);
  textFont(police[1], 15);

  fill(125);
  text("experimental software to live-code oscilos", 200, (height/2)+25);

  for (int i=0; i<nboscilos; i++) {
    oscilos[i]= new oscilo();
    sine[i] = new SinOsc(this); 
    sine[i].amp(0);
    sine[i].freq(0);
    sine[i].pan(0);
    sine[i].play();
  }
  
  if(createur.creatorIsReseting==true)createur.reset();


  /*for (int i=0; i<nbnoise; i++) {
   bruits[i]= new bruit();
   bruits[i].play(0);
   filter[i].process(noise[i]);
   }*/

  in=new Serial(this, Serial.list()[2], 9600);
  in.bufferUntil(10);

  temps= new timeline();
  mydatavis= new datavis();
  helpme.inithelp();
  //textSize(9);
  textFont(police[2], 10);
}


void draw() {

  if (bandeau ==false) {

    background(0);

    fadetimer--;
    if (fadetimer<0)fadetimer=fadetime;


    for (int i=0; i<nboscilos; i++) {
      oscilos[i].oscilochecktoggles();
      if (oscilos[i].vol!=oscilos[i].editvol && fadetimer==fadetime) oscilos[i].fadevol();
      if ( oscilos[i].pans.size()>1)oscilos[i].fadepan();
      oscilos[i].affoscilo(i);
      oscilos[i].afftoggles();
      oscilos[i].setdatavis();
    }

    clav.affclavier();
    clav.affconsole();
    mycontroler.affctl();
    //  mycontroler.trypush();
    mydatavis.update();
    mydatavis.drawCanvas(420, height-200);
    temps.aff();
    temps.run();
    createur.aff();

    if (mycontroler.firstset==false)mycontroler.sendafirstinfo();
    if (showhelp==true)helpme.affhelp();
  }
}


void keyPressed() {
  if (bandeau==false)if (keyPressed==true)clav.keyAnalyse();
  if (bandeau==true)bandeau=false;
  // println(keyCode);
}


void serialEvent(Serial p) {
  mycontroler.movin(p.readString());
}
