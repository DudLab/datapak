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
boolean overcircle1;
boolean overcircle2;
boolean overcircle3;
boolean overcircle4;
boolean overcircle5;
boolean overcircle6;
int circle0Diameter;
int circle1Diameter;
int circle2Diameter;
int circle3Diameter;
int block = 0;
int op1;
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


  //information about what is in each column
    //e: whichTrig = 0 for left and 1 for right
    //e: leftProb = probability that trigger is at left box
  String firstLineParam = "trialNum, blockWidth, MillisTime, pos, leftTriggerProbability, MouseX, MouseY, Start/CollectionDiameter, ForageDiameter, CircleX0, Circle Y0, CircleX1, CircleY1, CircleX2, CircleyY2, TrialState";
  parameters.println(firstLineParam);
  parameters.flush();    
}
void draw(){
  time=millis();
  background(0);
  x0 = displayWidth*0.5;
  y0 = displayHeight*0.5;

  fill(255);
  a =  startdiameter + d*ringnumbers;
  float disX = x0 - mouseX;
  float disY = y0 - mouseY;
  float cursorDistance =((sqrt(sq(disX) + sq(disY))));
  float innercircleDistance = a-d;
  textSize(16);
  fill(255, 255, 255, 150);
  text("TrialState", (displayWidth*0.125), 120);
  text(trialState, (displayWidth*0.125),140);
  text("Ring number", (displayWidth*0.125), 160);
  text(ringnumbers, (displayWidth*0.125),180);
  text("diameter", (displayWidth*0.125), 200);
  text(a, (displayWidth*0.125),220);
  text("innercircledistance", (displayWidth*0.125), 240);
  text(innercircleDistance, (displayWidth*0.125),260);
  text("cursordistance", (displayWidth*0.125), 280);
  text(cursorDistance, (displayWidth*0.125),300);
  text("time1", (displayWidth*0.125), 320);
  text(time1,(displayWidth*0.125),340);
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
          if ((trialCnt % 20) == 0 && trialCnt>0){
            block = block + 1;
          }
          d = circle_diameter.get(block);
          if (cursorDistance < 0.5*startdiameter && keyPressed==true){
            startstate = true;
            trialState=1;
            fill(middle);
            ellipse(x0,y0,a,a);
            fill(0);
            ellipse(x0, y0, a-d, a- d);
            fill(startcolor);
            ellipse(x0,y0, startdiameter, startdiameter);            
            ringnumbers = 2;
          }else{
            startstate = false;
          }
          break;
      case 1:
          
          if (onRing == true && keyPressed==true){
            ringstate=true;
            //time1 =0;
            ringnumbers = 4;                      
            trialState=2;
            fill(middle);
            ellipse(x0,y0,a,a);
            fill(0);
            ellipse(x0, y0, a-d, a- d);
            fill(startcolor);
            ellipse(x0,y0, startdiameter, startdiameter);            
          }else{
            ringstate=false;
          }
          break;
      case 2:
          if (onRing == true && keyPressed==true){
            ringstate=true;
            //time1 =0;
            ringnumbers = 6;            
            trialState=3;
            fill(middle);
            ellipse(x0,y0,a,a);
            fill(0);
            ellipse(x0, y0, a-d, a- d);
            fill(startcolor);
            ellipse(x0,y0, startdiameter, startdiameter);                        
          }else{
            ringstate=false;
          }
          break;
      case 3:
          if (onRing == true && keyPressed==true){
                        fill(middle);
            ellipse(x0,y0,a,a);
            fill(0);
            ellipse(x0, y0, a-d, a- d);
            fill(startcolor);
            ellipse(x0,y0, startdiameter, startdiameter);   
          //time1 =0;
          ringnumbers = 4;
          trialState=4;
            fill(middle);
            ellipse(x0,y0,a,a);
            fill(0);
            ellipse(x0, y0, a-d, a- d);
            fill(startcolor);
            ellipse(x0,y0, startdiameter, startdiameter);                      
          }else{
            ringstate=false;
          }
          break;
      case 4:
          if (onRing == true && keyPressed==true){
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
          }else{
            ringstate=false;
          }
          break;
      case 5:
          if (onRing == true && keyPressed==true){
          //time1 =0;
          ringnumbers = 0;
          trialState=0;
            fill(middle);
            ellipse(x0,y0,a,a);
            fill(0);
            ellipse(x0, y0, a-d, a- d);
            fill(startcolor);
            ellipse(x0,y0, startdiameter, startdiameter);
            trialCnt++;
            //output.println(data);
            //output.flush();
          }else{
            ringstate=false;
          }
          break;
        }
            
      //case 6:
      //case 7:
      //case 8:
      //case 9:
      //case 10:
      //case 11:
      //case 12:

}