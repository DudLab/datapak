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
color startcolor = color(204, 153, 0);
color middle = color(204, 204, 255);
String inStr; 
String fileName;
String mS = " ";
String dS = " ";
String data = " ";
String paramData = " ";
String directoryName = "test";
String testsubjectname = " ";
FloatList circle_diameter;
int block = 0;
int blockwidth = 20;
int op1;
int confirmtime = 0;
int startdiameter = 60;
int ringnumbers;
int trialState;
int trialCnt = 0;
float d;
float a;
float x0;
float y0;
String i = " ";
long time;
long time1;
long time2;
long time3;
long time4;
boolean onRing=false;
boolean ringstate = false;
boolean startstate = false;
boolean trialstate = false;


void setup(){
      try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 
  String preset="Type your name here";
  String op1s = JOptionPane.showInputDialog(frame, "Name", preset);
  if(op1s != null) i = op1s;
 
  size(displayWidth, displayHeight);
  circle_diameter = new FloatList();
  circle_diameter.append(60);
  circle_diameter.append(90);
  circle_diameter.append(120);
  circle_diameter.shuffle();
  fileName = i + "v" + str(year())+"_"+mS+"_"+dS+"_"+str(hour())+"_"+str(minute());  

  output = createWriter("DataBuffer/" + fileName+".csv");

  // header information for the file- contains the file name
  String header = str(year())+","+str(month())+","+str(day())+","+str(hour())+","+str(minute());
  output.println(header);
  output.flush();

  // information about what is in each column
  String firstLine = "timestamp, trialNum, blockWidth, ringwidth, time, forageDistance, collectionDistance, totalDistance, optimalTotalDistance, Totaldifference, score";
  output.println(firstLine);
  output.flush(); 
  
  //position per millisecond
  fileName =  i + "," + "position" + "v"+str(year())+"_"+mS+"_"+dS+"_"+str(hour())+"_"+str(minute());    
  parameters = createWriter("DataBuffer/" + fileName+"_p.csv");


  String firstLineParam = "trialNum, blockWidth, MillisTime, pos, leftTriggerProbability, MouseX, MouseY, Start/CollectionDiameter, ForageDiameter, CircleX0, Circle Y0, CircleX1, CircleY1, CircleX2, CircleyY2, TrialState";
  parameters.println(firstLineParam);
  parameters.flush();    
}
void draw(){
  time=millis();
  background(0);
  x0 = displayWidth*0.5;
  y0 = displayHeight*0.5;
  fill(0,255,255);
  rect(x0-300,y0-300,30,confirmtime);
  fill(255);
  a =  startdiameter + d*ringnumbers;
  float disX = x0 - mouseX;
  float disY = y0 - mouseY;
  float cursorDistance =((sqrt(sq(disX) + sq(disY))));
  float innercircleDistance = a-d;
  textSize(16);
  fill(255, 255, 255, 150);
  text("hold the up key over the correct ring", (displayWidth*0.125), 120);  
  //text("TrialState", (displayWidth*0.125), 120);
  //text(trialState, (displayWidth*0.125),140);
  //text("Ring number", (displayWidth*0.125), 160);
  //text(ringnumbers, (displayWidth*0.125),180);
  //text("diameter", (displayWidth*0.125), 200);
  //text(a, (displayWidth*0.125),220);
  //text("innercircledistance", (displayWidth*0.125), 240);
  //text(innercircleDistance, (displayWidth*0.125),260);
  //text("cursordistance", (displayWidth*0.125), 280);
  //text(cursorDistance, (displayWidth*0.125),300);
  //text("time1", (displayWidth*0.125), 320);
  //text(time1,(displayWidth*0.125),340);
    fill(middle);
    ellipse(x0,y0,a,a);
  if (cursorDistance > innercircleDistance*0.5 && cursorDistance < 0.5*a) {
    onRing = true;

  }else{
    onRing = false;

  }
  if (trialCnt<2){
    fill(middle);
    ellipse(x0,y0,a,a);
    fill(0);
    ellipse(x0, y0, a-d, a- d);
    fill(startcolor);
    ellipse(x0,y0, startdiameter, startdiameter);
    
  }
  
  switch(trialState) {
    case 0:
      if ((trialCnt % blockwidth) == 0 && trialCnt>0){
        block = block + 1;
      }
      d = circle_diameter.get(block);
      if (cursorDistance < 0.5*startdiameter && confirmtime==60){
        startstate = true;
        trialState=1;
        fill(middle);
        ellipse(x0,y0,a,a);
        fill(0);
        ellipse(x0, y0, a-d, a- d);
        fill(startcolor);
        ellipse(x0,y0, startdiameter, startdiameter);            
        ringnumbers = 2;
        confirmtime=0;        
      }else{
        startstate = false;
      }    
      break;
    case 1:
      if (onRing == true && confirmtime==60){
        ringstate=true;
        ringnumbers = 4;                   
        trialState=2;
        fill(middle);
        ellipse(x0,y0,a,a);
        fill(0);
        ellipse(x0, y0, a-d, a- d);
        fill(startcolor);
        ellipse(x0,y0, startdiameter, startdiameter);
        confirmtime=0;    
      }else{
        ringstate=false;
      }    
      break;
    case 2:
    if (onRing == true && confirmtime==60){
      ringstate=true;
      ringnumbers = 6;            
      trialState=3;
      fill(middle);
      ellipse(x0,y0,a,a);
      fill(0);
      ellipse(x0, y0, a-d, a- d);
      fill(startcolor);
      ellipse(x0,y0, startdiameter, startdiameter);
      confirmtime=0;
    }else{
      ringstate=false;
    }   
    break;
    case 3:
      if (onRing == true && confirmtime==60){
        fill(middle);
        ellipse(x0,y0,a,a);
        fill(0);
        ellipse(x0, y0, a-d, a- d);
        fill(startcolor);
        ellipse(x0,y0, startdiameter, startdiameter);
        ringnumbers = 4;
        trialState=4;
        fill(middle);
        ellipse(x0,y0,a,a);
        fill(0);
        ellipse(x0, y0, a-d, a- d);
        fill(startcolor);
        ellipse(x0,y0, startdiameter, startdiameter);  
        confirmtime=0;        
      }else{
        ringstate=false;
      }      
      break;
    case 4:
      if (onRing == true && confirmtime==60){
        fill(middle);
        ellipse(x0,y0,a,a);
        fill(0);
        ellipse(x0, y0, a-d, a- d);
        fill(startcolor);
        ellipse(x0,y0, startdiameter, startdiameter);   
        ringnumbers = 2;
        trialState=5;
        fill(middle);
        ellipse(x0,y0,a,a);
        fill(0);
        ellipse(x0, y0, a-d, a- d);
        fill(startcolor);
        ellipse(x0,y0, startdiameter, startdiameter);
        confirmtime=0;           
      }else{
        ringstate=false;
      }   
      break;
      case 5:
        if (onRing == true && confirmtime==60){
          ringnumbers = 0;
          trialState=0;
          fill(middle);
          ellipse(x0,y0,a,a);
          fill(0);
          ellipse(x0, y0, a-d, a- d);
          fill(startcolor);
          ellipse(x0,y0, startdiameter, startdiameter);
          trialCnt++;
          confirmtime=0;
          data = str(time) + "," + int(trialCnt) + "," +;
          output.println(data);
          output.flush();
        }else{
          ringstate=false;
        }
        break;
      }
 subjectInput();     
}

boolean[] keys = new boolean[256];

void keyPressed() {
  keys[keyCode] = true;
};

void keyReleased() {
  keys[keyCode] = false;
  confirmtime = 0;
};
void subjectInput(){
  
  if (keys[UP] && pmouseX==mouseX && pmouseY==mouseY){
    if (confirmtime<60){
      confirmtime++;
    }
  }
  if (pmouseX>mouseX || pmouseX<mouseX || pmouseY>mouseY || pmouseY<mouseY){
    confirmtime=0;
  }
}