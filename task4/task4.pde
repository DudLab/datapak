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
int DIM_X = 4;
int DIM_Y = 4;
PImage spritesheet;
PImage[] sprites = new PImage[DIM_X*DIM_Y];
PImage bg;
PImage wall; 
PImage wall1;
int trialstate = 0;
int trialcnt=0;
int wallwidth = 100;
int wallheight = 10;
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
float py=h-70;
float rx=px;
float ry=py;
float pxv=0;
float pyv=0;
float pspeed=7.5;
float gravity=0; 
boolean dead = false;
boolean falling = true;
boolean onleft = false;
boolean onrightreward=false;
boolean onleftreward=false;
int[][] blocks = {
 
  //boundary platforms [1]
  {0, -21, w, 20, 1},
  {0, h, w, 20, 1},
  {-21, 0, 20, h, 1},
  {w, 0, 20, h, 1},
  {0, h-20, w, 20, 1},
  //walls
  {bl,0+sh,20,500,1},
  {br,0+sh,20,500,1},
  {220,0+sh,20,500,1},
  {1360,0+sh,20,500,1},
  {w-20,0,20,h,1},
  {0,0,20,h,1},
   
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
  //{w-50-y,380,50,20,2},
  //{y,380,50,20,2},
  //{w-70,480,50,20,1},
  //{20,480,50,20,1},

  {700+s, 470+sh, 30, 10, 0},
  {70+s, 470+sh, 30, 10, 0},
  {700+s, 470+sh, 30, 10, 0},
  {0+s, 430+sh, 20, 10, 1},
  {780+s, 430+sh, 20, 10, 1},
  {110+s, 380+sh, 200, 20, 1},
  {490+s, 380+sh, 200, 20, 1},
  
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
  
  {100,h-45,50,25,0},
  {w-150,h-45,50,25,0},  
  {50,splats-30,50,50,1},
  {w-100,splats-30,50,50,1},  
  {0,splats-30,50,50,0},
  {w-50,splats-30,50,50,0},
  
  {600+s-(190), 480+sh, 590, 20, 1},
  {0+s-200, 480+sh, 590, 20, 1},
  
};
 
void setup() {
  size(1600, 800);
  y=0;
  bg=loadImage("smallgrid.jpg");
  wall=loadImage("wall.jpg");
  //sprites
  spritesheet = loadImage("lava1.png");
  int W = spritesheet.width/DIM_X;
  int H = spritesheet.height/DIM_Y;
  for (int i=0; i<sprites.length; i++) {
    int x = i%DIM_X*W;
    int y = i/DIM_Y*H;
    sprites[i] = spritesheet.get(x, y, W, H);
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
    if (px+pxv+psize>blocks[i][0] && px+pxv<blocks[i][0]+blocks[i][2] && py+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3]) {
      if (blocks[i][4]==0) {
        dead=true;
      }
      pxv=0;
    }
 
    if (px+psize>blocks[i][0] && px<blocks[i][0]+blocks[i][2] && py+pyv+psize>blocks[i][1] && py<blocks[i][1]+blocks[i][3]) {
      if (blocks[i][4]==0) {
        dead=true;
      }
      pyv=0;
      gravity=0;
      falling = false;
    }
 
    if (px+psize>blocks[i][0] && px<blocks[i][0]+blocks[i][2] && py+psize>blocks[i][1] && py+pyv<blocks[i][1]+blocks[i][3]) {
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
};

void keyReleased() {
  keys[keyCode]=false;
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
  text(y, 20, 50);
  fill(0);
  playerInput();
  blockUpdate();
  playerUpdate();
  if (onleft(0,400,770,800) && leftobstacle==1){
    pspeed=14;
  }else{
    pspeed=7.5;
  }
    


 
  switch(trialstate){
    case 0:
    trialstate=1;
    break;
    
    case 1:
    trialstate=2;
    break;
    
    case 2:
    trialstate=3;
    break;
    
  }
}

boolean onleft(int lx, int ly, int lw, int lh){
  if (px>=lx && px+psize<=lw && py>=ly && py<=lh){
    return true;
  }else{
    return false;
  }
  
}