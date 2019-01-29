class datavis {

  float xdatavis=0;
  float incdatavis=PI/100;
  float allydatavis=0;
  PGraphics visusino;
  float []lastY=new float[nboscilos];
  float Vmax=0.001;

  datavis() {
    this.visusino=createGraphics(width-440, 190);
  }

  void update() {

    this.visusino.beginDraw();
    this.visusino.noFill();
    this.visusino.stroke(255);
    this.visusino.rect(0, 0, this.visusino.width-1, this.visusino.height-1);
    this.xdatavis+=3;


    this.visusino.strokeWeight(3);
  //  this.visusino.stroke(255);
  //  this.visusino.line(this.xdatavis+2, 0, this.xdatavis+2, this.visusino.height);
    this.visusino.stroke(0);
    this.visusino.line(this.xdatavis+1, 0, this.xdatavis+1, this.visusino.height);
    this.visusino.strokeWeight(1);
    for (int i=0; i<nboscilos; i++) {     

      this.visusino.noFill();
      this.visusino.stroke(255, 20);

      float h = map(oscilos[i].vol, 0, Vmax, 0, visusino.height);
      float viz = sin(oscilos[i].viz)*(10)+h;

      if (oscilos[i].vol>0 && oscilos[i].muteon==false) {
        
        // this.visusino.point(this.xdatavis, this.visusino.height/2+sin(oscilos[i].ydatavis)*oscilos[i].vol*1000);
        this.visusino.point(this.xdatavis, this.visusino.height/2+sin(oscilos[i].ydatavis)*100);
        
        //   this.visusino.line(this.xdatavis,this.visusino.height/2, this.xdatavis, this.visusino.height/2+sin(oscilos[i].ydatavis)*100);

       // this.visusino.line( this.xdatavis-3,lastY[i],this.xdatavis,viz);
          

      /*  this.visusino.line(
          this.xdatavis-3, 
          this.visusino.height/2, 
          this.xdatavis, 
          this.visusino.height/2+sin(oscilos[i].ydatavis)*100
          );*/
      }

      if (oscilos[i].vol>Vmax)Vmax=oscilos[i].vol;
      lastY[i]=viz;

      if (this.xdatavis>this.visusino.width) {
        this.xdatavis=0;
        //  this.visusino.background(0);
        Vmax=0.001;
      }
    }

    this.visusino.endDraw();
  }

  void drawCanvas(int x, int y) {
    image(this.visusino, x, y);
  }
}
