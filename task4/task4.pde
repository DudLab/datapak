FloatList trig_prob;
PrintWriter output;
PrintWriter parameters;
String inStr; 
String fileName;
String mS = " ";
String dS = " ";
String data = " ";
String paramData = " ";
String directoryName = "test";
String testsubjectname = " ";
int w = 1600;
int h = 800;
int y;
int leftobstacle=0;
int s = (w-800)/2;
int sh = (h-600);
int DIM_X = 12;
int DIM_Y = 12;
int DIM_X1 = 3;
int DIM_Y1 = 4;
PImage spritesheet;
PImage[] sprites = new PImage[DIM_X*DIM_Y];
PImage spritesheet1;
PImage[] sprites1 = new PImage[DIM_X1*DIM_Y1];
PImage bg;
PImage wall; 
PImage wall1;
int startsize = 40;
int trialstate = 0;
int trialcnt=0;
int wallwidth = 100;
int wallheight = 10;
int rposy;
int psize=20;
int c =((w/2)-20/2);
int bl=c-20;
int br=c+20;
int splatxs=h-30;
int splats= h-40;
int splatsh=sh+500;
int splatm= h-50;
float p;
float px=(w/2)-psize/2;
float py=h-40;
float rx=px;
float ry=py;
float pxv=0;
float pyv=0;
float pspeed=7.5;
float gravity=0; 
boolean dead = false;
boolean falling = true;
boolean onstart=false;
boolean startstate=false;
boolean onleft = false;
boolean rewardstate=false;
boolean onrightreward=false;
boolean onleftreward=false;
boolean collectstate=false;
int[][] blocks = {
 
  //boundary platforms [1]
  {0, -21, w, 20, 1},
  {0, h, w, 20, 1},
  {-21, 0, 20, h, 1},
  {w, 0, 20, h, 1},
  {0, h-20, w, 20, 1},
  
  //reward
  {br+38,137,32,43,4},
  {bl-50,137,32,43,4},
  
  //walls  
  {bl,0+sh,10,500,1},
  {br+10,0+sh,10,500,1},
  {790,0,20,180,1},
  {220,0+sh,20,500,0},
  {1360,0+sh,20,500,0},
  {220,180,20,20,1},
  {1360,180,20,20,1},  
  {w-20,0,20,h,0},
  {0,0,20,h,0},
  {0,0,w,125,1},
   
  //L&R side platforms [2]
  {w-70,680,50,20,1},
  {20,680,50,20,1},  
  {w-220,630,50,20,1},
  {170,630,50,20,1},  
  {w-70,580,50,20,1},
  {20,580,50,20,1},  
  {w-220,530,50,20,1},
  {170,530,50,20,1}, 
  {w-70,480,50,20,1},
  {20,480,50,20,1},  
  {w-220,430,50,20,1},
  {170,430,50,20,1},  
  {w-70,380,50,20,1},
  {20,380,50,20,1},  
  {w-220,330,50,20,1},
  {170,330,50,20,1},  
  {w-70,280,50,20,1},
  {20,280,50,20,1},  
  {w-220,230,50,20,1},
  {170,230,50,20,1}, 
  {w-70,180,50,20,1},
  {20,180,50,20,1},
  
  //moving platforms corresponding to [2]
  {w-50,380,50,20,2},
  {0,380,50,20,3},
  {w-50,480,50,20,2},
  {0,480,50,20,3},
  {w-50,580,50,20,2},
  {0,580,50,20,3},
  
  //interior lr
  {br+20,680,50,20,1},
  {bl-50,680,50,20,1},  
  {br+180,630,50,20,1},
  {bl-200,630,50,20,1},  
  {br+20,580,50,20,1},
  {bl-50,580,50,20,1},  
  {br+180,530,50,20,1},
  {bl-200,530,50,20,1}, 
  {br+20,480,50,20,1},
  {bl-50,480,50,20,1},  
  {br+180,430,50,20,1},
  {bl-200,430,50,20,1},  
  {br+20,380,50,20,1},
  {bl-50,380,50,20,1},  
  {br+180,330,50,20,1},
  {bl-200,330,50,20,1},  
  {br+20,280,50,20,1},
  {bl-50,280,50,20,1},  
  {br+180,230,50,20,1},
  {bl-200,230,50,20,1}, 
  {br+20,180,50,20,1},
  {bl-50,180,50,20,1},
  
  //first floor misc
  {100,h-45,50,25,0},
  {w-150,h-45,50,25,0},  
  {50,splats-30,50,50,1},
  {w-100,splats-30,50,50,1},  
  {0,splats-30,50,50,0},
  {w-50,splats-30,50,50,0},
  
  {600+s-(190)+10, 480+sh, 580, 20, 1},
  {0+s-200, 480+sh, 580, 20, 1},
  
  //first floor obstacles
  {200+s, h-20, 400, 30, 1},
  {650, splats, 50, 20, 1},
  {900, splats, 50, 20, 1},
  {650-100, splats, 50, 20, 0},
  {900+100, splats, 50, 20, 0}, 
  {500, splatxs, 50, 10, 1},
  {1050, splatxs, 50, 10, 1},
  {475, splatxs, 25, 10, 0},
  {1100, splatxs, 25, 10, 0},
  {475-25*(1), splatxs, 25, 10, 0},
  {1100+25*(1), splatxs, 25, 10, 0}, 
  {475-25*(2), splatxs, 25, 10, 1},
  {1100+25*(2), splatxs, 25, 10, 1}, 
  {475-25*(3), splatxs, 25, 10, 0},
  {1100+25*(3), splatxs, 25, 10, 0},
  {475-25*(4), splatxs, 25, 10, 0},
  {1100+25*(4), splatxs, 25, 10, 0},
  {475-25*(5), splatxs, 25, 10, 1},
  {1100+25*(5), splatxs, 25, 10, 1},
  {475-25*(6), splatxs, 25, 10, 0},
  {1100+25*(6), splatxs, 25, 10, 0},
  {475-25*(7), splatxs, 25, 10, 0},
  {1100+25*(7), splatxs, 25, 10, 0},  
  {475-25*(8), splatxs, 25, 10, 1},
  {1100+25*(8), splatxs, 25, 10, 1}, 
  {475-25*(9), splatxs, 25, 10, 0},
  {1100+25*(9), splatxs, 25, 10, 0},
  {475-25*(10), splatxs, 25, 10, 0},
  {1100+25*(10), splatxs, 25, 10, 0},
  {475-25*(11), splatxs, 25, 10, 1},
  {1100+25*(11), splatxs, 25, 10, 1},  
  {475-25*(12), splatxs, 25, 10, 0},
  {1100+25*(12), splatxs, 25, 10, 0},
  {475-25*(13), splatxs, 25, 10, 0},
  {1100+25*(13), splatxs, 25, 10, 0},
  
  //second floor obstacles
  {475+150+25*(1), 670, 25, 10, 1},
  {1100-150-25*(1), 670, 25, 10, 1},
  {475+150+25*(2), 670, 25, 10, 0},
  {1100-150-25*(2), 670, 25, 10, 0},
  {475+150+25*(3), 670, 25, 10, 0},
  {1100-150-25*(3), 670, 25, 10, 0},  
  {475+150+25*(4), 670, 25, 10, 1},
  {1100-150-25*(4), 670, 25, 10, 1},
  {475+150+25*(5), 670, 25, 10, 1},
  {1100-150-25*(5), 670, 25, 10, 1},    
  {475+150, 670, 25, 10, 0},
  {1100-150, 670, 25, 10, 0},
  {475-25*(1)+150, 670, 25, 10, 0},
  {1100+25*(1)-150, 670, 25, 10, 0}, 
  {475-25*(2)+150, 670, 25, 10, 1},
  {1100+25*(2)-150, 670, 25, 10, 1}, 
  {475-25*(3)+150, 670, 25, 10, 0},
  {1100+25*(3)-150, 670, 25, 10, 0},
  {475-25*(4)+150, 670, 25, 10, 0},
  {1100+25*(4)-150, 670, 25, 10, 0},
  {475-25*(5)+150, 670, 25, 10, 1},
  {1100+25*(5)-150, 670, 25, 10, 1},
  {475-25*(6)+150, 670, 25, 10, 0},
  {1100+25*(6)-150, 670, 25, 10, 0},
  {475-25*(7)+150, 670, 25, 10, 0},
  {1100+25*(7)-150, 670, 25, 10, 0},  
  {475-25*(8)+150, 670, 25, 10, 1},
  {1100+25*(8)-150, 670, 25, 10, 1}, 
  {475-25*(9)+150, 670, 25, 10, 0},
  {1100+25*(9)-150, 670, 25, 10, 0},
  {475-25*(10)+150, 670, 25, 10, 0},
  {1100+25*(10)-150, 670, 25, 10, 0},
  {475-25*(11)+150, 670, 25, 10, 1},
  {1100+25*(11)-150, 670, 25, 10, 1},  
  {475-25*(12)+150, 670, 25, 10, 0},
  {1100+25*(12)-150, 670, 25, 10, 0},
  {475-25*(13)+150, 670, 25, 10, 0},
  {1100+25*(13)-150, 670, 25, 10, 0},
  {475-25*(14)+150, 670, 25, 10, 1},
  {1100+25*(14)-150, 670, 25, 10, 1},
  {475-25*(15)+150, 670, 25, 10, 1},
  {1100+25*(15)-150, 670, 25, 10, 1},
  {475-25*(16)+150, 670, 25, 10, 1},
  {1100+25*(16)-150, 670, 25, 10, 1},
  

  
};
 
