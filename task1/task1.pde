//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Task 1; 4thresh 5 probs
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//monitor of 27inch x 19.5
import controlP5.*;
import java.applet.Applet;
import java.awt.*;
import java.util.*;
import processing.net.*; 
import processing.serial.*;
import javax.swing.*; 


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
int pn = 5; //number of probabilities
int rnum = 2;// number of reaches
int rdt = 350;
int rlefty[] = new int[rnum];//reach distance list of left
int block = 0;
int rblock = 0;
int bw = 50;//blockwidth ORIGINAL 25
int blocktot = pn*rnum;
int maxtrials = blocktot*bw;
IntList pp;//prob randomly shuffled
IntList rp;//reach randomly shuffled
int trialstate = 1;// forage, collect soforth
int trialcnt = 0;
int pnt;//points
int offset = displayHeight/20;
int sd = displayWidth/20;//displayWidth/10;// startdiameter60
int tgd = displayWidth/10;//targetdiameter150
float dista;
float fd = 0;//foragedistance
float cd = 0;//collectdistance
float rightorwrong = 0;
float totd = 0;//totaldistance
float optd = 0;//optimaldistance
float ddif = 0;//difference subjectd - optd
int x0 = displayWidth/2;//init starting position
float y0;//or lower
float x1;
float y1;
float x2;
float y2;
float tgdx = displayWidth/4;//distance between targets
float problist[] = {0.1,0.25,0.5,0.75,0.9};
float rlist[] = {sqrt(pow((displayHeight*0.40),2)-pow((displayWidth/4),2))
, sqrt(pow(((displayHeight*0.40)*2),2)-pow((displayWidth/4),2))};
float [] reachposy = {};
float p;
float r;
float sp[] = new float[pn*rnum];
float rl[] = new float[rnum];
float rindex[] = new float[rnum];
float px;
float py;

