FloatList rewthresh;
float stimnum1 [];
float stimnum2 [];
int shiftn=0;
int sized = 10000;
int reps = 300;
float stimthresh = 2.5;
float weightchange = 1;
float setchange = 0.25;
int blockstep = 100;
int block;
float fromset;
float fromset2;
float shiftmean=0;
float shiftsum=0;
float reachstats1[][] = new float[101][2];
float reachstats2[][] = new float[101][2];
float sessiondata1 [][] = new float [101][300];
float sessiondata2 [][] = new float [101][300];
float stimchange;
float reachd[] = new float [10000];
float reachd2[] = new float [10000];
float reachdiff;
float reachdsum = 0;
float reachdmean[] = new float [101];
int pick;
float thisreach;

void setup(){
  rewthresh = new FloatList();
  rewthresh.append(-2);
  rewthresh.append(-2);
  rewthresh.append(-1);
  rewthresh.append(0);
  rewthresh.append(1);
  rewthresh.append(-1);
  rewthresh.append(-2);
  for (int i=0; i<sized; i++){
    reachd[i] = randomGaussian();
    shiftsum = shiftsum+=reachd[i];
  }
  shiftmean = shiftsum/sized;
  reachstats1[0][0]= 0;
  reachstats1[0][1]= shiftmean;
  
  pick = round(random(1)*(sized-1))+1;
  thisreach = reachd[pick];
  reachdiff = thisreach-shiftmean;
  if (2*((thisreach-reachstats1[0][1]))<=-1){
    fromset = -1;
  }else{
    fromset = 1;
  }
  for (int i=0; i<sized; i++){
    if (2*((thisreach-shiftmean))-1<=-1){
      fromset2=-1;
    }else{
      fromset2 = 1;
    }
    reachd2[i] = reachd[i] + 1.8*(fromset2)-(fromset*setchange)+stimchange*fromset;
    if (thisreach>stimthresh){
      stimchange = .15;
    }
  }
  println("reachdmean: " + reachdmean);
  println("pick: " + pick);
  println("reachd(0);"+reachstats1[0][0] + ","+ reachstats1[0][1]);
  println(reachd[0]+"," +reachd[1]+","+reachd[2]);

  println("reachd2"+reachd2[0]+"," +reachd2[1]+","+reachd2[2]);
    println("fromset" + fromset);
}

//class mean{
//  float fl[][];
//  mean(float[][] xx){
//    fl = xx;
    
//  }
//}