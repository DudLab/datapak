//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Task 1;
//if using ultrasonic sensors, first upload arduino code in commtest to the arduino board
//and set the variable "ultrasonicmode" in this task to one
//SEE VARIABLE SECTION BELOW AND CHANGE ULTRASONIC SECTION ACCORDING TO RIG DIMENSIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//NEED TO IMPLEMENT SCALING OF ULTRASONIC INPUT in CM TO DISPLAY(pixel) COORDINATES
//WHEN USING ULTRASONIC, the CODE WILL OUTPUT CM VALUES
import controlP5.*;
import java.applet.Applet;
import java.awt.*;
import java.util.*;
import processing.net.*; 
import processing.serial.*;
import javax.swing.*;
import processing.sound.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
Serial myPort;  // The serial port
Minim minim;
AudioPlayer [] death = new AudioPlayer[1];
AudioPlayer nuke;
PImage maus[];
PImage explosion[];
PImage grid;
PImage cheese;
PrintWriter output;
PrintWriter parameters;
String inStr; 
String fileName;
String mS = " ";
String dS = " ";
String data = " ";
String paramData = " ";
String directoryName = "test";
String testsubjectname = " ";
String i = " ";
String myString = null;
int pn = 5; //number of probabilities
int rnum = 2;// number of reaches
int block = 0;
int rblock = 0;
int bw = 50;//blockwidth ORIGINAL 25
int blocktot = pn*rnum;
int maxtrials = 500;
int lf = 10;// Linefeed in ASCII
IntList pp;//prob randomly shuffled
IntList rp;//reach randomly shuffled
int trialstate = 1;// forage, collect soforth
int trialcnt = 0;
int pnt;//points
int ms =0;
float angle=0;
float a;
float pva;
float tva;
int offset = displayHeight/20;
float sd = displayWidth/20;//displayWidth/10;// startdiameter60
float tgd = displayWidth/10;//targetdiameter150
float dista;
float fd = 0;//foragedistance
float cd = 0;//collectdistance
float rightorwrong = 0;
float totd = 0;//totaldistance
float optd = 0;//optimaldistance
float ddif = 0;//difference subjectd - optd