int flickerint=0;
int rpos;//left or right
int wpos;// wrongpos
int ppos;
int ultrasonicmode = 0;
int practiceint=10;
float points = 0;
float maxpoints;
color start = color(255,0,0);
color left = color(51,51,255);
color right = color(255,255,51);
color[] col = {color(255,0,0),color(51,51,255),color(255,255,51)};
long time = 0;
long trigtime = 0;

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
  //===============SHUFFLE PROBABILIIES=====================================
  //========================================================================
  pp = new IntList();
  rp = new IntList();
  float rlist[] = {sqrt(pow((displayHeight*0.35),2)-pow((displayWidth/10),2))
  , sqrt(pow(((displayHeight*0.35)*2),2)-pow((displayWidth/10),2))};
  IntList tempr  = new IntList();
  for (int c = 0; c < rnum; c++){
    IntList temp = new IntList();
    //IntList tempr  = new IntList();
    rlefty[c] = rdt*(c);
    tempr.append(c);
    for (int r =0; r<pn; r++){
        temp.append(r);
    }
    temp.shuffle();//if want random
    pp.append(temp);
    //rp.append(tempr);
  }
  tempr.shuffle();
  rp.append(tempr);
  for (int i = 0; i < rp.size(); i++){
    rl[i] = rlist[rp.get(i)];
    rindex[i] = rp.get(i);
  }
  for (int i = 0; i < pp.size(); i++){
      sp[i] = problist[pp.get(i)];
    
  }
  println(rindex);
  println(sp);
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
  String firstLineParam = "trialNum, blockWidth, MillisTime, rpos, reach, leftprob, MouseX, MouseY, startdiameter, targetdiameter, x0,y0, x1, y1,trialstate";
  parameters.println(firstLineParam);
  parameters.flush();
}
void draw(){
  background(0);
  if (ultrasonicmode == 0){
    px = mouseX;
    py = mouseY;
  }else{
  }
  text("rpos: "+rpos, (displayWidth*0.125), 300);
  text("trial:" +trialcnt, (displayWidth*0.125), 320);
  text("block:" +block, (displayWidth*0.125), 340);
  text("dist:" +dista, (displayWidth*0.125), 360);
  text("rightorwrong: "+rightorwrong, (displayWidth*0.125), 380);
  text("reach"+ r, (displayWidth*0.125), displayHeight-64);
  time = millis();
  sd =  displayWidth/12;//displayWidth/10;// startdiameter60
  tgd = displayWidth/12;
  tgdx = displayWidth/4;
  x0 = displayWidth/2;
  y0 = (displayHeight)-sd;
  offset = displayHeight/20;
  //==========================================================================
  //===============TEXT&VARS==================================================
  //==========================================================================
  if (ultrasonicmode == 0){
    dista = sqrt(sq(mouseX - pmouseX)+sq(mouseY - pmouseY));
  }
  if (trialstate == 2){
    fd += dista;
  }
  if (trialstate == 3){
    cd += dista;
  }
  if (practiceint<1){
    //"trialNum, blockWidth, MillisTime, rpos, reach, leftprob, MouseX, MouseY, startdiameter, targetdiameter, x0,y0, x1, y1,trialstate";
    paramData = int(trialcnt) + "," + int(bw) + "," + str(time) + "," + int(rpos) + "," + (rindex[rblock] +1) + "," + p + ","  
      + int(px) + "," + int(py) + "," + int(sd) + "," + int(tgd) + "," + int(x0) + "," + int(y0) + "," + int(x1) + "," + int(y1) + "," +int(trialstate);
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
    text("go back to collection area", (displayWidth*0.125), displayHeight-64);
    ellipse(x0, y0, sd, sd);
  }
  //==========================================================================
  //===============SWITCH CS==================================================
  //==========================================================================
  switch(trialstate){
    
    case 1://forage
      if (trialcnt < maxtrials){
        if ((trialcnt % bw) == 0 && trialcnt>0){
          block = block + 1;
        }
        if ((trialcnt % bw*pn) == 0 && trialcnt>0){
          rblock = rblock + 1;
        }
        if (practiceint<1){
          p = sp[block];//prob left
          r  = rl[rblock];//reach rl
        }else{
          p = 1;//prob left
          r  = rl[rblock];//reach rl          
        }
        if (random(1) <=p){
          rpos = 1;//left
          wpos = 2;
        }else{
          rpos = 2;//right
          wpos = 1;
        }
        if (rblock<1){
          x1 = x0 + (2*tgdx*(rpos-1))-tgdx;
          y1 = y0 -r;
          x2 = x0 + (2*tgdx*(wpos-1))-tgdx;
          y2 = y0 -r;
        }else{
          x1 = x0 + (2*tgdx*(rpos-1))-tgdx;
          y1 = y0 + (rpos-2)*r;
          x2 = x0 + (2*tgdx*(wpos-1))-tgdx;
          y2 = y0 + (wpos-2)*r;
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
      if (trialcnt < maxtrials){       
        if (oncirclew(x2,y2,4*tgd)==true){//4*target diameter
          ppos = wpos;
          rightorwrong = 0;
          pnt = 0;
        }
        if (oncircler(x1,y1,tgd)==true){
          flickerint = 15;
          trigtime = millis();
          trialstate = 3;
        }
      }
    break;
    
    case 3:
      fill(col[0]);
      ellipse(x0,y0,sd,sd);
      optd = dist(x0,y0,x1,y1) - (sd+tgd)*0.5;
      totd = cd + fd;
      ddif = totd-optd;
      maxpoints = maxpoints + 100;
      points = points + 100*((optd/totd))*pnt;
      if (oncircler(x0, y0, sd) == true){
        if (practiceint>0){
          practiceint--;
        }
        if (practiceint<1){
          //trialcnt++;
          if (trialcnt>0){
          // "timestamp, trialNum, blockWidth, reach, leftprob, playerpos, Rightorwrong, rpos, forageDist, totDist, optdist, diff, score";
          data =time+","+ int(trialcnt)+","+ int(bw) + "," + (rindex[rblock] +1)+ "," + p + ","+ ppos + ","+ rightorwrong +","+rpos+","+int(fd)+"," + int(totd)
            + "," + int(optd)+"," + int(ddif) + "," +int(points);
            
          output.println(data);
          output.flush();
          }
          trialcnt++;
          cd = 0;
          fd = 0;
          totd = 0;
        }
        trialstate = 1;
      }
    break;
  }
}
//void keyPressed(){
//  if (key == CODED){
//    if (keyCode == UP && block <pn*rnum){
//      block++;
//    }
//    if (keyCode == DOWN && block > 0){
//      block--;
//    }
//  }
//}
boolean oncircler(float cx, float cy, int cd){
  float dx = cx- px;
  float dy = cy - py;
  if (sqrt(sq(dx) + sq(dy)) < cd/2){
    return true;
  }else{
    return false;
  }
}
boolean oncirclew(float cx, float cy, int cd){
  float dx = cx- px;
  float dy = cy - py;
  if (sqrt(sq(dx) + sq(dy)) < cd/2){
    return true;
  }else{
    return false;
  }
}