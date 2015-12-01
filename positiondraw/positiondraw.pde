import java.applet.Applet;
import org.gicentre.utils.stat.*;   
import org.gicentre.utils.colour.*;    
import java.awt.Color;                 
import java.awt.*;
import java.util.*;
import processing.net.*; 
import processing.serial.*;
import javax.swing.*; 
import java.io.*;

HScrollbar hs1, hs2;  // Two scrollbars     
ArrayList<pts> points;
String n = " ";
float zpos;
float x1;
float y1;
float x2;
float y2;
int op1;
float k;
 
void setup(){
  
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 
  String preset="Bailey Hwa,positionv2015_11_06_18_37_p.csv";
  String op1s = JOptionPane.showInputDialog(frame, "position_filename.csv", preset);
  if(op1s != null) n = op1s;
  size(displayWidth, displayHeight,P3D);
  hs1 = new HScrollbar(0, (displayHeight*0.5+200)-8, width, 16, 16);
  hs2 = new HScrollbar(0, (displayHeight*0.5+300)+8, width, 16, 16);     
    }
    
    void loadData(){
      String [] rows = loadStrings(n);
      float bar1Pos = 7.5*(hs1.getPos());    
      points = new ArrayList<pts>();
      if (keyPressed==true){
        if ((keyCode==UP) && (k<rows.length)){
          k++;
        }else if ((keyCode==DOWN) &&( k >0)){
          k--;
        }
      }
      for(int i = 1; i<k+bar1Pos; i++){
        if (i<rows.length){
          //split data
          String [] thisRow = split(rows[i], ",");
   
          // determine x, y, and milliseconds
          float newtrial = float(thisRow[0]);
          float newm = float(thisRow[2]);
          float newx = float(thisRow[5]);
          float newy = float(thisRow[6]);
          float newSdia = float(thisRow[7]);
          float newCdia = float(thisRow[8]);
          float newcirclex0 = float(thisRow[9]);
          float newcircley0 = float(thisRow[10]);
          float newcirclex1 = float(thisRow[11]);
          float newcircley1 = float(thisRow[12]);
          float newcirclex2 = float(thisRow[13]);
          float newcircley2 = float(thisRow[14]);
          pts b = new pts(newtrial, newx, newy, newm, newSdia, newCdia, newcirclex0, newcircley0, newcirclex1, newcircley1, newcirclex2, newcircley2);
          points.add(b);
        }
          
       

       
        }
    }
 
void draw(){

  background(0);
    loadData();
  float bar1Pos = hs1.getPos()-width/2;
      //float bar2Pos = hs1.getPos()-width/2;
  float dis = 100-sqrt(sq(bar1Pos-displayWidth*0.5));
  textAlign(CENTER);
  text("Movement Path", width/2, 100);
  text(bar1Pos, 100, 500);
  text(dis, 100, 520);
  hs1.update();
  hs2.update();
  hs1.display1();
  hs2.display1();
  for(pts thepoints: points)
  {
    thepoints.display();
  }
  for(int i = 0; i<points.size()-1; i++){
    
    pts thepoints = points.get(i);
    thepoints.display();
               
    pts thepoints2 = points.get(i+1);
    thepoints2.display();
    float d = i*0.017;
    float redcolor = 204-d;
    float greencolor = 204-d;
    float bluecolor;
    if (greencolor <= 0){
    bluecolor = 255-d;
    }else{
     bluecolor = 255;
    }
    stroke(redcolor, greencolor, bluecolor, 150);
    //stroke(204-i, 204-i, 255, 150);
    line(thepoints.x1x, thepoints.y1y, 
    thepoints2.x1x, thepoints2.y1y);
    //if (keyPressed==true){
    // stroke(204);
    // fill(102); 
    // ellipse( thepoints.x0a, thepoints.y0a, thepoints.Sdia1, thepoints.Sdia1);
    // fill(0, 3, 255);
    // ellipse( thepoints.x1a, thepoints.y1a, thepoints.Cdia1, thepoints.Cdia1);
    // fill(204, 153, 0);
    // ellipse( thepoints.x2a, thepoints.y2a, thepoints.Cdia1, thepoints.Cdia1);
    //}

    float disX = thepoints.x1x-mouseX;
    float disY = thepoints.y1y-mouseY;
    float disC = (sqrt(sq(disX) + sq(disY)));
    if (disC < 10){
      textSize(16);
      fill(255);
      text(thepoints.x1x, 100,120);
      text(thepoints.y1y, 100,140);
      text(thepoints.m1m, 100,160);
   
    }
    //if (keyPressed=true){
    //  loadData();
    //}
  }
}
 
class pts
{
 
  ArrayList <Float> n, x, y, m, Sdia, Cdia, x0, y0, x1, y1, x2, y2;
  float newtrial1newtrial;
  float x1x;
  float y1y;
  float m1m;
  float Sdia1;
  float Cdia1;
  float x0a;
  float y0a;
  float x1a;
  float y1a;
  float x2a;
  float y2a;
  
  
  pts(float newtrialin, float xin, float yin, float min, float Sdia2, float Cdia2, float x0in, float y0in, float x1in, float y1in, float x2in, float y2in)
  {
    n = new ArrayList<Float>();
    m = new ArrayList<Float>();
    x = new ArrayList<Float>();
    y = new ArrayList<Float>();
    Sdia = new ArrayList<Float>();
    Cdia = new ArrayList<Float>();
    x0 = new ArrayList<Float>();
    y0 = new ArrayList<Float>();
    x1= new ArrayList<Float>();
    y1 =  new ArrayList<Float>();
    x2 = new ArrayList<Float>();
    y2 = new ArrayList<Float>();
    
    n.add(newtrialin);
    m.add(min);
    x.add(xin);
    y.add(yin);
    Sdia.add(Sdia2);
    Cdia.add(Cdia2);
    x0.add(x0in);
    y0.add(y0in);
    x1.add(x1in);
    y1.add(y1in);
    x2.add(x2in);
    y2.add(y2in);

 
  }
 
  void display()
  {

 //draw line to connect points
      beginShape();  
      //fill(255);
      //stroke(255);
 
      for (int i =0; i<(x.size()); i++) {
        x1x= x.get(i);
        y1y=y.get(i);
        m1m=m.get(i);
        Sdia1= Sdia.get(i);
        Cdia1= Cdia.get(i);
        x0a=x0.get(i);
        y0a=y0.get(i);
        x1a=x1.get(i);
        y1a=y1.get(i);
        x2a=x2.get(i);
        y2a=y2.get(i);
        //stroke(204,204,255);
        strokeWeight(2);
        //fill(255);
        
        vertex(x1x,y1y);
      }
      endShape(CLOSE);
    }
  }


class HScrollbar {
  String [] rows = loadStrings(n);
  int swidth, sheight;    
  float xpos, ypos;       
  float spos, newspos;    
  float sposMin, sposMax; 
  int loose;            
  boolean over;   
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    //spos = xpos + swidth/2 - sheight/2;
    spos = 0;
    newspos = spos;
    sposMin = xpos;
    //sposMax = xpos + swidth - sheight;
    sposMax = rows.length -1;
    loose = l;

  }

void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }
  
   float constrain(float val, float minv, float maxv) {
   return min(max(val, minv), maxv);
  }
  
  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }
   void display1() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }
  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}