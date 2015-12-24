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
ColourTable colourtable01;
ColourTable colourtable025;
ColourTable colourtable05;
ColourTable colourtable075;
ColourTable colourtable09;





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

  if (rp<=0){
  try { 
    UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
  } 
  catch (Exception e) { 
    e.printStackTrace();
  } 
  int minfilenum=1;
  op1s = Integer.parseInt(JOptionPane.showInputDialog(frame, "Which file to load",minfilenum));
  //int minsession=0;
  //op2s = Integer.parseInt(JOptionPane.showInputDialog(frame, "Minimum session",minsession));
  int maxsession=1;
  op3s = Integer.parseInt(JOptionPane.showInputDialog(frame, "Max session",maxsession));
  }else{
   op1s=filecount; 
   op2s=g;
   op3s=f;
  }
  File dir = new File(dataPath(""));
  File[] directoryListing = dir.listFiles();
  if (directoryListing != null) {
    for (File scv: directoryListing) {
      n= ""+directoryListing[filecount]+"";
      maxdirectory = directoryListing.length;
      
    }
    }
  table = loadTable(n, "header");
  String [] rowsn = loadStrings(n);
  osub = rowsn.length/250;
  sessioncount = rowsn.length/250;  
  int a =(op2s*250);  

  int b = (op3s*250);
  size(1200,600);
  colourtable1 = ColourTable.getPresetColourTable(ColourTable.BLUES,0,1);
  colourtable01 = ColourTable.getPresetColourTable(ColourTable.PURPLES,0,1);
  colourtable025 = ColourTable.getPresetColourTable(ColourTable.BLUES,0,1);
  colourtable05 = ColourTable.getPresetColourTable(ColourTable.GREENS,0,1);
  colourtable075 = ColourTable.getPresetColourTable(ColourTable.ORANGES,0,1);
  colourtable09= ColourTable.getPresetColourTable(ColourTable.REDS,0,1);
  increment = rowsn.length;
  minincrement =0;
  float trialcnt [] = new float[rowsn.length];
  float trials [] = new float[rowsn.length];
  float prob [] = new float[rowsn.length];
  float rightorwrong[] = new float[rowsn.length];
  float colordata [] = new float [rowsn.length];
  float sizedata [] = new float [rowsn.length];
  for (TableRow row : table.rows()){
      while (i<rowsn.length-1&& i>=a){
       if ( i<b){
        diff1=b-a;
        inc = 1/(diff1);
        float j = ((b-a)/250)*50;
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
        String [] thisRow = split(rowsn[i], ",");
        float sortprob = table.getFloat(i,4);
        int sortint = table.getInt(i,5);
        int lr = table.getInt(i,6);
        trialcnt [i]= z/(diff1);
        sizedata [i]= (10/((b-a)/250))*i;
        colordata [i]= colourtable1.findColour(sortprob);
        trials[i] = Float.parseFloat(thisRow[1]);
        prob [i] = Float.parseFloat(thisRow[4]);
        rightorwrong [i] = Float.parseFloat(thisRow[5]);

        
        if (sortprob==0.1){
          sum01 += sortint;        
          if ((lr==1 && sortint==1) || (lr==2 && sortint==0)){
            left01 = left01 +1;
          }
        }
        if (sortprob==0.25){
          sum025 += sortint;
          if ((lr==1 && sortint==1) || (lr==2 && sortint==0)){
            left025 = left025 +1;
          }    
        }
        if (sortprob==0.5){
          sum05 += sortint;
          if ((lr==1 && sortint==1) || (lr==2 && sortint==0)){
            left05 = left05 +1;
          }       
        }
        if (sortprob==0.75){
          sum075 += sortint;
          if ((lr==1 && sortint==1) || (lr==2 && sortint==0)){
            left075 = left075 +1;
          }
        }
        if (sortprob==0.9){
          sum09 += sortint;
          if ((lr==1 && sortint==1) || (lr==2 && sortint==0)){
            left09 = left09 +1;
          }         
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
  }
  print (maxdirectory);
}
 
 
void draw(){
  background(0);
  text(f+"max session",width/2,20);
  //text(g+"min session",width/2,30);
  String ra1 = nf(ratioleft01,1,10);
  text(ra1+"ratio01",width/2,40);
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
  
  
    }
 void keyPressed(){
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