float x0 = displayWidth/2;//start/trialinit y
float y0;//start/trialinit y
float x1;
float y1;
float x2;
float y2;
float tgdx = displayWidth/4;//distance between targets
float problist[] = {0.1,0.25,0.5,0.75,0.9};
//float rlist[] = {sqrt(pow((displayHeight*0.35),2)-pow((displayWidth/4),2))
//, sqrt(pow(((displayHeight*0.35)*2),2)-pow((displayWidth/4),2))};
float [] reachposy = {};
float p;//probability value
float r;//reachvalue
float sp[] = new float[pn*rnum];
float rl[] = new float[rnum];
float rindex[] = new float[rnum];
float px;// x value; if using ultrasonic, px is in centimeters
float py;// y value; if using ultrasonic, py is in centimeters
float pxu;// raw ultrasonic cm x value
float pyu;// raw ultrasonic cm y value
float pvx;//previous frame x value
float tvx;
float pvy;//previous frame y value
float tvy;
float r1u = 30;//reach1 in raw cm
float r2u = 60;//reach2 in raw cm
float r1;//reach1 in pixelvalues
float r2;//reach2 in pixelvalues
//=============================================================================
//=============================================================================
//ULTRASONICSTUFF: IMPORTANT
//NEED TO IMPLEMENT SCALING OF ULTRASONIC INPUT in CM TO DISPLAY(pixel) COORDINATES
//=============================================================================
//=============================================================================
int ultrasonicmode = 0;//IF USE ULTRASONIC SENSORS OR MOUSE
// 1 = yes; 0 = no
//THE FOLLOWING DIMENSIONS BELOW ARE PURELY EXAMPLES,
//CHANGE THEM ACCORDING TO ULTRASONIC FINAL RIG
//Ensure that the ultrasonic sensor's miminum distances from their respective
//parallel walls is at least 3 centimeters or so
float boxwidth = 40;//width(cm) of rig box move area
float boxlength = 80;//length(cm) of rig box move area
//( dimension used for reachingforward)
float utgd = boxwidth/12;//ultrasonic targetdiameter in cm
float utgdx = boxwidth/4;//target x dist from center
float usd = boxwidth/12;//ultrasonic targetdiameter in cm
float rlu[] = new float[rnum];//reach ultrasonic cm
float ru;//reachvalue in cm
float x0u = boxwidth/2;//start/trialinit x value raw cm
float y0u = boxlength - usd;//start/trialinit y value raw cm
float x1u;//correct target area x in cm
float y1u;//correct target area y in cm
float x2u;//incorrect target area x in cm
float y2u;// incorrect target area x in cm
float graphics = 1;//turn graphics on or off
int maussize = 100;//size of grahpic animated mouse
//=============================================================================
//=============================================================================
int flickerint=0;
int anreset = 0;// reset animation
int anit = 0;
int rpos;//left or right
int wpos;// wrongpos
int ppos;
int practiceint=10;
float points = 0;
float maxpoints;
color start = color(255,0,0);
color left = color(51,51,255);
color right = color(255,255,51);
color[] col = {color(255,0,0),color(51,51,255),color(255,255,51)};
color asdf = color(255,0,0);
color tg = color(125,125,255);
long time = 0;
long trigtime = 0;
boolean show = true;
void setup(){
  size(displayWidth,displayHeight);
  //========================================================================
  //===============GUI/ USER INPUT==========================================
  //========================================================================
  try{
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());    
  }catch(Exception e){
    e.printStackTrace();
  }
  String preset="Type your unique identifier";
  String op1s = JOptionPane.showInputDialog(frame, "Identifier", preset);
  if (op1s != null) i = op1s;
  //========================================================================
  //===============TIME AND DATE============================================
  //========================================================================
  int d = day(); 
  if (d<10) {
    dS = '0'+str(d);
  } else {
    dS = str(d);
  }
  int m = month();
  if (m<10) {
    mS = "0"+str(m);
  } else {
    mS = str(m);
  }
  //========================================================================
  //===============SHUFFLE PROBABILIIES (Per block)
  //===============and (LEFT)REACHES ( per half session of trials, i.e., 250
  //========================================================================
  pp = new IntList();
  rp = new IntList();
  if (ultrasonicmode == 0){
    r1 = sqrt(pow((displayHeight*0.35),2)-pow((displayWidth/10),2));
    //shorter reach
    r2 = sqrt(pow(((displayHeight*0.35)*2),2)-pow((displayWidth/10),2));
    //longer reach
  }else{
    //INITIALIZE SERIAL IF ULTRASONIC USED
    myPort = new Serial(this, Serial.list()[2], 9600);
    myPort.clear();
    myString = myPort.readStringUntil(lf);
    myString = null;
    //CONVERT CM TO PIXELS, proportional to display
    r1 = (r1u/boxlength)*displayHeight;//scale cm to display
    r2 = (r2u/boxlength)*displayHeight;//scale cm to display
  }
  float rlist[] = {r1,r2};//reach converted into cm
  float rlistu[] = {r1u,r2u};//raw reach cm
  IntList tempr  = new IntList();
  for (int c = 0; c < rnum; c++){
    IntList temp = new IntList();
    //IntList tempr  = new IntList();
    tempr.append(c);
    for (int r =0; r<pn; r++){
        temp.append(r);
    }
    temp.shuffle();
    pp.append(temp);//shuffle probability
    //rp.append(tempr);
  }
  tempr.shuffle();
  rp.append(tempr);//shuffle reach
  for (int i = 0; i < rp.size(); i++){
    rl[i] = rlist[rp.get(i)];
    rlu[i] = rlistu[rp.get(i)];//ultrasonic
    rindex[i] = rp.get(i);
  }
  for (int i = 0; i < pp.size(); i++){
      sp[i] = problist[pp.get(i)];
    
  }
  if (ultrasonicmode == 0 ){
    sd =  displayWidth/12;//displayWidth/10;// startdiameter60
    tgd = displayWidth/12;//targetdiameter
    tgdx = displayWidth/4;//x distance from target area
    x0 = displayWidth/2;//pixel coodrinates
    y0 = (displayHeight)-sd;//
  }else{
    //CHANGE VALUES ACCORDING TO ULTRASONIC RIG
    //IMPORTANT:
    //FUNCTIONS TO CHANGE CM TO PIXELS
    //DOUBLE CHECK TO MAKE SURE IF IT WORKS
    //cm is converted into pixel xy values , 
    //but outputted as cm values in the csv
    //OR, offline conversion can be done
    sd =  (usd/boxwidth)*displayWidth;//starting diameter size
    tgd = (utgd/boxwidth)*displayWidth;//target diameter size
    tgdx = (utgdx/boxwidth)*displayWidth;//target area x distance from center
    x0 = displayWidth/2;//pixel coodrinates for start area x
    y0 = (displayHeight)-sd;//initial start area y  
  }
