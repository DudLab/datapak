import java.awt.*;
import java.util.*;
import processing.net.*; 
import processing.serial.*;
import javax.swing.*; 
import java.io.*;
import java.io.File;
import org.gicentre.utils.multisketch.*;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.colour.*;

XYChart lineChart;
XYChart lineChart2;
XYChart lineChart1a;
XYChart lineChart2a;
XYChart scatterplot;
Table table1;
Table table;
int switchkey=1;
float o;
int i = 0;
int p = 0;
float z;
int colorincrement;
int block1;
int trial;
int sum1;
int increment;
int minincrement;
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
float left01a;
float left025a;
float left05a;
float left075a;
float left09a;
float ratioleft01a;
float ratioleft025a;
float ratioleft05a;
float ratioleft075a;
float ratioleft09a;
float sum01a;
float sum025a;
float sum05a;
float sum075a;
float sum09a;
float ratio01a;
float ratio025a;
float ratio05a;
float ratio075a;
float ratio09a;
float inc;
float j;
float c;
Float l;
Float prob;
String n;
int osub;
int diff1;
int g;
int f;
int rp;
int op1s;
int op2s;
int op3s;
int sessioncount;
int filecount=1;
int maxdirectory;
ColourTable colourtable1; 


//intList p01;




void setup(){
  i=0;
  c=0;
  j=0;
  z=0;
  diff1=0;
  left01=0;
  left025=0;
  left05=0;
  left075=0;
  left09=0;
  ratioleft01=0;
  ratioleft025=0;
  ratioleft05=0;
  ratioleft075=0;
  ratioleft09=0;
  sum01=0;
  sum025=0;
  sum05=0;
  sum075=0;
  sum09=0;
  ratio01=0;
  ratio025=0;
  ratio05=0;
  ratio075=0;
  ratio09=0;
  left01a=0;
  left025a=0;
  left05a=0;
  left075a=0;
  left09a=0;
  ratioleft01a=0;
  ratioleft025a=0;
  ratioleft05a=0;
  ratioleft075a=0;
  ratioleft09a=0;
  sum01a=0;
  sum025a=0;
  sum05a=0;
  sum075a=0;
  sum09a=0;
  ratio01a=0;
  ratio025a=0;
  ratio05a=0;
  ratio075a=0;
  ratio09a=0;
  
   op1s=filecount; 
   op2s=g;
   op3s=f;

  n= "merged1.csv";
  table = loadTable(n, "header");
  String [] rowsn = loadStrings(n);
  osub = rowsn.length/250;
  sessioncount = rowsn.length/250;  
  int a =(op2s*250);  

  int b = (op3s*250);
  size(1200,600);
  colourtable1 = ColourTable.getPresetColourTable(ColourTable.BLUES,0,1);

  increment = rowsn.length;
  minincrement =0;
  float trialcnt [] = new float[rowsn.length];
  float trials [] = new float[rowsn.length];
   float prob [] = new float[rowsn.length];
  float rightorwrong[] = new float[rowsn.length];
  float colordata [] = new float [rowsn.length];
  float sizedata [] = new float [rowsn.length];
  float halfway [] = new float [rowsn.length];

  
  for (TableRow row : table.rows()){
      while (i<rowsn.length-1){

        inc = 1/(increment);
        j = (rowsn.length/250)*50;
        float k = (j/2);
        ratioleft01 = (left01/j);
        ratioleft025 = (left025/j);
        ratioleft05 = (left05/j);
        ratioleft075 = (left075/j);
        ratioleft09 = (left09/j);
        ratio01 = (sum01/j);
        ratio025 = (sum025/j);
        ratio05 = sum05/j;
        ratio075 = sum075/j;
        ratio09 = sum09/j;
        
        ratioleft01a = (left01a/k);
        ratioleft025a = (left025a/k);
        ratioleft05a = (left05a/k);
        ratioleft075a = (left075a/k);
        ratioleft09a = (left09a/k);
        ratio01a = (sum01a/k);
        ratio025a = (sum025a/k);
        ratio05a = sum05a/k;
        ratio075a = sum075a/k;
        ratio09a = sum09a/k;
        
        String [] thisRow = split(rowsn[i], ",");
        float sortprob = table.getFloat(i,4);
        int sortint = table.getInt(i,5);
        int trialint = table.getInt(i,1);
        int lr = table.getInt(i,6);
        trialcnt [i]= z/(rowsn.length);
        sizedata [i]= (10/((rowsn.length)/250))*i;
        colordata [i]= colourtable1.findColour(sortprob);
        trials[i] = Float.parseFloat(thisRow[13]);
        prob [i] = Float.parseFloat(thisRow[4]);
        rightorwrong [i] = Float.parseFloat(thisRow[5]);

        if(trialint>25){
          if (sortprob==0.1){
          sum01a =sum01a + sortint;
        
          if (lr==1 && sortint==1){
            left01a = left01a +1;
          }
          if (lr==1 && sortint==0){
            left01a = left01a +0;
          }
          if (lr==2 && sortint==1){
            left01a = left01a +0;
          }
          if (lr==2 && sortint==0){
            left01a = left01a +1;
          }
        }
        if (sortprob==0.25){
          sum025a += sortint;
          if (lr==1 && sortint==1){
            left025a = left025a +1;
          }
          if (lr==1 && sortint==0){
            left025a = left025a +0;
          }
          if (lr==2 && sortint==1){
            left025a = left025a +0;
          }
          if (lr==2 && sortint==0){
            left025a = left025a +1;
          }          
        }
        if (sortprob==0.5){
          sum05a += sortint;
          if (lr==1 && sortint==1){
            left05a = left05a +1;
          }
          if (lr==1 && sortint==0){
            left05a = left05a +0;
          }
          if (lr==2 && sortint==1){
            left05a = left05a +0;
          }
          if (lr==2 && sortint==0){
            left05a = left05a +1;
          }          
        }
        if (sortprob==0.75){
          sum075a += sortint;
          if (lr==1 && sortint==1){
            left075a = left075a +1;
          }
          if (lr==1 && sortint==0){
            left075a = left075a +0;
          }
          if (lr==2 && sortint==1){
            left075a = left075a +0;
          }
          if (lr==2 && sortint==0){
            left075a = left075a +1;
          }
        }
        if (sortprob==0.9){
          sum09a += sortint;
          if (lr==1 && sortint==1){
            left09a = left09a +1;
          }
          if (lr==1 && sortint==0){
            left09a = left09a +0;
          }
          if (lr==2 && sortint==1){
            left09a = left09a +0;
          }
          if (lr==2 && sortint==0){
            left09a = left09a +1;
          }          
        }
      
      
          }
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
      c=+inc;
      z++;
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
    
    scatterplot = new XYChart(this);
    scatterplot.setData(trials,rightorwrong);
    scatterplot.showXAxis(true);
    scatterplot.showYAxis(true);
    scatterplot.setMinY(-1);
    scatterplot.setMaxY(2);
    scatterplot.setXAxisLabel("Trials");
    scatterplot.setYAxisLabel("Test subject Correct Inference");
    scatterplot.setPointColour(trialcnt, colourtable1);
    scatterplot.setPointSize(sizedata, 10);
    scatterplot.setLineWidth(2); 
    scatterplot.getRightSpacing();
    
    
    lineChart2a = new XYChart(this);
    lineChart2a.setData(new float[] {0.1, 0.25, 0.5, 0.75, 0.9},
                      new float[] {ratio01a, ratio025a, ratio05a, ratio075a, ratio09a});
    lineChart2a.showXAxis(true);
    lineChart2a.showYAxis(true);
    lineChart2a.setMinY(0);
    
    lineChart2a.setXAxisLabel("Left Trigger Probability");
    lineChart2a.setYAxisLabel("Test subject Left Trigger Probability");
    lineChart2a.setPointColour(color (140, 140, 255));
    lineChart2a.setPointSize(5);
    lineChart2a.setLineWidth(2);
    lineChart2a.getRightSpacing();
    
    lineChart1a = new XYChart(this);
    lineChart1a.setData(new float[] {0.1, 0.25, 0.5, 0.75, 0.9},
                      new float[] {ratioleft01a, ratioleft025a, ratioleft05a, ratioleft075a, ratioleft09a});
    lineChart1a.showXAxis(true);
    lineChart1a.showYAxis(true);
    lineChart1a.setMinY(0);
    lineChart1a.setXAxisLabel("Left Trigger Probability");
    lineChart1a.setYAxisLabel("Test subject Left Trigger Probability");
    lineChart1a.setPointColour(color (140, 140, 255));
    lineChart1a.setPointSize(5);
    lineChart1a.setLineWidth(2);
    lineChart1a.getRightSpacing();
  }
  print (rowsn.length);
}
 
 
void draw(){
  background(0);
  text(f+"max session",width/2,20);
  //text(g+"min session",width/2,30);
  //String ra1 = nf(ratioleft01,1,10);
  //text(ra1+"ratio01",width/2,40);
   text(ratio01a+"ratio01",width/2,40);
   text(filecount+"filecount",width/2,30);

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
    if (switchkey==3){
    scatterplot.draw(15,15,width-30,height-30);
    text("Test Subject percentage of determining correct reward", CENTER, height-(height-15));
   }
   if (switchkey==4){
    lineChart1a.draw(15,15,width-30,height-30);
    text("Test Subject % choosing left (2nd half of trials/block)", CENTER, height-(height-15));
   }
   if (switchkey==5){
    lineChart2a.draw(15,15,width-30,height-30);
    text("Test Subject percentage of determining correct reward (2nd half of trials/block)", CENTER, height-(height-15));
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
     if (key=='3'){
       switchkey=3;
      
     loop();
     }
     if (key=='4'){
       switchkey=4;
      
     loop();
     }
     if (key=='5'){
       switchkey=5;
      
     loop();
     }
     if (key=='6'){
       switchkey=6;
      
     loop();
     }
     if (key=='r'){
       rp++;
       setup();
      
     }
     if (keyCode==UP&&(f<sessioncount)){
          f++;
        }
     if (keyCode==DOWN&&(f>0)){
          f--;
     }
     //if (keyCode==RIGHT&&(g<=f)){
     //     g++;
     //}
     //if (keyCode==LEFT&&(g>0)){
     //     g--;
     //}
     if (keyCode=='='&&(filecount<maxdirectory-1)){
          filecount++;
     }
     if (keyCode=='-'&&(filecount>1)){
          filecount--;
     }
   }