
//#include <NewPing.h>
#define tp1 3
#define ep1 2
#define tp2 5
#define ep2 4
#define led1 6
#define led2 7
#define sn  2
#define maxdist 300
float fd, rd;
String str;
//NewPing sonar[sn] = {
//  NewPing(3,2,maxdist),
//  NewPing(5,4,maxdist),  
//};

void setup() {
  Serial.begin (9600);
  pinMode(tp1, OUTPUT);
  pinMode(ep1, INPUT);
  pinMode(tp2, OUTPUT);
  pinMode(ep2, INPUT);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
}

void loop() {
fd = sensor(tp1,ep1);
//sensor(tp1,ep1);
// fd = distance;
//sensor(tp2,ep2);
rd =  sensor(tp2,ep2);
  if (fd <= 5){
    digitalWrite(led1,HIGH);
  }else{
    digitalWrite(led1,LOW);
  }
  if (rd <= 5){
    digitalWrite(led2,HIGH);
  }else{
    digitalWrite(led2,LOW);
  } 
 Serial.print(fd);
 Serial.print(",");
 Serial.println(rd);
// Serial.println();



// Delay 50ms before next reading.
delay(10);
}
float sensor(int tp,int ep){
  digitalWrite(tp, LOW);
  delayMicroseconds(2);
  digitalWrite(tp, HIGH);
  delayMicroseconds(10);
  digitalWrite(tp, LOW);
  float duration = pulseIn(ep, HIGH);
  float distance = (duration/2) / 29.1;
  return distance;

}
//void sensor(int tp,int ep){
//digitalWrite(tp, LOW);
//delayMicroseconds(2);
//digitalWrite(tp, HIGH);
//delayMicroseconds(10);
//digitalWrite(tp, LOW);
//duration = pulseIn(ep, HIGH);
//distance = (duration/2) / 29.1;

//}

