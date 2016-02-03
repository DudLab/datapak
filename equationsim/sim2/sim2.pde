import org.gicentre.utils.stat.*;
import org.gicentre.utils.colour.*;
import org.apache.commons.math3.distribution.AbstractRealDistribution.*;
import org.apache.commons.math3.distribution.NormalDistribution.*;
import org.apache.commons.math.distribution.NormalDistributionImpl.*;
int i;
int ks;
int tt=0;
int nlines = 3;
float k =0.01;
int nshift = 1;
float rconst;
ColourTable c1;
ColourTable c2;
XYChart cp;
XYChart cp1;
XYChart ct;
XYChart v1;
XYChart op;
XYChart opvopva;
XYChart cpb;
XYChart gcb;
XYChart ncb;
XYChart actcb;

void setup(){
  size(800,800);
  float [] t = new float[1001*nlines];
  float [] dval = new float[1001*nlines];
  float [] rc = new float[1001*nlines];
  float [] pwin = new float[1001*nlines];
  float [] muf = new float[1001*nlines];
  float [] mup = new float[1001*nlines];
  float [] vc1 = new float[1001*nlines];
  float [] vc2 = new float[1001*nlines];  
  float [] normerror = new float[1001*nlines];  
  //float [] vb = new float[1001*nlines];
  //float [] gb = new float[1001*nlines];
  //float [] nb = new float[1001*nlines];
  //float [] actb = new float[1001*nlines];
  float [] cc = new float[1001*nlines];
  float [] cc1 = new float[1001*nlines];  
  NormalDistributionImpl d1 = new NormalDistributionImpl(500,1000);
  for (i=0; i<1001*nlines; i++){
      c1 = ColourTable.getPresetColourTable(ColourTable.BLUES,0,1);
      c2 = ColourTable.getPresetColourTable(ColourTable.GREENS,0,1);      
    if ((i % 1001)==0 && i>0){
     nshift = nshift + 1;
     tt = 0;
    }
    //rconst = (pow(nlines, nshift-1)/nlines);
    t[i] = (tt);
    pwin[i] = tt/1000;
    muf[i] = (12/(1+exp(-0.03*(tt))))-12;
    //muf[i] = (12/(1+exp(-0.015*(tt))))-12;        
    rc[i] = (pow(nlines, nshift-2));
    cc [i] = ((nshift-0.3)/nlines);
    cc1 [i] = ((nshift-0.5)/nlines);    
    dval[i] = (rc[i])/(1+(k*tt));
    vc1[i] = dval[i]+muf[i];
    tt++;
  }
  
   
  cp = new XYChart(this);
  cp.setData(t,dval);
  cp.showXAxis(true);
  cp.showYAxis(true);
  cp.setMinX(0);
  cp.setMaxX(1000);
  cp.setMinY(-1);
  cp.setMaxY(3);
  cp.setXAxisLabel("Time");
  cp.setYAxisLabel("Subjective Value");
  cp.setPointColour(cc,c1);
  cp.setPointSize(2);
  //cp.setLineWidth(2);
  
  cp1 = new XYChart(this);
  cp1.setData(t,muf);
  cp1.showXAxis(true);
  cp1.showYAxis(true);
  cp1.setMinX(0);
  cp1.setMaxX(1000);
  cp1.setMinY(-1);
  cp1.setMaxY(3);
  cp1.setXAxisLabel("Time");
  cp1.setYAxisLabel("Subjective Value");
  cp1.setPointColour(color (255, 153, 51));
  cp1.setPointSize(2);
  //cp1.setLineWidth(2);  
  
  ct = new XYChart(this);
  ct.setData(t,muf);
  ct.showXAxis(true);
  ct.showYAxis(true);
  ct.setMinX(0);
  ct.setMaxX(1000);
  ct.setMinY(-1);
  ct.setMaxY(3);
  ct.setXAxisLabel("Time");
  ct.setYAxisLabel("Subjective Value");
  ct.setPointColour(color (255, 153, 51));
  ct.setPointSize(2);
  //ct.setLineWidth(2);
  ct.getRightSpacing();
  
  v1 = new XYChart(this);
  v1.setData(t,vc1);
  v1.showXAxis(true);
  v1.showYAxis(true);
  v1.setMinX(0);
  v1.setMaxX(1000);
  v1.setMinY(-1);
  v1.setMaxY(3);
  v1.setXAxisLabel("Time");
  v1.setYAxisLabel("Subjective Value");
  v1.setPointColour(cc1,c2);
  v1.setPointSize(2);
  //v1.setLineWidth(2);
  v1.getRightSpacing();  
}


void draw(){
  background(0);
  cp.draw(50,50,700, 700);
  cp1.draw(50,50,700, 700);
  v1.draw(50,50,700, 700);  
}

void keyPressed(){
  if (keyCode==UP && ks<2){
    ks++;
  }
  if (keyCode==DOWN && ks>0){
    ks--;
  }
}