void setup() {
  size(1600, 800);
  y=0;
  bg=loadImage("smallgrid.jpg");
  wall=loadImage("wall.jpg");
  //sprites
  //sprites lava
  spritesheet = loadImage("lava1.png");
  int W = spritesheet.width/DIM_X;
  int H = spritesheet.height/DIM_Y;
  for (int i=0; i<sprites.length; i++) {
    int x = i%DIM_X*W;
    int y = i/DIM_Y*H;
    sprites[i] = spritesheet.get(x, y, W, H);
  }
  //sprites reward 
  spritesheet1= loadImage("rewardsprite.png");
  int W1 = spritesheet1.width/DIM_X1;
  int H1 = spritesheet1.height/DIM_Y1;
  for (int i1 =0; i1 < sprites1.length; i1++){
    int x1 = i1%DIM_X1*W1;
    int y1 = i1/DIM_Y1*H1;
    sprites1[i1] = spritesheet1.get(x1, y1, W1, H1);
  }
  noStroke();
  noSmooth();
  frameRate(30);
  //task stuff
  trig_prob = new FloatList();
  trig_prob.append(0.1);
  trig_prob.append(0.25);
  trig_prob.append(0.5);
  trig_prob.append(0.75);
  trig_prob.append(0.9);
  trig_prob.shuffle();
  
}
 


