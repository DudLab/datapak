import java.applet.Applet;
import java.awt.*;
import java.awt.event.*;
import java.awt.Robot;
import java.awt.event.InputEvent;
import java.util.*;
import processing.net.*; 
import processing.serial.*;
import javax.swing.*;
PrintWriter output;
PrintWriter parameters;
PImage target;
color startcolor = color(204, 153, 0);
color middle = color(204, 204, 255);
color cursor = color(255,255,255);
String inStr; 
String fileName;
String mS = " ";
String dS = " ";
String data = " ";
String paramData = " ";
String directoryName = "test";
String testsubjectname = " ";
String i = " ";
int trialcnt = 0;
int trialstate = 0;
int reachnum = 4;
int reachtot = reachnum +(reachnum-1);
int block = 0;
int blockwidth = 25; //25trial block
int tgw = 60; //targetwidths
int currdiam;//current circlediameter
int maxtrials = reachtot*blockwidth;
int cd[] = new int[reachtot]; //circle diameter
int cs = 80;//cursorsize
int wait = 2;
int reset = 0;
float x0 = displayWidth*0.5;
float y0 = displayHeight*0.5;
float dx;
float dy;
float dista;
float pdist = 0;
float doptimal;
long timer;
long time;
boolean show = false;
Robot robot;

void setup(){
  size(displayWidth, displayHeight);
  target = loadImage("target.png");
 try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 
  String preset="Type your name here";
  String op1s = JOptionPane.showInputDialog(frame, "Name", preset);
  if(op1s != null) i = op1s;
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
  try { 
    robot = new Robot();
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
  for (int l = 0; l<reachtot; l++){
    if (l<=reachnum-1){
      cd[l] = 120*l+150;
    }else{
      cd[l] = cd[reachnum-1] - 120*(l-(reachnum-1));
    }
  }
  println(cd);

  fileName = i + "v" + str(year())+"_"+mS+"_"+dS+"_"+str(hour())+"_"+str(minute());  
  output = createWriter("DataBuffer/data/trialdata/" + fileName+".csv");
  String header = str(year())+","+str(month())+","+str(day())+","+str(hour())+","+str(minute());
  output.println(header);
  output.flush();
  String firstLine = "timestamp, trialCnt, blockWidth, block, diameter,targetwidth, totdist, optdist";
  output.println(firstLine);
  output.flush(); 
  
  //POSDATA=========================================================================================  
  fileName =  i + "," + "position" + "v"+str(year())+"_"+mS+"_"+dS+"_"+str(hour())+"_"+str(minute());    
  parameters = createWriter("DataBuffer/data/posdata/" + fileName+"_p.csv");
  parameters.println(header);
  parameters.flush();
  String firstLineParam = "timestamp, trialcnt, block, diameter, mousex, mousey";
  parameters.println(firstLineParam);
  parameters.flush();
  
}
void draw(){
  time = millis();
  background(0);
  if (reset == 1){
    dista = sqrt(sq(mouseX-pmouseX)+sq(mouseY-pmouseY));//subject distance traveled
    pdist += dista;
  }
  fill(255);
  textSize(32);
  text("block: " + block,300,300);
  text("timer: " + timer,300,350);
  text("trials: " + trialcnt,300,370);
  text("reset: " + reset,300,390);
    text("pdist: " +pdist,300,410); 
  fill(middle);
  if (show == true){
    fill(middle);
    ellipse(displayWidth/2,displayHeight/2,currdiam*2,currdiam*2);
    fill(0,0,0);
    ellipse(displayWidth/2,displayHeight/2,currdiam*2-tgw,currdiam*2-tgw);
  }
  target.resize(80,0);
  imageMode(CENTER);
  image(target,mouseX,mouseY);
  fill(cursor);
  ellipse(mouseX,mouseY,15,15);
  switch(trialstate){
    
    case 0://practice/
      robot.mouseMove(displayWidth/2,(displayHeight/2)+45);
      pdist = 0;
      trialstate = 1;
    break;
    
    case 1://trials     
      if (trialcnt<maxtrials){
      //"timestamp, trialcnt, block, diameter, mousex, mousey"
        paramData = str(time) + "," + int(trialcnt) + "," + int(block) + "," + int(currdiam) + "," + int(tgw) + "," + int(mouseX) + "," + int(mouseY);
        parameters.println(paramData);
        parameters.flush();
        //dista = sqrt(sq(mouseX-pmouseX)+sq(mouseY-pmouseY));//subject distance traveled
        //pdist += dista;
        currdiam = cd[block];
        doptimal = currdiam-tgw;
        if (sqrt(sq(mouseX-(displayWidth/2))+ sq(mouseY-(displayHeight/2)))<(currdiam-tgw)){
          reset = 1;
        }
        if(onring(mouseX,mouseY,currdiam, tgw) == true){
          text("bt" ,200,200);
          timer++;
          if (reset == 1 && (timer % wait)==0){
            trialcnt = trialcnt + 1;
            data = str(time) + "," + int(trialcnt) + "," + int(blockwidth) + "," + int(block) + "," + int(currdiam) + "," + int(tgw) + "," + pdist + "," + doptimal;
            //"timestamp, trialCnt, blockWidth, block, diameter,targetwidth, totdist, optdist" 
            output.println(data);
            output.flush();
            reset = 0;
            trialstate = 2;
          }
        }else{
          timer = 0;
        }
      }else{
        exit();
      }
    break;
    
    case 2:
      if ((trialcnt % blockwidth)==0 && trialcnt>0){
        block = block + 1;
      }
      trialstate = 0;
      pdist = 0;
    break;
  }
}
//void keyPressed(){
//  show = true;
//}
//void keyReleased(){
//  show = false;
//}
boolean onring(float xx,float yy,int circlediameter, int tt){
  float disx = (displayWidth/2) - xx;//y0-px
  float disy = (displayHeight/2) - yy;//y0-py
  float dist = sqrt(sq(disx)+ sq(disy));
  if (dist<=circlediameter && dist>circlediameter-tt){
    return true;
  }else{
    return false;
  }
}