//===========================================================
//Graphics
//===========================================================
  grid = loadImage(sketchPath()+"/graphics/grid.jpg");
  maus = new PImage[13];
  pushMatrix();
  cheese = loadImage(sketchPath()+"/graphics/cheese1.png");
  cheese.resize(int(tgd/2),0);
  for (int i =0; i<maus.length; i++){
    maus[i] = loadImage(sketchPath()+"/graphics/maus/maus"+ (i + 1) + ".png");
    maus[i].resize(maussize,0);
  }
  explosion = new PImage[20];
  for (int i =0; i<explosion.length; i++){
    explosion[i] = loadImage(sketchPath()+"/graphics/explosion/explosion"+ (i + 1) + ".png");
    explosion[i].resize(int(tgd*3),0);
  } 
  popMatrix();
  if (displayWidth>grid.width || displayHeight>grid.height){
  grid.resize(displayWidth,displayHeight);
  }
  imageMode(CENTER);
//===========================================================
//SOUNDS
//===========================================================
 minim = new Minim(this);
 nuke = minim.loadFile(sketchPath()+"/graphics/sounds/nuke.mp3");
 for (int i = 0; i<death.length; i++){
   death[i] = minim.loadFile(sketchPath()+"/graphics/sounds/dead"+ (i+1)+".mp3");
 }
  println(rindex);
  println(sp);
  println(rlist);
  println(rlistu);
  //==========================================================================
  //===============CSV STUFF==================================================
  //==========================================================================
  fileName = i + "v" + str(year())+"_"+mS+"_"+dS+"_"+str(hour())+"_"+str(minute());  

  output = createWriter("DataBuffer/trialdata/" + fileName+".csv");

  // header information for the file- contains the file name
  String header = str(year())+","+str(month())+","+str(day())+","+str(hour())+","+str(minute());
  output.println(header);
  output.flush();

  // information about what is in each column
  String firstLine = "timestamp, trialNum, blockWidth, reach, leftprob, subjpos, Rightorwrong, rpos, forageDist, totDist, optdist, diff, score";
  output.println(firstLine);
  output.flush(); 

  //position per millisecond
  fileName =  i + "," + "position" + "v"+str(year())+"_"+mS+"_"+dS+"_"+str(hour())+"_"+str(minute());    
  parameters = createWriter("DataBuffer/positiondata/" + fileName+"_p.csv");


  //information about what is in each column
  //trialNum = trial number;  blockwidth = blocksize(trials); rpos = correct target area 1=left,2=right
  String firstLineParam = "trialNum, blockWidth, MillisTime, rpos, reach, leftprob, px, py, startdiameter, targetdiameter, x0,y0, x1, y1,trialstate";
  parameters.println(firstLineParam);
  parameters.flush();
}
void draw(){
  background(0);
  tint(255,255);
  image(grid,displayWidth/2,displayHeight/2);
  if (ultrasonicmode == 0){//no ultrasonic; only computer mouse
    px = mouseX;
    py = mouseY;
    pvx = pmouseX;
    pvy = pmouseY;
  }else{//check here
      if (tvx != pxu){//store previous frame x
        pvx = tvx;
        tvx = pxu;
      }
      if (tvy != pyu){//store previous frame y
        pvy = tvy;
        tvy = pyu;
      }
      while (myPort.available() > 0) {
      myString = myPort.readStringUntil(lf);
      if (myString != null) {
        myString = trim(myString);
        String split[] = split(myString, ",");
        if (split.length == 2){
          //NEED TO CONVERT CM INTO PIXEL WIDTH HEIGHT
          pxu = float(split[1]);//x sensor facing left wall
          pyu = float(split[0]);// y sensor facing forward wall
          px = (pxu/boxwidth)*displayWidth;//
          py = (pxu/boxwidth)*displayHeight;//
        }
      }
    }
  }
  //===============================================================
  //===============================================================
//GRAPHICS
  //===============================================================
  //===============================================================
  if (graphics==1){
    if (ms > (2*maus.length)-1) ms =0;
    a = atan2(py - pvy,px - pvx) +(PI/2);
    if (tva != a){//value from previous frams
        pva = tva;
        tva = a;
    }
    pushMatrix();
    if (anreset==0 && anit>2){
            tint(255,127);
    }
    translate(px,py);
    if (px==pvx&& py==pvy){
      angle = pva; 
      rotate(angle);
      image(maus[0],0,0);
      //cursor(maus[0]);
    }else{
     angle = a;
     rotate(angle);
     image(maus[round(ms/2)],0,0);
     //cursor(maus[round(i/2)]);
    }
    popMatrix();
  ms++;
  fill(asdf);
  }
  ellipse(px,py,40,40);
  //===============================================================
  //===============================================================
  //===============================================================
  //===============================================================
  //text("anreset"+(anreset), (displayWidth*0.125), 280);
    //text("reach"+(rindex[rblock] +1), (displayWidth*0.125), 280);
  //text("points:" +points, (displayWidth*0.125), 300);
  text("trial:" +trialcnt, (displayWidth*0.125), 320);//trial
  text("points:" +points, (displayWidth*0.125), 340);//points
  text("xu" +x0u, (displayWidth*0.125), 360);
  text("rightorwrong: "+rightorwrong, (displayWidth*0.125), 380);
  //text("reach"+ r, (displayWidth*0.125), displayHeight-64);
  time = millis();
  //==========================================================================
  //===============TEXT&VARS==================================================
  //==========================================================================
  if (ultrasonicmode == 0){
    dista = sqrt(sq(mouseX - pmouseX)+sq(mouseY - pmouseY));
  }else{
    //STORE PREVIOUS FRAME'S XY VALUE
    //IF USING NOISY ULTRASONIC SENSOR, may want to implement moving average/thresholder
    //to account for noisy/constantly changing xy values, which will increase distance drastically
    dista = sqrt(sq(pxu - pvx)+sq(pyu - pvy));
  }
  if (trialstate == 2){
    fd += dista;
  }
  if (trialstate == 3){
    cd += dista;
  }
  if (practiceint<1){
    //"trialNum, blockWidth, MillisTime, rpos, reach, leftprob, MouseX, MouseY, startdiameter, targetdiameter, x0,y0, x1, y1,trialstate";
    if (ultrasonicmode == 0){
      paramData = int(trialcnt) + "," + int(bw) + "," + str(time) + "," + int(rpos) + "," + (rindex[rblock] +1) + "," + p + ","  
      + int(px) + "," + int(py) + "," + int(sd) + "," + int(tgd) + "," + int(x0) + "," + int(y0) + "," + int(x1) + "," + int(y1) + "," +int(trialstate);
    }else{
      //OUTPUT DATA IN CENTIMETERS
      paramData = int(trialcnt) + "," + int(bw) + "," + str(time) + "," + int(rpos) + "," + (rindex[rblock] +1) + "," + p + ","  
      + pxu + "," + pyu + "," + usd + "," + utgd + "," + x0u + "," + y0u + "," + x1u + "," + y1u + "," +int(trialstate);
    }
    parameters.println(paramData);
    parameters.flush();
  }
  if(practiceint>0){
    fill(col[rpos]);
    ellipse(x1,y1,tgd,tgd);
    fill(col[wpos]);
    ellipse(x2,y2,tgd,tgd);
    fill(255);
    textSize(32);
    text("practice= " + practiceint,(displayWidth*0.125),400);
  }
  if (flickerint>0){
    fill(col[rpos]);
    ellipse(x1,y1,tgd,tgd);    
  }
  if (flickerint>0){
    flickerint--;  
  }
  fill(255);
  if (trialstate >= 3) {
    text("go back to collection area", (displayWidth*0.125), 300);
    ellipse(x0, y0, sd, sd);
  }
  //==========================================================================
  //===============SWITCH CS==================================================
  //==========================================================================
  switch(trialstate){
    
    case 1://forage
      if (trialcnt <= maxtrials){
        if ((trialcnt % (bw+1)) == 0 && trialcnt>0){
          block = block + 1;
        }
        if ((trialcnt % (250+1)) == 0 && trialcnt>0){
          rblock = rblock + 1;
        }
        if (practiceint<1){
          p = sp[block];//prob left
          r  = rl[rblock];//reach rl in pixel values
          ru = rlu[rblock];// in cm
        }else{
          p = 1;//prob left
          r  = rl[rblock];//reach rl in pixel values
          ru = rlu[rblock];// in cm
        }
        if (random(1) <=p){
          rpos = 1;//left
          wpos = 2;
        }else{
          rpos = 2;//right
          wpos = 1;
        }
        if ((rindex[rblock] +1)==1){
          x1 = x0 + (2*tgdx*(rpos-1))-tgdx;
          y1 = y0 -r;
          x2 = x0 + (2*tgdx*(wpos-1))-tgdx;
          y2 = y0 -r;
          
          x1u = x0u + (2*utgdx*(rpos-1))-utgdx;
          y1u = y0u -ru;
          x2u = x0u + (2*utgdx*(wpos-1))-utgdx;
          y2u = y0u -ru;
        }else{
          x1 = x0 + (2*tgdx*(rpos-1))-tgdx;
          y1 = y0 + (rpos-2)*r - abs((rpos-1)*(min(rl)));
          x2 = x0 + (2*tgdx*(wpos-1))-tgdx;
          y2 = y0 + (wpos-2)*r - abs((wpos-1)*(min(rl)));
          
          x1u = x0u + (2*utgdx*(rpos-1))-utgdx;
          y1u = y0u + (rpos-2)*ru - abs((rpos-1)*(min(rlu)));
          x2u = x0u + (2*utgdx*(wpos-1))-utgdx;
          y2u = y0u + (wpos-2)*ru - abs((wpos-1)*(min(rlu)));
        }
        ppos = rpos;
        rightorwrong = 1;
        pnt = 1;
        fill(col[0]);
        ellipse(x0,y0,sd,sd);
        if (oncircler(x0, y0, sd) == true){
          trialstate = 2;
        }
      }else{        
        exit();
      }    
    break;
    
    case 2://forage
      if (trialcnt <= maxtrials){
        if (anit<explosion.length*2-1 && anreset==1){
          anit++;
          if (anit<40){
          nuke.play();
          death[0].play();
          death[0].rewind();
          tint(255,255);
          image(explosion[round(anit/2)],x2,y2);
          }
        }else{
          anreset = 0;
        }
        if (anreset==0 && anit>2 && trialstate==2){
          tint(255,255);
          image(explosion[19],x2,y2);
        }
        if (oncirclew(x2,y2,tgd)==true && graphics==1){//4*target diameter
          anreset=1;
        }
        if (oncirclew(x2,y2,4*tgd)==true){//4*target diameter
          ppos = wpos;
          rightorwrong = 0;
          pnt = 0;
        }
        if (oncircler(x1,y1,tgd)==true){
          flickerint = 15;
          trigtime = millis();
          trialstate = 3;
          //image(cheese,x1,y1);
        }
      }
    break;
    
    case 3:
      fill(col[0]);
      nuke.rewind();
      ellipse(x0,y0,sd,sd);
      if (rightorwrong==1){
      image(cheese,x0,y0);
      }
      if (ultrasonicmode == 0){
        optd = dist(x0,y0,x1,y1) - (sd+tgd)*0.5;
      }else{
        optd = dist(x0u,y0u,x1u,y1u) - (usd+utgd)*0.5;
      }
      totd = cd + fd;
      ddif = totd-optd;
      maxpoints = maxpoints + 100;
      //points = points + 100*((optd/totd))*pnt;
      if (oncircler(x0, y0, sd) == true){
        if (practiceint>0){
          practiceint--;
        }
        if (practiceint<1){
          //trialcnt++;
          if (trialcnt>0){
          points = points + 300*((optd/totd))*pnt;//award points based on combination of right trial
          //and user diff/optimal (MAY HAVE TO ADJUST WITH ULTRASONIC
          
          // "timestamp, trialNum, blockWidth, reach, leftprob, playerpos, Rightorwrong, rpos, forageDist, totDist, optdist, diff, score";
          data = time+","+ int(trialcnt)+","+ int(bw) + "," + (rindex[rblock] +1)+ "," + p + ","+ ppos + ","+ rightorwrong +","+rpos+","+fd+"," + totd
            + "," + optd+"," + ddif + "," +int(points);
            
          output.println(data);
          output.flush();
          }
          trialcnt++;
          cd = 0;
          fd = 0;
          totd = 0;
        }
        anit = 0;
        trialstate = 1;
      }
    break;
  }
}
//void keyPressed(){ testing purposes
//  if (show == true){
//    fill(125,125,255);
//    ellipse(x2,y2,5*tgd,5*tgd);
//    text("rpos: "+rpos, (displayWidth*0.125), 300);
//  }
//}
//==========================================================================
//===============ONLINE SORTING==================================================
//==========================================================================
boolean oncircler(float cx, float cy, float cd){//if on correct target area
  float dx = cx- px;
  float dy = cy - py;
  if (sqrt(sq(dx) + sq(dy)) < cd/2){
    return true;
  }else{
    return false;
  }
}
boolean oncirclew(float cx, float cy, float cd){//if on wrong target area
//bigger diameter than correct area
  float dx = cx- px;
  float dy = cy - py;
  if (sqrt(sq(dx) + sq(dy)) < cd/2){
    return true;
  }else{
    return false;
  }
}