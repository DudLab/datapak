import processing.serial.*; //<>//
 
int lf = 10;// Linefeed in ASCII
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
  background(0);
  // List all the available serial ports
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.clear();
  myString = myPort.readStringUntil(lf);
  myString = null;
  pvx = vx;
}
 
void draw() {
  
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      myString = trim(myString);
      String split[] = split(myString, ",");
      if (split.length == 2){
      if (abs(vx-pvx)>0.2){
        vx = float(split[1]);
      }else{
        vx = float(floor(float(String.format("%.2f", ((pvx+float(split[1]))/2)))*10))/10;
      }
      if(abs(vy-pvy)>0.2){
        vy = float(split[0]);
      }else{
        vy = float(floor(float(String.format("%.2f", ((pvy+float(split[0]))/2)))*10))/10;
      }
      if (tvx != vx){
        pvx = tvx;
        tvx = vx;
      }
      if (tvy != vy){
        pvy = tvy;
        tvy = vy;
      }
      println("c: "+ vx +"," +"p: "+ pvx + ","+ "c: "+ vy +"," +"p: "+ pvy);
      }
    }
  }
  background(0);
  fill(255);
  rect((width/2)-(vx*5), (height/2)+ (vy*5), 30, 30); 
}