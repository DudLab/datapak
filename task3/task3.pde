import controlP5.*;
import java.applet.Applet;
import java.awt.*;
import java.util.*;
import processing.net.*; 
import processing.serial.*;
import javax.swing.*; 
// Human version of the OpSig task

// Basic design:
//   A light flash is presented. 
//   You have to hit a key as quickly as possible after the second delayed flash.
//   On a subet of trials no second flash will occur.
//   Early presses are penalized by COST.
//   PROFIT decays hyperbolically with time.
//   INCOME is the running tally of how much profit you have made so far.

//===================================================================================================
// INITIALIZE GLOBAL VARIABLES
//===================================================================================================
float   time;
float   totalTime = 30*60*1000;
float   timeLeft = 30;
float   trialStart;
float   startTime = 0;
float   stimDur = 250;
float   cost = 0.001;
float   earlyCost = 0.1;
float   trialCost = 0;
float   profit = 1;
float   meanDelay = 3000;
float   value = 0;
float   income = 0;
float   feedbackDelay = meanDelay;

float[] trialData = {0,0,0,0,0,0,0};
int     trialCount = 0;
int     probeTrialCnt = 5;

int[]   blockPoss = {50,750,1375,2000};
float   blockVar = blockPoss[round(random(0,3))];

boolean running = false;
boolean trialMayBeEnded = false;
boolean inTrial = false;
boolean primed = false;
boolean probeTrial = false;
boolean initialRun = true;
boolean training = false;
boolean canBePrimed = false;

PrintWriter output;
PrintWriter presses;
String i = " ";
 
ControlP5 controlP5;
Numberbox TimeRemaining;
Numberbox SessIncome;
Textfield fileLabelP;




//===================================================================================================
//===================================================================================================
void setup() {
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 
  String preset="Type your name here";
  String op1s = JOptionPane.showInputDialog(frame, "Name", preset);
  if (op1s != null) i = op1s;
  frameRate(60);
  background(0);
  size(1120, 768);
  smooth();
  rectMode(CORNER);
  println(blockVar);

  controlP5 = new ControlP5(this);
  fileLabelP = controlP5.addTextfield("USER",1000,10,100,25);
  fileLabelP.setText(i);
  
  TimeRemaining = controlP5.addNumberbox("Time Remaining",30.000,1000,65,100,25);
  SessIncome = controlP5.addNumberbox("Session Income",30.000,1000,105,100,25);

  
}
  


//===================================================================================================
//===================================================================================================
void draw() {
  
  background(0);
  time = millis();
  
  if (running) {
    timeLeft = 30 - ((time-startTime)/60000);
  }
  
  fill(125);
  text("Press space bar as quickly as possible after trial end to maximize your profit. Press 's' to start the session. Press 't' to train.",5,25);
  text("press x to start a new trial", 5,30);
  fill(0,100,175);
  text("Current trial PROFIT: ",150,45);
  fill(175,0,0);
  text("Total trial COST: ",150,65);
  fill(150);
//  text("Total session INCOME: ",150,85);
  fill(255);
    text(value,350,45);
    text(trialCost,350,65);
//    text(income,350,85);
//
//  fill(255);
//  text("TIME REMAINING: ",800,65);
//  text(timeLeft,950,65);
//  text("min",1000,65);

SessIncome.setValue(income);
TimeRemaining.setValue(timeLeft);

  fill(0,130,255);
  ellipse(20,40,10,10);
  text(" = trial start.",25,45);

  fill(255,0,0);
  ellipse(20,60,10,10);
  text(" = trial end.",25,65);
  
  if(primed) {    
    println("primed.");
    inTrial = true;
    trialStart = time;
    if (training==false) {
      trialData[1] = trialStart;
      trialData[2] = feedbackDelay;
    }
    primed = false;
    canBePrimed = false;
  }
        
  if(inTrial) {
      
      if( (time-trialStart) < stimDur ) {
          fill(0,130,255);
          ellipse(width/2,height/2,100,100);
      } // display cue

      if (probeTrial) {

        trialMayBeEnded = true;

      }else{
        if( (time-trialStart) > feedbackDelay ) {
  
          trialMayBeEnded = true;
  
          if( (time-trialStart) < feedbackDelay+stimDur ) {// flash the stimulus
            fill(255,0,0);
            ellipse(width/2,height/2,100,100);
          }
  
          value = profit / ( 1 + ((time-(trialStart+feedbackDelay)) * cost) );
  
        } // display feedback | wait for user response
      }    
    } // inTrial
    
    
  if (training) {
    
    if (inTrial) {
      // display the trial structure
      fill(150);
      rect(100,595,(time-trialStart) / 10,10);
    } else {
      fill(255);
      text("PUSH X NOW TO START",150,620);
    }
        
    fill(0,130,255);
    ellipse(100,600,40,40);
  
    fill(255,0,0);
    ellipse(100+(feedbackDelay/10)+20,600,40,40);

    if (inTrial) {
      
            if( (time-trialStart) < stimDur ) {
              fill(0,130,255);
              ellipse(width/2,height/2,100,100);
            } // display cue    
            
            if( (time-trialStart) > feedbackDelay ) {
                  if( (time-trialStart) < feedbackDelay+stimDur ) {// flash the stimulus
                    fill(255,0,0);
                    ellipse(width/2,height/2,100,100);
                    fill(255);
                    text("PUSH SPACEBAR NOW",100+(feedbackDelay/10)+50,620);
                  } else { // trial End
                    eot_parameter();
                    inTrial=false;
                }
            }
      } 
    }


}

