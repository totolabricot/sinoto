
class getcommandes {


  String cmd; // TOUTE LA LIGNE
  StringList words; // DECOUPEE
  IntList idanalyse; ////LISTES DE CHAQUES MOTS :0
  FloatList arg1analyse; //// :1
  FloatList arg2analyse; //// :2  
  FloatList arg3analyse; //// :3  
  FloatList argpans;
  IntList argtoggles;

  String runningletter;
  StringList cesure;
  StringList runningArgs;

  boolean comgo;

  getcommandes() {
    words=new StringList();
    idanalyse=new IntList();
    arg1analyse=new FloatList();
    arg2analyse=new FloatList();
    arg3analyse=new FloatList();
    argpans=new FloatList();
    argtoggles=new IntList();
    runningArgs=new StringList();
    cesure=new StringList();
  }

  void analysecommande(String Cmd, boolean local) {

    words.clear();
    idanalyse.clear();
    arg1analyse.clear();
    arg2analyse.clear();
    arg3analyse.clear();
    argpans.clear();
    argtoggles.clear();
    cesure.clear();

    cmd=Cmd;
    words.append(split(cmd, " ")); ////////////////////// SEPARE LA PHRASE EN LISTE DE MOTS

    // println(words.get(0).length());
    //  for (int i=0; i<words.get(0).length(); i++)print(words.get(0).char[i])


    for (int i=0; i<words.size(); i++) {

      cesure.append("X");
      runningArgs.clear();

      for (int j=0; j<words.get(i).length(); j++) {
        runningletter=words.get(i).substring(j, j+1);
        if (runningletter.equals("+"))cesure.set(i, "+");
        if (runningletter.equals("-")&& cesure.get(i).equals("X"))cesure.set(i, "-");
        if (runningletter.equals(">"))cesure.set(i, ">");
        if (runningletter.equals("$"))cesure.set(i, "$");
      }
      if (!cesure.get(i).equals("X")) runningArgs.append(split(words.get(i), cesure.get(i)));
      else {
        runningArgs.append(words.get(i));
      }
      // println("ma cesure : "+cesure.get(i));
      // for (int j=0; j<runningArgs.size(); j++)println("argument n°"+j+" : "+runningArgs.get(j));
      //  println("argSize : "+runningArgs.size());
      if (i==0)for (int j=0; j<runningArgs.size(); j++)idanalyse.append(int(runningArgs.get(j)));
      if (i==1)for (int j=0; j<runningArgs.size(); j++)arg1analyse.append(float(runningArgs.get(j)));
      if (i==2)for (int j=0; j<runningArgs.size(); j++)arg2analyse.append(float(runningArgs.get(j)));
      if (i==3)for (int j=0; j<runningArgs.size(); j++)arg3analyse.append(float(runningArgs.get(j)));
    }

    /////////////////////////////////////////////////// TROUVE LA COMMANDE A EXECUTER et l'appele 

    // COMMANDES LOCALES ONLY------------------
    if (local==true) {   

      String cmdidanalyse= words.get(0);
      if (words.size()==2) {
        switch(cmdidanalyse) {
        case "s" :
          setcom.saveosci(words.get(1));
          break;
        case "l" :
          myreload.loading(words.get(1));
          break;
        }
      }

      if (words.get(0).equals("PUSH")) {      
        setcom.saveosci("PUSH");
        osc.oscpush();
      } else {
        osc.oscsendcom(Cmd);
      }
    }
    //------------------------------------------

    if (words.get(0).equals("t")) {
      if (words.size()==3)setcom.totimeline(int(words.get(1)), int(words.get(2)), words.get(2));
      if (words.size()==2 && words.get(1).equals("reset"))for (int i=0; i<temps.nbtimelines; i++)temps.duree[i]=0;
    } else if (words.get(0).equals("reset")) {
      idanalyse.clear();
      idanalyse.append(0);
      idanalyse.append(nboscilos-1);
      setcom.reset(idanalyse, ">", true);
    } else if (words.get(0).equals("help")) {
      showhelp=!showhelp;
    } else if (words.get(0).equals("exit")) {
      exit();
    } else if (words.get(0).equals("stop")) {
      for (int i=0; i<temps.nbtimelines; i++) {
        setcom.totimeline(i, 0, "stop");
      }
    } else if (words.get(0).equals("back")) {
      clav.countCom-=2;
      myreload.loading("backup/backup"+(clav.countCom));
    } else if (words.get(0).equals("m")) {
      setcom.unmute();
    } else {

      comgo=true;
      for (int i=0; i<idanalyse.size(); i++) if (idanalyse.get(i)<0 || idanalyse.get(i)>=nboscilos)comgo=false;


      if (comgo==true) {

        if (words.size()==2) {
          if (words.get(1).equals("m"))  setcom.mutemode(idanalyse, cesure.get(0));
          if (words.get(1).equals("reset"))setcom.reset(idanalyse, cesure.get(0), false);
        }


        if (words.size()==3) {
          String cmdarg1 = words.get(1);
          ;
          switch(cmdarg1) {
          case "c":
            setcom.editpotparams(idanalyse, words.get(2), arg2analyse, "v", 200, cesure.get(0));
            break;
          case "f":
            setcom.editfreq(idanalyse, arg2analyse, cesure.get(0), cesure.get(2));
            break;
          case "v":
            setcom.editvol(idanalyse, arg2analyse, cesure.get(0), cesure.get(2));
            break;
          case "p":
            //for (int i=0; i<arg2analyse.length; i++)pans.append(float(arg2analyse[i]));
            for (int i=0; i<arg2analyse.size(); i++)if (arg2analyse.get(i)>=0 || arg2analyse.get(i)<0)argpans.append(arg2analyse.get(i));
            if (argpans.size()>0)setcom.editpan(idanalyse, argpans, cesure.get(0), cesure.get(2));
            break;
          case "i":
            setcom.erasetoggles(idanalyse, cesure.get(0), words.get(2));
            break;
          case "fv":
            setcom.editfade(idanalyse, arg2analyse.get(0), cesure.get(0));
            break;
          default:
            setcom.editfreqvol(idanalyse, arg1analyse, arg2analyse, cesure);
            break;
          }
        }

        if (words.size()==4) {
          String cmdarg1 = words.get(1);
          switch(cmdarg1) {
          case "c":
            setcom.editpotparams(idanalyse, words.get(2), arg2analyse, words.get(3), 200, cesure.get(0));
            break;
          case "i":
            setcom.edittoggles(idanalyse, cesure.get(0), int(words.get(2)), arg3analyse, cesure.get(3));
            break;
          default:
            for (int i=0; i<arg3analyse.size(); i++)if (arg3analyse.get(i)>=0 || arg3analyse.get(i)<0) argpans.append(arg3analyse.get(i));
            if (argpans.size()>0)setcom.editall(idanalyse, arg1analyse, arg2analyse, argpans, cesure);
            break;
          }
        }


        if (words.size()==5) {
          String cmdarg1 = words.get(1);
          switch(cmdarg1) {
          case "c":
            setcom.editpotparams(idanalyse, words.get(2), arg2analyse, words.get(3), float(words.get(4)), cesure.get(0));
            break;
          default:
            //  for (int i=0; i<arg3analyse.size(); i++)if (arg3analyse.get(i)>=0 || arg3analyse.get(i)<0) argpans.append(arg3analyse.get(i));
            //  if (argpans.size()>0)setcom.editall(idanalyse, arg1analyse, arg2analyse, argpans);
            break;
          }
        }
        comgo=false;
      }
    }
  }
}
