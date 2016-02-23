import java.awt.*;
import java.util.*;
import processing.net.*; 
import processing.serial.*;
import javax.swing.*; 
import java.io.*;
import java.io.File;
import java.util.Iterator;
import java.util.Arrays;
import java.util.Comparator;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.colour.*;

ArrayList <datum> data = new ArrayList<datum>();
ArrayList <datum1> data1 = new ArrayList<datum1>();
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
float j;
float trials[];
int sessioncount;
int filecount=1;
int maxdirectory;
Table tt;

ColourTable colourtable1; 
ColourTable colourtable01;
ColourTable colourtable025;
ColourTable colourtable05;
ColourTable colourtable075;
ColourTable colourtable09;
ColourTable ct1;
XYChart l1;
XYChart l2;
XYChart l3;
XYChart l4;
XYChart l5;
XYChart l6;
XYChart l7;
XYChart l8;
XYChart l9;
XYChart l1a;
XYChart l2a;
XYChart l3a;
XYChart l4a;
XYChart l5a;
XYChart l6a;
XYChart l7a;
XYChart l8a;
XYChart l9a;

void setup(){

  File dir = new File(dataPath("")+"/task1/trialdata/");
  //File dir1 = new File(dataPath("")+"task1/positiondata/");
  File dir2 = new File(dataPath("")+"/task2/trialdata/");
  File dir3 = new File(dataPath("")+"task2/positiondata/");  
  File [] directoryListing = dir.listFiles();
  File [] directoryListing2 = dir2.listFiles();
  if (directoryListing != null) {
    for (File fl : directoryListing) {
      for (int i=0; i< directoryListing.length; i++){
        datum d = new datum(""+directoryListing[i]+"");
        print(directoryListing[0]);
        data.add(d);
      }
    }
  }
  if (directoryListing2 != null) {
    for (File fl : directoryListing2) {
      for (int i=0; i< directoryListing2.length; i++){
        datum1 d = new datum1(""+directoryListing2[i]+"");
        print(directoryListing2[0]);
        data1.add(d);
      }
    }
  }  
  size(1200,800);
  colourtable1 = ColourTable.getPresetColourTable(ColourTable.BLUES,0,1);
  colourtable01 = ColourTable.getPresetColourTable(ColourTable.PURPLES,0,1);
  colourtable025 = ColourTable.getPresetColourTable(ColourTable.BLUES,0,1);
  colourtable05 = ColourTable.getPresetColourTable(ColourTable.GREENS,0,1);
  colourtable075 = ColourTable.getPresetColourTable(ColourTable.ORANGES,0,1);
  colourtable09= ColourTable.getPresetColourTable(ColourTable.REDS,0,1);
  ct1 = ColourTable.getPresetColourTable(ColourTable.OR_RD,0,1);
  l1 = new XYChart(this);
  l2 = new XYChart(this);
  l3 = new XYChart(this);
  l4 = new XYChart(this);
  l5 = new XYChart(this);
  l6 = new XYChart(this);
  l7 = new XYChart(this);
  l8 = new XYChart(this);
  l9 = new XYChart(this);

  


}
 
 
void draw(){
  background(0);
  displayall();
   }


