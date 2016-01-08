import org.gicentre.utils.stat.*;
import org.gicentre.utils.colour.*;
int i;
int tt=0;
float ac = 0.1;
float ag = ac;
float an = ag;
float bg = 1;
float bn = bg;
float tA =0;
float vA= 0.5;
float gA = 1;
float nA = 1;
float actA = 0;
float rprob=0.0;
float vB= 0;
float gB;
float nB;
float actB = -1;
float rshift = 0;
XYChart vc;
XYChart gc;
XYChart nc;
XYChart actc;
XYChart vcb;
XYChart gcb;
XYChart ncb;
XYChart actcb;

void setup(){
  size(1600,800);
  float [] t = new float[1111];
  float [] v = new float[1111];
  float [] g = new float[1111];
  float [] n = new float[1111];
  float [] act = new float[1111];
  float [] pr = new float[1111];
  float [] vb = new float[1111];
  float [] gb = new float[1111];
  float [] nb = new float[1111];
  float [] actb = new float[1111];  
  for (i=0; i<1111; i++){
    if ((i % 101)==0 && i>1){
     rprob = rprob + 0.1;
     rshift = rshift + 0.2;
     v[i] = (vA);
     g[i] = (gA);
     n[i] = (nA);
     act[i] = (actA);
     vb[i] = (vB);
     gb[i] = (0.6666666666666666666666666666666666666666);
     nb[i] = (1.6666666666666666666666666666666666666666);
     tt = 0;
    }
    if (i<1){
     v[i] = (vA);
     g[i] = (gA);
     n[i] = (nA);
     act[i] = (actA);     
     vb[i] = (vB);
     gb[i] = (5/3);
     nb[i] = (nB);  
    }else{
      if (tt>0){
        v[i]=(v[i-1] + ac*(rprob-v[i-1]));
        g[i]=(g[i-1] + ac*((g[i-1])*(rprob-v[i-1])));
        n[i]=(n[i-1] + ac*(n[i-1])*(-rprob+v[i-1]));
        act[i]=(g[i]-n[i]);
        vb[i]=(vb[i-1] + ac*(rshift-vb[i-1]));
        gb[i]=(gb[i-1] + (ag*gb[i-1])*(rshift-vb[i-1]));
        nb[i]=(nb[i-1] + (an*nb[i-1])*(rshift-vb[i-1])*(-1));      
      }
    }
    t[i] = (tt);

    actb[i]=(gb[i]-nb[i]);    
    pr[i] = (tt)*0.01;
    tt++;
  }
  
  vc = new XYChart(this);
  vc.setData(t,v);
  vc.showXAxis(true);
  vc.showYAxis(true);
  vc.setMinY(0);
  vc.setXAxisLabel("Time");
  vc.setYAxisLabel("V(R,P)");
  vc.setPointColour(color (102, 178, 255));
  vc.setPointSize(2);
  //vc.setLineWidth(2);
  vc.getRightSpacing();  
  
  gc = new XYChart(this);
  gc.setData(t,g);
  gc.showXAxis(true);
  gc.showYAxis(true);
  gc.setMinY(0);
  gc.setXAxisLabel("Time");
  gc.setYAxisLabel("G(R,P)");
  gc.setPointColour(color (0, 128, 255));
  gc.setPointSize(2);
  //gc.setLineWidth(2);
  gc.getRightSpacing();
  
  nc = new XYChart(this);
  nc.setData(t,n);
  nc.showXAxis(true);
  nc.showYAxis(true);
  nc.setMinY(0);
  nc.setXAxisLabel("Time");
  nc.setYAxisLabel("N(R,P)");
  nc.setPointColour(color (0, 75, 153));
  nc.setPointSize(2);
  //nc.setLineWidth(2);
  nc.getRightSpacing();
  
  actc = new XYChart(this);
  actc.setData(t,act);
  actc.showXAxis(true);
  actc.showYAxis(true);
  actc.setMinY(-2);
  actc.setXAxisLabel("Time");
  actc.setYAxisLabel("Act(R,P)");
  actc.setPointColour(color (153, 153, 255));
  actc.setPointSize(2);
  //actc.setLineWidth(2);
  actc.getRightSpacing();


  vcb = new XYChart(this);
  vcb.setData(pr,vb);
  vcb.showXAxis(true);
  vcb.showYAxis(true);
  vcb.setMinY(0);
  vcb.setXAxisLabel("p(R)");
  vcb.setYAxisLabel("V(R,P) from r=0 to r=2");
  vcb.setPointColour(color (102, 178, 255));
  vcb.setPointSize(2);
  //vcb.setLineWidth(2);
  vcb.getRightSpacing();  
  
  gcb = new XYChart(this);
  gcb.setData(pr,gb);
  gcb.showXAxis(true);
  gcb.showYAxis(true);
  gcb.setMinY(0);
  gcb.setXAxisLabel("p(R)");
  gcb.setYAxisLabel("G(R,P) from r=0 to r=2");
  gcb.setPointColour(color (0, 128, 255));
  gcb.setPointSize(2);
  //gcb.setLineWidth(2);
  gcb.getRightSpacing();
  
  ncb = new XYChart(this);
  ncb.setData(pr,nb);
  ncb.showXAxis(true);
  ncb.showYAxis(true);
  ncb.setMinY(0);
  ncb.setXAxisLabel("p(R)");
  ncb.setYAxisLabel("N(R,P) from r=0 to r=2");
  ncb.setPointColour(color (0, 75, 153));
  ncb.setPointSize(2);
  //ncb.setLineWidth(2);
  ncb.getRightSpacing();
  
  actcb = new XYChart(this);
  actcb.setData(pr,actb);
  actcb.showXAxis(true);
  actcb.showYAxis(true);
  actcb.setMinY(-1);
  actcb.setXAxisLabel("p(R)");
  actcb.setYAxisLabel("Act(R,P) from r=0 to r=2");
  actcb.setPointColour(color (153, 153, 255));
  actcb.setPointSize(2);
  //actcb.setLineWidth(2);
  actcb.getRightSpacing();
  print(gb[0]);
}


void draw(){
  background(0);
  vc.draw(0,0,width/4, 400);
  gc.draw(400,0,width/4, 400);
  nc.draw(800,0,width/4, 400);
  actc.draw(1200,0,width/4, 400);
  vcb.draw(0,400,width/4, 400);
  gcb.draw(400,400,width/4, 400);
  ncb.draw(800,400,width/4, 400);
  actcb.draw(1200,400,width/4, 400);  
}