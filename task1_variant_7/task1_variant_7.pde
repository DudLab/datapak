//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Task 1; human ability to probabalistically infer, based on reward. HumanTrack code:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=


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


float forageDistance = 0;
float collectionDistance = 0;
float totalDistance = 0;
float optimalTotaldistance = 0;
float totalDifference = 0;
float [] display;

float x0;
float y0;

float x1;
float y1;
float x2;
float y2;
FloatList trig_prob;
int whichTrig;
int collectDiameter = 20;
int targetcircleDiameter = 150; 
int wrongcircleDiameter = 300;
int bottomRightX;
int bottomRightY;
int topLeftX;
int topLeftY;
int bottomRightX2;
int bottomRightY2;
int topLeftX2;
int topLeftY2;
int bottomRightXc;
int bottomRightYc;
int topLeftXc;
int topLeftYc;
int block = 0;
int blockWidth = 50;
int shiftstate = 0;
int textY = 120;
int trialState = 0;
int trialCnt = 0;
float maxpoints = 0;
float r = random(0, 1);
float p;
float randX1;
float randX2;
float randY1;
float randY2;
float pointsEarned = 0;
color inside = color(0, 3, 255);
color middle = color(204, 153, 0);
color outside = color(102, 0, 204);
color ellipseColor;
color rectColor;
color lineColor;

boolean up1;
boolean down1;
int right1wrong0;
int userchoice12;
int userchoiceleft;
int pos;
int rightORwrong;
int rewardpos;
boolean pos1;
boolean startstate = false;
boolean onStart = false;
boolean onCollection = false;
boolean trigState = false;
boolean collectState = false; 
boolean leftBox = false;
boolean rightBox=false;
boolean onwrongcircleright = false;
boolean onwrongcircleleft = false;
boolean wrong = false;
long trigTime = 0;
long time = 0;
String i = " ";





