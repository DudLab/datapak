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
int practiceint = 1;
int blockwidth = 20;
int op1;
int confirmtime = 0;
int startdiameter = 60;
int ringint = 60;
int ringnumbers;
int ringnumbers1;
int trialState;
int trialCnt = 0;
int resetint = 0;
int outguessint = 0;
int inguessint = 0;
int totguessint = outguessint + inguessint;
int direc = 1;
float circlediameter;
float flickerint = 10;
float d;
float a;
float b;
float x0;
float y0;
float outdist = 0;
float indist = 0;
float totdist = outdist + indist;
String i = " ";
long time = 0;
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
  circle_diameter.append(90);
  circle_diameter.append(120);
  circle_diameter.append(150);
  circle_diameter.shuffle();
  fileName = i + "v" + str(year())+"_"+mS+"_"+dS+"_"+str(hour())+"_"+str(minute());  

  output = createWriter("DataBuffer/" + fileName+".csv");

  // header information for the file- contains the file name
  String header = str(year())+","+str(month())+","+str(day())+","+str(hour())+","+str(minute());
  output.println(header);
  output.flush();

  // information about what is in each column
  String firstLine = "timestamp, trialCnt, blockWidth, trialstate, diameter, ringdist, direc, guessoutward, guessinward, totalguess, outwarddist, inwarddist, totdist";
  output.println(firstLine);
  output.flush(); 
  
  //position per millisecond
  fileName =  i + "," + "position" + "v"+str(year())+"_"+mS+"_"+dS+"_"+str(hour())+"_"+str(minute());    
  parameters = createWriter("DataBuffer/" + fileName+"_p.csv");

  String firstLineParam = "timestamp, trialCnt, blockWidth, trialstate, diameter, ringdist, direc, mousex, mousey";
  parameters.println(firstLineParam);
  parameters.flush();  
}
void draw(){
  time=millis();
  background(0);
  x0 = displayWidth*0.5;
  y0 = displayHeight*0.5;
  fill(0,255,255);
  rect(x0-400,y0-400,30,confirmtime);
  fill(255);
  b = startdiameter + d*ringnumbers1;   
  a =  startdiameter + d*ringnumbers;
  circlediameter = (startdiameter + (6*ringnumbers));
  float disX = x0 - mouseX;
  float disY = y0 - mouseY;
  float cursorDistance =((sqrt(sq(disX) + sq(disY))));
  float innercircleDistance = a*.5-ringint;
  if (cursorDistance > innercircleDistance && cursorDistance < a*.5
  && pmouseX==mouseX && pmouseY==mouseY && confirmtime == 60) {    
    onRing = true;
  }else{
    onRing = false;

  }
  if (practiceint<1){
    d = circle_diameter.get(block);
    paramData = str(time) + "," + int(trialCnt) + "," + int(blockwidth) + "," + int(trialstate) + "," + circlediameter  + "," +
    d  + "," + int(direc) + "," + int(mouseX) + "," + int(mouseY); 
    parameters.println(paramData);
    parameters.flush();
    
  }else{
    fill(middle);
    ellipse(x0,y0,a,a);
    fill(0);
    ellipse(x0, y0, innercircleDistance, innercircleDistance);
    fill(startcolor);
    ellipse(x0,y0, startdiameter, startdiameter);    
    d = 75;
  }
  if (flickerint>0){
    fill(middle);
    ellipse(x0,y0,b,b);
    fill(0);
    ellipse(x0, y0, 2*(b*.5-ringint), 2*(b*.5-ringint));
    fill(startcolor);
    ellipse(x0,y0, startdiameter, startdiameter);    
    flickerint--;
  }  
  if (trialState>3){
    direc = -1;
  }else{
    direc = 1; 
  }
  if (direc == -1){
    text("move inwards", (x0-500),y0+90);    
  }
  if (direc == 1){
    text("move outwards", (x0-500),y0+90);    
  } 
  textSize(16);
  fill(255, 255, 255, 150);  
  if (mousePressed==true){
    fill(middle);
    ellipse(x0,y0,a,a);
    fill(0);
    ellipse(x0, y0, 2*innercircleDistance, 2*innercircleDistance);
    fill(startcolor);
    ellipse(x0,y0, startdiameter, startdiameter);
  }
  text("hold the UP key over the correct ring staying still", (displayWidth*0.125), 120);  
  text("Trialcnt:"+ trialCnt, (x0-400), y0);
  text("CursorDistance" + cursorDistance, (x0-500), y0+30);
  text("innercircledistance:" + innercircleDistance, (x0-500),y0+60);
  text("flickerint:" + flickerint, (x0-500),y0+80);  
  fill(startcolor);
  ellipse(x0,y0,startdiameter,startdiameter);
  
  switch(trialState) {
    case 0:
      if (onRing == true){
        startstate = true;
        trialState=1;
        ringnumbers1=0;
        flickerint = 10;    
        ringnumbers = 2;
        confirmtime=0;      
      }else{
        startstate = false;
      }    
      break;
    case 1:
      if ((trialCnt % blockwidth) == 0 && trialCnt>0){
        block = block + 1;
      }
      outdist = outdist + dist(mouseX, mouseY, pmouseX, pmouseY);    
      if (onRing == true){
        ringnumbers1 = 2;
        flickerint = 10;
        trialState=2;        
        ringnumbers = 4;                   
        confirmtime=0;    
      }    
      break;
    case 2:
      outdist = outdist + dist(mouseX, mouseY, pmouseX, pmouseY);    
      if (onRing == true){
        ringnumbers1=4;
        flickerint = 10;
        trialState = 3;        
        ringnumbers = 6;            
        confirmtime=0;
      } 
      break;
    case 3:
      outdist = outdist + dist(mouseX, mouseY, pmouseX, pmouseY);    
      if (onRing == true){
        ringnumbers1=6;
        flickerint = 10;
        trialState=4;      
        ringnumbers = 4;
        confirmtime=0;        
      }     
      break;
    case 4:
      indist = indist + dist(mouseX, mouseY, pmouseX, pmouseY);       
      if (onRing == true){
        ringnumbers1=4;
        flickerint = 10;  
        trialState=5;
        ringnumbers = 2;
        confirmtime=0;           
      }  
      break;
      case 5:
        indist = indist + dist(mouseX, mouseY, pmouseX, pmouseY);         
        if (onRing == true){
          ringnumbers1=2;
          flickerint = 10;
          trialState = 6;
          ringnumbers = 0;   
        }else{
          ringstate=false;
        }
        break;
    case 6:
      indist = indist + dist(mouseX, mouseY, pmouseX, pmouseY);  
      if (onRing == true){
        ringnumbers1= 0;           
        flickerint = 10;
        trialState = 1;  
        ringnumbers = 2;      
        confirmtime=0;
        practiceint--;
        if (practiceint<1){
        trialCnt++;
        data =str(time) + "," + int(trialCnt) + "," + int(blockwidth) + "," + int(trialstate) + "," + circlediameter  + "," + d  
        + "," + int(direc) + "," + int(outguessint) + "," + int(inguessint) + "," + int(totguessint) + "," + int(outdist) + "," + int(indist) + "," + int(totdist);
        output.println(data);
        output.flush();
        }     
        outdist = 0;
        indist = 0;     
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
  resetint = 1;
};
void subjectInput(){
  if (confirmtime>59 || pmouseX>mouseX || pmouseX<mouseX || pmouseY>mouseY || pmouseY<mouseY) confirmtime=0;
  if (keys[UP] && pmouseX==mouseX && pmouseY==mouseY && resetint == 1){
    if (confirmtime<60){
      confirmtime++;
    }
    if (confirmtime==60){
      if (trialState>3){
        inguessint = inguessint + 1;
      }else{
        if (trialState>0){
          outguessint = outguessint + 1;
        }        
      }
      resetint = 0;
    }
  }
}