import java.awt.*;
import java.util.*;
import processing.net.*; 
import processing.serial.*;
import javax.swing.*; 
import java.io.*;
import org.gicentre.utils.multisketch.*;
import org.gicentre.utils.stat.*;
XYChart lineChart;
XYChart lineChart2;
Table table;
int switchkey=1;
int i = 0;
int j =0;
int block1;
int trial;
int sum1;
int value;
float left01;
float left025;
float left05;
float left075;
float left09;
float ratioleft01;
float ratioleft025;
float ratioleft05;
float ratioleft075;
float ratioleft09;
float sum01;
float sum025;
float sum05;
float sum075;
float sum09;
float ratio01;
float ratio025;
float ratio05;
float ratio075;
float ratio09;
Float l;
Float prob;
String n = " ";



//intList p01;
ArrayList <Integer> p01= new ArrayList<Integer>(); 


void setup(){
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 
  String preset="Bailey Hwav2015_11_10_15_0.csv";
  String op1s = JOptionPane.showInputDialog(frame, "position_filename.csv", preset);
  if(op1s != null) n = op1s;  
  
  size(600,600);
  table = loadTable(n, "header");
  String [] rowsn = loadStrings(n);
  for (TableRow row : table.rows()){
    //for (i =0; i<125; i++){
      if (i<=rowsn.length){
        ratioleft01 = (left01/25);
        ratioleft025 = (left025/25);
        ratioleft05 = (left05/25);
        ratioleft075 = (left075/25);
        ratioleft09 = (left09/25);
        ratio01 = (sum01/25);
        ratio025 = (sum025/25);
        ratio05 = sum05/25;
        ratio075 = sum075/25;
        ratio09 = sum09/25;
        float sortprob = table.getFloat(i,4);
        int sortint = table.getInt(i,5);
        int lr = table.getInt(i,6);
        if (sortprob==0.1){
          sum01 =sum01 + sortint;
          if (lr==1 && sortint==1){
            left01 = left01 +1;
          }
          if (lr==1 && sortint==0){
            left01 = left01 +0;
          }
          if (lr==2 && sortint==1){
            left01 = left01 +0;
          }
          if (lr==2 && sortint==0){
            left01 = left01 +1;
          }
        }
        if (sortprob==0.25){
          sum025 += sortint;
          if (lr==1 && sortint==1){
            left025 = left025 +1;
          }
          if (lr==1 && sortint==0){
            left025 = left025 +0;
          }
          if (lr==2 && sortint==1){
            left025 = left025 +0;
          }
          if (lr==2 && sortint==0){
            left025 = left025 +1;
          }          
        }
        if (sortprob==0.5){
          sum05 += sortint;
          if (lr==1 && sortint==1){
            left05 = left05 +1;
          }
          if (lr==1 && sortint==0){
            left05 = left05 +0;
          }
          if (lr==2 && sortint==1){
            left05 = left05 +0;
          }
          if (lr==2 && sortint==0){
            left05 = left05 +1;
          }          
        }
        if (sortprob==0.75){
          sum075 += sortint;
          if (lr==1 && sortint==1){
            left075 = left075 +1;
          }
          if (lr==1 && sortint==0){
            left075 = left075 +0;
          }
          if (lr==2 && sortint==1){
            left075 = left075 +0;
          }
          if (lr==2 && sortint==0){
            left075 = left075 +1;
          }          
        }
        if (sortprob==0.9){
          sum09 += sortint;
          if (lr==1 && sortint==1){
            left09 = left09 +1;
          }
          if (lr==1 && sortint==0){
            left09 = left09 +0;
          }
          if (lr==2 && sortint==1){
            left09 = left09 +0;
          }
          if (lr==2 && sortint==0){
            left09 = left09 +1;
          }          
      }
      i++;
    }
    lineChart2 = new XYChart(this);
    lineChart2.setData(new float[] {0.1, 0.25, 0.5, 0.75, 0.9},
                      new float[] {ratio01, ratio025, ratio05, ratio075, ratio09});
    lineChart2.showXAxis(true);
    lineChart2.showYAxis(true);
    lineChart2.setMinY(0);
    
    lineChart2.setXAxisLabel("Left Trigger Probability");
    lineChart2.setYAxisLabel("Test subject Left Trigger Probability");
    lineChart2.setPointColour(color (140, 140, 255));
    lineChart2.setPointSize(5);
    lineChart2.setLineWidth(2);
    lineChart2.getRightSpacing();
    
    lineChart = new XYChart(this);
    lineChart.setData(new float[] {0.1, 0.25, 0.5, 0.75, 0.9},
                      new float[] {ratioleft01, ratioleft025, ratioleft05, ratioleft075, ratioleft09});
    lineChart.showXAxis(true);

    lineChart.showYAxis(true);
    lineChart.setMinY(0);

    
    lineChart.setXAxisLabel("Left Trigger Probability");
    lineChart.setYAxisLabel("Test subject Left Trigger Probability");
    lineChart.setPointColour(color (140, 140, 255));
    lineChart.setPointSize(5);
    lineChart.setLineWidth(2);
    lineChart.getRightSpacing();
    
  }
  print(table.getInt(125,0));
}
 
 
void draw(){
  background(0);
  //text(left01,width/4,10);
  text(left025,width/2,20);
  //text(left05,width/2,30);
  //text(sum075,width/2,40);
  //text(left09,width/2,50);
  if (switchkey==1){
  lineChart.draw(15,15,width-30,height-30);
  fill(255);
  textSize(15);
  text("Test Subject percentage of chosing left", CENTER, height-(height-15));
  }
  if (switchkey==2){
  lineChart2.draw(15,15,width-30,height-30);
  text("Test Subject percentage of determining correct reward", CENTER, height-(height-15));
  }
    }
 void keyPressed(){
   //if (key==CODED){
     if (key=='1'){
       switchkey=1;
       loop();
     }
     if (key=='2'){
       switchkey=2;
       loop();
     }
     if (keyCode=='3'){
       switchkey=3;
     }
   }
 //}