public void setup() {
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 
  String preset="Type your name here";
  String op1s = JOptionPane.showInputDialog(frame, "Name", preset);
  if (op1s != null) i = op1s;

  size(displayWidth, displayHeight);
  frameRate(50);
  rectColor = color(0);
  ellipseColor = color(51, 51, 255);
  lineColor = color (255, 255, 255);
  strokeWeight(0);

  //float p_pos = 0.5;
  //if (random(1) <= p_pos) {
  //  pos1 = true;
  //  pos = 1;
  //} else {
  //  pos1 = false;
  //  pos = 2;
  //}

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
  trig_prob = new FloatList();
  trig_prob.append(0.1);
  trig_prob.append(0.25);
  trig_prob.append(0.5);
  trig_prob.append(0.75);
  trig_prob.append(0.9);
  trig_prob.shuffle();






  // create a data file to keep track of data about behavioral performance (.csv)
  //  fileName = "v"+str(year())+"_"+str(month())+"_"+str(day())+"_"+str(hour())+"_"+str(minute());  

  fileName = i + "v" + str(year())+"_"+mS+"_"+dS+"_"+str(hour())+"_"+str(minute());  

  output = createWriter("DataBuffer/" + fileName+".csv");

  // header information for the file- contains the file name
  String header = str(year())+","+str(month())+","+str(day())+","+str(hour())+","+str(minute());
  output.println(header);
  output.flush();

  // information about what is in each column
  String firstLine = "timestamp, trialNum, blockWidth, position_number, LeftTriggerProbability, rightORwrong, Rewardposition, forageDistance, collectionDistance, totalDistance, optimalTotalDistance, Totaldifference, score";
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



void draw() {
  time= millis();
  background(0);
  x0 = (displayWidth*0.5);
  y0 = (900);


  fill(rectColor);
  stroke(255);
  ellipse(mouseX, mouseY, 20, 20);
  fill(outside);
  //ellipse(x0, y0,collectDiameter, collectDiameter);
  textSize(16);
  fill(255, 255, 255, 150);
  text("Trial", (displayWidth*0.125), textY);
  text(trialCnt+1, (displayWidth*0.125), textY + 20);
  text(testsubjectname, (displayWidth*0.125), textY + 180);
  text("maximum points", (displayWidth*0.125), textY + 200);
  text(maxpoints, (displayWidth*0.125), textY + 220);
  text("Your Points", (displayWidth*0.125), textY + 240);
  text(pointsEarned, (displayWidth*0.125), textY + 260);
  //text(p, (displayWidth*0.125), textY + 280);
  //text(rewardpos, (displayWidth*0.125), textY + 300);



  if (x1>0) {
    paramData = int(trialCnt+1) + "," + int(blockWidth) + "," + str(time) + "," + int(pos) + "," + p + ","  
      + int(mouseX) + "," + int(mouseY) + "," + int(collectDiameter) + "," + int(targetcircleDiameter) + "," + int(x0) + "," + int(y0) + ","+ int(x1) + "," + int(y1) + "," + int(x2) + "," + int(y2) + "," +int(trialState);
    parameters.println(paramData);
    parameters.flush();
  }
  if (trialState >= 3) {
    text("go back to collection area", (displayWidth*0.125), textY + 140);
    ellipse(x0, y0, collectDiameter, collectDiameter);
  }
  if (trialCnt >= 500) {
    exit();
  }
  switch(trialState) {

  case 0:
    collectionDistance=0;
    optimalTotaldistance=0;
    collectionDistance = 0;
    totalDistance=0;
    ellipse(x0, y0, collectDiameter, collectDiameter);
    startstate=false;
    if (onStart(x0, y0, collectDiameter)) {
      startstate= true;
      trialState=1;
    } else {
      startstate=false;
    }
    break;

  case 1:
    trigState = false;
    rightORwrong = 1;
    userchoiceleft = 1;
    if (trialCnt>250) {
      shiftstate=1;
    }else{
      shiftstate=0;
    }
    if (shiftstate==0) {
      pos = 1;
      x1 = x0 - 300;
      y1 = y0 - 400;
      x2 = x0 + 300;
      y2 = y0 - 400;
    }
    
    if (shiftstate==1) {
      pos = 2;
      x1 = x0 - 300;
      y1 = y0 - 750;
      x2 = x0 + 300;
      y2 = y0 - 400;
    }
    
    if ((trialCnt % blockWidth) == 0 && trialCnt>0) {
      block = block + 1;
    }

    p = trig_prob.get(block);
    i = testsubjectname;
    //left reward probability of returning true
    if (random(1) <= p) {
      leftBox = true;
      optimalTotaldistance =2*(dist(x1, y1, x0, y0)-((collectDiameter+targetcircleDiameter)*0.5));
      rewardpos = 1;
      rightBox = false;
    } else {
      leftBox = false;
      optimalTotaldistance =2*(dist(x2, y2, x0, y0)-((collectDiameter+targetcircleDiameter)*0.5));
      rewardpos = 2;
      rightBox = true;
    }

    trialState = 2;
    forageDistance = 0;
    break;

  case 2:
    onCollection = false;
    wrong = false;
    forageDistance = forageDistance + dist(mouseX, mouseY, pmouseX, pmouseY);
    time=millis();

    if (trialCnt<11 || trialCnt > 250 && trialCnt < 261) {
      stroke(240, 180, 0, 100);
      //fill(0, 3, 255);
      //ellipse(x1, y1, wrongcircleDiameter, wrongcircleDiameter);
      fill(inside);
      strokeWeight(0);
      ellipse(x1, y1, targetcircleDiameter, targetcircleDiameter);

      //left box
      stroke(240, 180, 0, 100);
      //stroke(0, 180, 240, 100);
      //fill(0, 3, 255);
      //ellipse(x2, y2, wrongcircleDiameter, wrongcircleDiameter);
      fill(middle);
      strokeWeight(0);
      ellipse(x2, y2, targetcircleDiameter, targetcircleDiameter);
    }

    if (leftBox == true) { //e: left trigger box
      whichTrig = 0;
      if (onwrongcircleright(x2, y2, wrongcircleDiameter)) {
        //wrong = true;
        rightORwrong = rightORwrong -1;
        userchoiceleft = userchoiceleft-1;
      }

      if (onCircleLeft(x1, y1, targetcircleDiameter)) {
        trigState = true;
        trialState = 3; 
        trigTime = millis();
        stroke(240, 180, 0, 100);
        //stroke(0, 180, 240, 100);
        fill(153, 255, 255);
        strokeWeight(0);
        ellipse(x1, y1, targetcircleDiameter, targetcircleDiameter);
      } else {
        trigState = false;
      }
      break;
    }
    if (rightBox==true) {
      //e: right trigger area
      whichTrig = 1;
      if (onCircleRight(x2, y2, targetcircleDiameter)) {
        userchoiceleft = userchoiceleft-1;
      }
      if (onwrongcircleleft(x1, y1, wrongcircleDiameter)) {
        rightORwrong = rightORwrong - 1;
      }
      if (onCircleRight(x2, y2, targetcircleDiameter)) {
        trigState = true;
        trialState = 3; 
        trigTime = millis();
        stroke(240, 180, 0, 100);
        //stroke(0, 180, 240, 100);
        fill(153, 255, 255);
        strokeWeight(0);
        ellipse(x2, y2, targetcircleDiameter, targetcircleDiameter);
      } else {
        trigState = false;
      }
      break;
    }

  case 3: // 'collect'
    trigState=false;
    collectionDistance = collectionDistance + dist(mouseX, mouseY, pmouseX, pmouseY);
    totalDistance = collectionDistance+forageDistance;
    totalDifference = totalDistance-optimalTotaldistance;
    if (onCollection(x0, y0, collectDiameter)) {
      collectState = true;
      trialState=1;
      trialCnt++;
      if (rightORwrong >0) {
        right1wrong0 = 1;
      } else { 
        right1wrong0= 0;
      }
      if (userchoiceleft>0) {
        userchoice12 = 1;
      } else { 
        userchoice12= 0;
      }
      maxpoints = maxpoints + 100;
      pointsEarned = pointsEarned + 100*((optimalTotaldistance/totalDistance));
      data = str(time)+","+ int(trialCnt)+","+ int(blockWidth) + "," + int(pos) + "," + p + ","+ right1wrong0 + ","+ int(rewardpos) +","+int(forageDistance)+","+int(collectionDistance)+"," + int(totalDistance) 
        + "," + int(optimalTotaldistance)+"," + int(totalDifference) + "," +int(pointsEarned);
      output.println(data);
      output.flush();
    } else {
      collectState = false;
    }
    break;
  }
}
//===============================================================
//Trigger conditions      
//===============================================================
boolean onCircleLeft(float x1, float y1, int diameter) {
  float disX = x1 - mouseX;
  float disY = y1 - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
boolean onwrongcircleright(float x2, float y2, int diameter) {
  float disX = x2 - mouseX;
  float disY = y2 - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
boolean onwrongcircleleft(float x1, float y1, int diameter) {
  float disX = x1 - mouseX;
  float disY = y1 - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
boolean onCircleRight(float x2, float y2, int diameter) {
  float disX = x2 - mouseX;
  float disY = y2 - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
boolean onStart(float x0, float y0, int diameter) {
  float disX = x0 - mouseX;
  float disY = y0 - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
boolean onCollection(float x0, float y0, int diameter) {
  float disX = x0 - mouseX;
  float disY = y0 - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}