void blockUpdate() {
  y+=1;
  if (y>220){
    y=0;
  }

  for (int i = 0; i<blocks.length; i++) {
 
    fill(100);
    //regular platforms
    if (px+pxv+psize>blocks[i][0] && px+pxv<blocks[i][0]+blocks[i][2] && py+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3] && blocks[i][4]<4) {
      if (blocks[i][4]==0) {
        dead=true;
      }
      pxv=0;
    }
 
    if (px+psize>blocks[i][0] && px<blocks[i][0]+blocks[i][2] && py+pyv+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3]&& blocks[i][4]<4) {
      if (blocks[i][4]==0) {
        dead=true;
      }
      pyv=0;
      gravity=0;
      falling = false;
    }
 
    if (px+psize>blocks[i][0] && px<blocks[i][0]+blocks[i][2] && py+psize>blocks[i][1] && py+pyv<blocks[i][1]+blocks[i][3]&& blocks[i][4]<4) {
      if (blocks[i][4]==0) {
        dead=true;
      }
      pyv=0;
      gravity=0;
    }
   
   //right side moving platform
    if (blocks[i][4]==2) {//on bottom
      if (px+pxv+psize>blocks[i][0]-y && px+pxv<blocks[i][0]+blocks[i][2]-y && py+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3]) {
        pxv=0;
      }
    }
      
    if (blocks[i][4]==2) {//top
      if (px+psize>blocks[i][0]-y && px<blocks[i][0]+blocks[i][2]-y && py+pyv+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3]) {
        pyv=0;        
        gravity=0;
        falling = false;
      }
    }
    
    if (blocks[i][4]==2) {//side
      if (px+pxv+psize>blocks[i][0]-y && px+pxv<blocks[i][0]+blocks[i][2]-y && py+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3]) {       
        pyv+=2;
        gravity=0;
      }
    }
      
    //left side moving platform
    if (blocks[i][4]==3) {
      if (px+pxv+psize>blocks[i][0]+y && px+pxv<blocks[i][0]+blocks[i][2]+y && py+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3]) {
        pxv=0;
      }
    }
      
    if (blocks[i][4]==3) {
      if (px+psize>blocks[i][0]+y && px<blocks[i][0]+blocks[i][2]+y && py+pyv+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3]) {
        pyv=0;
        gravity=0;
        falling = false;
      }
    }
    if (blocks[i][4]==3) {
      if (px+pxv+psize>blocks[i][0]+y && px+pxv<blocks[i][0]+blocks[i][2]+y && py+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3]) {
        pyv+=2;
        gravity=0;

        }
      }
      
    
    if (blocks[i][4]==0) {
      fill(0, 250, 0);
      image(sprites[frameCount%sprites.length],blocks[i][0],blocks[i][1],blocks[i][2],blocks[i][3]);
    }
    
    if (blocks[i][4]==4) {
      fill(0, 250, 0);
      if (rewardstate==true){
        image(sprites1[frameCount%sprites1.length],blocks[i][0],blocks[i][1],blocks[i][2],blocks[i][3]);
      }else{
        image(sprites1[1],blocks[i][0],blocks[i][1],blocks[i][2],blocks[i][3]);
      }
    }

    if (blocks[i][4]==1) {
      rect(blocks[i][0], blocks[i][1], blocks[i][2], blocks[i][3]);
      wall1 = wall.get(blocks[i][0],blocks[i][1],blocks[i][2],blocks[i][3]);
      image(wall1,blocks[i][0],blocks[i][1]);
    }
    
    if (blocks[i][4]==2) {
      rect(blocks[i][0]-y, blocks[i][1], blocks[i][2], blocks[i][3]);
    }
    
    if (blocks[i][4]==3) {
      rect(blocks[i][0]+y, blocks[i][1], blocks[i][2], blocks[i][3]);
    }    
  }
}
 
 
 