//===================================================================================================
//===================================================================================================
void eot_parser() {  
  
  // STORE THE TRIAL DATA IN AN ASSOCIATED TEXT FILE
  if (training==false){
  String data = trialData[0] + "," + trialData[1] + "," + trialData[2] + "," + trialData[3] + "," + trialData[4] + "," + trialData[5] + "," + trialData[6] + "," + trialCost;
  output.println(data);
  output.flush();
  canBePrimed = true;
  }
  
  
}


//===================================================================================================
//===================================================================================================
void eot_parameter() {
  
  if (training) {
    feedbackDelay = GenerateGaussianDelay(blockVar, meanDelay);
    canBePrimed = true;
  }
  
  trialCount++;
  trialData[6] = blockVar;
  feedbackDelay = GenerateGaussianDelay(blockVar, meanDelay);
  
  trialCost = 0;
  value = profit;
  
  if (trialCount > probeTrialCnt+random(6,11)) {
    probeTrialCnt = trialCount;
    probeTrial = true;
    trialData[5] = 1;    
  } else {
    probeTrial = false;
    trialData[5] = 0;
  }
  
  trialMayBeEnded = false;

}


//===================================================================================================
//===================================================================================================
int GenerateGaussianDelay(float variance, float mean) {

  float x = 0;
  float y = 0;
  float s = 2;

  while (s>1) {
    x=random(-1,1);
    y=random(-1,1);
    s = (x*x) + (y*y);
  }  
  
  float unscaledRandNum = x*( sqrt(-2*log(s) / s) );
  int constrainedValue = int( constrain( (unscaledRandNum*variance) + mean, 250, 10000) );
  return int(constrainedValue);
}

//===================================================================================================
//===================================================================================================
void keyPressed() { 
  
  if (key == 's' || key == 'S') {

    startTime = time;
    running = true;
    trialData[0] = 1; // first trial
    trialData[5] = 0; // first trial is never a probe trial
    
    if(initialRun) {
      String fileName = fileLabelP.getText() + year() + "_" + month() + "_" + day() + "_" + hour() + "_" + minute();
      println("Data will be saved to: "+fileName);

      // create a data file to keep track of data about behavioral performance    
      output = createWriter("DataBuffer/"+fileName+".csv");
      String firstLine = "Trial number , Trial start time (ms) , Feedback delay (ms) , End trial time (ms) , Profit (au) , Probe Trial (True==1) ";
      output.println(firstLine);
      output.flush(); // required for some reason
      
      // create a data file to keep track of data about behavioral performance    
      presses = createWriter("DataBuffer/"+fileName+"_p.csv");
      String firstLine2 = "Time of press (ms) , Press (future velocity signal) ";
      presses.println(firstLine2);
      presses.flush(); // required for some reason

    }
    
    canBePrimed = true;
  }
  
  if (key == '1') {
    blockVar = blockPoss[0];
  }
  if (key == '2') {
    blockVar = blockPoss[1];
  }
  if (key == '3') {
    blockVar = blockPoss[2];
  }
  if (key == '4') {
    blockVar = blockPoss[3];
  }

  if (key == 'x' || key == 'X') {
    if ( canBePrimed ) {
      primed = true;
    }
  }

  if (key == 't' || key == 'T') {
    if (training) {
      training = false;
      inTrial = false;
      canBePrimed = false;
    } else {
      training = true;    
      canBePrimed = true;
    }
  }

  if (key == ' ') {

    if(training==false & running==true) {
      // STORE THE TRIAL DATA IN AN ASSOCIATED TEXT FILE
      String pressData = millis() + ", 1"; // in the future this could hold some measurement of press properties
      presses.println(pressData);
      presses.flush();
    }
    
    if(trialMayBeEnded) {

      trialData[0] = trialCount;
      trialData[3] = time - trialStart;
      trialData[4] = value - trialCost;
      income = income + trialData[4];
      
      inTrial = false;
      
      eot_parser();
      eot_parameter();

    } else {

      trialCost = trialCost + earlyCost;
      
   }

  }

}