import processing.serial.*; //<>// //<>//
import javax.swing.*;
import java.awt.*;
import java.util.*;
PrintWriter output; 
String fileName;
String mS = " ";
String dS = " ";
String data = " ";
String i = " ";
long time;
int lf = 10;// Linefeed in ASCII
int  start = 0;
float vx;
float avx;
float pvx;
float tvx;
float vy;
float avy;
float pvy;
float tvy;
String myString = null;
Serial myPort;  // The serial port


void setup() {
  size(800,600);
  try{
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());    
  }catch(Exception e){
    e.printStackTrace();
  }
  String preset="Type your unique identifier";
  String op1s = JOptionPane.showInputDialog(frame, "Identifier", preset);
  if (op1s != null) i = op1s;
    //int d = day(); 
  //if (d<10) {
  //  dS = '0'+str(d);
  //} else {
  //  dS = str(d);
  //}
  //int m = month();
  //if (m<10) {
  //  mS = "0"+str(m);
  //} else {
  //  mS = str(m);
  //}
  // List all the available serial ports
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.clear();
  myString = myPort.readStringUntil(lf);
  myString = null;
  //TESTING
  fileName = i;  

  output = createWriter("DataBuffer/" + fileName+".csv");

  // header information for the file- contains the file name
  //String header = str(year())+","+str(month())+","+str(day())+","+str(hour())+","+str(minute());
  //String header = i;
  //output.println(header);
  output.flush();
  pvx = vx;
}
 
void draw() {
  time = millis();
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      myString = trim(myString);
      String split[] = split(myString, ",");
      if (split.length == 2){
      //if (abs(vx-pvx)>0.2){
        vx = float(split[1]);
        vy = float(split[0]);
        //if (start == 1){
          //fill(255);
          //textSize(20);
          //text("OK",400,300);
        data = time+","+float(split[0]);
        output.println(data);
        output.flush();
        //}
      //}else{
      //  vx = float(split[1]);//float(floor(float(String.format("%.2f", ((pvx+float(split[1]))/2)))*10))/10;
      //}
      //if(abs(vy-pvy)>0.2){
      //  vy = float(split[0]);
      //}else{
      //  vy = float(split[0]);//float(floor(float(String.format("%.2f", ((pvy+float(split[0]))/2)))*10))/10;
      //}
      //if (tvx != vx){
      //  pvx = tvx;
      //  tvx = vx;
      //}
      //if (tvy != vy){
      //  pvy = tvy;
      //  tvy = vy;
      //}
      println("c: "+ vx +"," +"p: "+ pvx + ","+ "c: "+ vy +"," +"p: "+ pvy);
      }
    }
  }
  background(0);
  //fill(255);
  //rect((width/2), (height/2)+ (vy*5), 30, 30); //-(vx*5)
}