class datum{
  
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
  String fname;
  float time []= new float[500];
  float trials[] = new float[500];  
  float trials1 [] = new float[500];
  float trials2 [] = new float[500];  
  float pos [] = new float[500];
  float prob [] = new float[500];
  float rightorwrong[] = new float[500];
  float lr [] = new float[500];
  //forage d 
  //collect d
  //optimal
  //tot
  float colordata [] = new float [500];
  float sizedata [] = new float [500];
  float probrightwrong1[][] = new float [500][500];
  float sortpr1[] = new float [500];
  float sortwr1[] = new float [500];
  float probrightwrong2[][] = new float [500][500];
  float sortpr2[] = new float [500];
  float sortwr2[] = new float [500];  
  datum(String ffff){
  fname = ffff;
  }
  void load(){
    tt = loadTable(""+fname+"", ""+"header"+"");
    for (int k = 1; k<500; k++){
      //trials[k]= k;
      time[k] = tt.getFloat(k,0);
      trials[k] = tt.getFloat(k,1);
      pos[k] = tt.getFloat(k,3);
      prob[k] = tt.getFloat(k,4);
      lr[k] = tt.getFloat(k,5);
      if (k<250){
        trials1[k] = tt.getFloat(k,1);
        probrightwrong1[k][0] = tt.getFloat(k,4);
        probrightwrong1[k][1] = tt.getFloat(k,3);
        probrightwrong1[k][2] = tt.getFloat(k,5);       
      }else{
        trials2[k-250] = tt.getFloat(k,1)-250;        
        probrightwrong2[k-250][0] = tt.getFloat(k,4);
        probrightwrong2[k-250][1] = tt.getFloat(k,3);
        probrightwrong2[k-250][2] = tt.getFloat(k,5);
      }
      Arrays.sort(probrightwrong1, new Comparator<float[]>(){
        public int compare(float[] pp1, float[] pp2){
          return Float.compare(pp1[0], pp2[0]);
        }
      });
      Arrays.sort(probrightwrong2, new Comparator<float[]>(){
        public int compare(float[] pp1, float[] pp2){
          return Float.compare(pp1[0], pp2[0]);
        }
      });       
    }
    for (int u = 0; u<250; u++){
      sortpr1[u] = probrightwrong1[u][0];
      sortwr1 [u] = probrightwrong1[u][2];
      sortpr2[u] = probrightwrong2[u][0];
      sortwr2 [u] = probrightwrong2[u][2];      
    }
   
    //print(lr[1]);
    l1.showXAxis(true);
    l1.showYAxis(true);
    l1.setData(trials, lr);    
    l1.setXAxisLabel("probability");
    l1.setYAxisLabel("right or wrong 1st half");
    l1.setPointColour(color (140, 140, 255));
    l1.setPointSize(5);
    l1.setLineWidth(2);
    
    l2.showXAxis(true);
    l2.showYAxis(true);
    l2.setData(trials1, sortwr1);
    l2.setXAxisLabel("trials");
    l2.setYAxisLabel("right or wrong 1st half");
    l2.setPointColour(sortpr1,ct1);
    l2.setPointSize(5);
    l2.setLineWidth(2);
    
    l3.showXAxis(true);
    l3.showYAxis(true);
    l3.setData(trials2, sortwr2);
    l3.setXAxisLabel("trials");
    l3.setYAxisLabel("right or wrong 2nd half");
    l3.setPointColour(sortpr1,ct1);
    l3.setPointSize(5);
    l3.setLineWidth(2);

  } 
  void draw(){
    l2.draw(50,50,500,500);
    l3.draw(550,50,500,500);    
  }
}
class datum1{
  String fname;
  float time []= new float[500];
  float trials[] = new float[500]; 
  float pos [] = new float[500];
  float prob [] = new float[500];
  float rightorwrong[] = new float[500];
  float lr [] = new float[500];
  //forage d 
  //collect d
  //optimal
  //tot
  float colordata [] = new float [500];
  float sizedata [] = new float [500];
  datum1(String ffff){
  fname = ffff;
  }
  void load(){
    tt = loadTable(""+fname+"", ""+"header"+"");
    for (int k = 1; k<60; k++){
      time[k] = tt.getFloat(k,0);
      trials[k] = tt.getFloat(k,1);
      pos[k] = tt.getFloat(k,3);
      prob[k] = tt.getFloat(k,4);
      lr[k] = tt.getFloat(k,5);
      
      //Arrays.sort(probrightwrong1, new Comparator<float[]>(){
      //  public int compare(float[] pp1, float[] pp2){
      //    return Float.compare(pp1[0], pp2[0]);
      //  }
      //});       
    }
    for (int u = 0; u<250; u++){
      //sortpr1[u] = probrightwrong1[u][0];
      //sortwr1 [u] = probrightwrong1[u][2];
      //sortpr2[u] = probrightwrong2[u][0];
      //sortwr2 [u] = probrightwrong2[u][2];      
    }
   

  } 
  void draw(){
  }
}
void displayall(){
    for (datum dt : data){
      dt.load();
      dt.draw();
    }
}