boolean[] keys = new boolean[256];

void keyPressed() {
  keys[keyCode]=true;
      rewardstate=true;
};

void keyReleased() {
  keys[keyCode]=false;
      rewardstate=false;
};

void playerInput() {
  pxv=0;
  pyv=0;
 
 
  if (dead==false) {
    if (keys[UP] && falling==false) {
      gravity-=7;
    }
    
    if (keys[LEFT]) {
      pxv=-pspeed;
    }
    
    if (keys[RIGHT]) {
      pxv=pspeed;
    }
  }
  
  if (keyCode=='1') {
    leftobstacle=0;
  }
  
  if (keyCode=='2') {
    leftobstacle=1;
  }
  
  if(keys[82]&& dead ==true){
    dead=false;
    px=rx;
    py=ry;
  }
  pyv+=gravity;
  gravity+=0.5;
  falling = true;
}
void playerUpdate() {
  px+=pxv;
  py+=pyv;
   
  fill(255, 0, 0);
  if (dead==true){
    fill(255,150,150);
  }
  rect(px, py, psize, psize);
}
 
 
 
 
 
void draw() {
  
  background(0);
  image(bg,0,0);
  fill(255, 0, 0);
  text(frameRate, 20, 20);
  text(px, 20, 30);
  text(py, 20, 50);  
  text(trialstate, 20, 70);
  fill(0);
  rect(780,740,40,40);
  playerInput();
  blockUpdate();
  playerUpdate();
  
  if (onleft(0,400,780,800) && leftobstacle==1){
    pspeed=14;
  }else{
    pspeed=7.5;
  }


 
  switch(trialstate){
    case 0:
      startstate=false;
      if (onstart(780,740,startsize,startsize)){
        startstate=true;
        trialstate=1;
      }else{
        startstate=false;
      }
    break;
    
      
    case 1:
    collectstate=false;
    //trialstate=2;
    break;
    
    case 2:
    //trialstate=3;
    break;
    
  }
}

boolean onleft(int lx, int ly, int lw, int lh){
  if (px>=lx && px+psize<=lw && py>=ly && py<=ly+lh){
    return true;
  }else{
    return false;
  }
  
}

boolean onstart(int x0, int y0, int sw, int sh) {
  if (px>=x0 && px+psize<=x0+sw && py>=y0 && py<=y0+sh) {
    return true;
  } else {
    return false;
  }
}