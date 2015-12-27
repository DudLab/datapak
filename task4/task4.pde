int w = 1600;
int h = 800;
int s = (w-800)/2;
int sh = (h-600);
PImage spritesheet;
int DIM_X = 4;
int DIM_Y = 4;
PImage[] sprites = new PImage[DIM_X*DIM_Y];
PImage bg;
PImage lv;
PImage lava;
int trialstate = 0;
int wallwidth = 100;
int wallheight = 10;
int psize=20;
int c =((w/2)-psize/2);
int bl=c-20;
int br=c+20;
int splatxs=h-psize-10;
int splats= h-psize-20;
int splatsh=sh+500;
int splatm= h-psize-30;
float px=(w/2)-psize/2;
float py=h-70;
float rx=px;
float ry=py;
float pxv=0;
float pyv=0;
float pspeed=5;
float gravity=0; 
boolean dead = false;
boolean falling = true;
int[][] blocks = {
 
  //boundary
  {0, -21, w, 20, 1},
  {0, h, w, 20, 1},
  {-21, 0, 20, h, 1},
  {w, 0, 20, h, 1},
  {0, h-20, w, 20, 1},
  //main platform
  {bl,0+sh,psize,500,1},
  {br,0+sh,psize,500,1},
  {bl-400,0+sh,psize,500,1},
  {br+400,0+sh,psize,500,1},
  {70+s, 470+sh, 30, 10, 0},
  {0+s, 430+sh, 20, 10, 1},
  {700+s, 470+sh, 30, 10, 0},
  {780+s, 430+sh, 20, 10, 1},
  {110+s, 380+sh, 200, 20, 1},
  {490+s, 380+sh, 200, 20, 1},
  //small obstacle
  
  //medium obstacles

  {200+s, h-psize, 400, 30, 1},
  {650, splats, 50, 20, 1},
  {900, splats, 50, 20, 1},
  {650-100, splats, 50, 20, 0},
  {900+100, splats, 50, 20, 0}, 
  {500, splatxs, 50, 10, 1},
  {1050, splatxs, 50, 10, 1},
  {500-20, splatxs, 25, 10, 0},
  {1050+50, splatxs, 25, 10, 0},
  {500-20-25*(1), splatxs, 25, 10, 0},
  {1050+50+25*(1), splatxs, 25, 10, 0}, 
  {500-20-25*(2), splatxs, 25, 10, 1},
  {1050+50+25*(2), splatxs, 25, 10, 1}, 
  {500-20-25*(3), splatxs, 25, 10, 0},
  {1050+50+25*(3), splatxs, 25, 10, 0},
  {500-20-25*(4), splatxs, 25, 10, 0},
  {1050+50+25*(4), splatxs, 25, 10, 0},
  {500-20-25*(5), splatxs, 25, 10, 1},
  {1050+50+25*(5), splatxs, 25, 10, 1},
  {500-20-25*(6), splatxs, 25, 10, 0},
  {1050+50+25*(6), splatxs, 25, 10, 0},
  {500-20-25*(7), splatxs, 25, 10, 0},
  {1050+50+25*(7), splatxs, 25, 10, 0},  
  {500-20-25*(8), splatxs, 25, 10, 1},
  {1050+50+25*(8), splatxs, 25, 10, 1},  
  {500-20-25*(9), splatxs, 25, 10, 0},
  {1050+50+25*(9), splatxs, 25, 10, 0},  
  {500-20-25*(10), splatxs, 25, 10, 0},
  {1050+50+25*(10), splatxs, 25, 10, 0},  
  {500-20-25*(11), splatxs, 25, 10, 1},
  {1050+50+25*(11), splatxs, 25, 10, 1},  
  {500-20-25*(12), splatxs, 25, 10, 0},
  {1050+50+25*(12), splatxs, 25, 10, 0},  
  
  {0,splats-30,50,50,0},
  {w-50,splats-30,50,50,0},
  
  {600+s-(200-psize/2), 480+sh, 400-psize/2+200, 20, 1},
  {0+s-200, 480+sh, 400-psize/2+200, 20, 1},
  
  //{375+s, 560, 50, 40, 0},

  
};
 
void setup() {
  size(1600, 800);
  bg=loadImage("smallgrid.jpg");
  spritesheet = loadImage("lava1.png");
  int W = spritesheet.width/DIM_X;
  int H = spritesheet.height/DIM_Y;
  for (int i=0; i<sprites.length; i++) {
    int x = i%DIM_X*W;
    int y = i/DIM_Y*H;
    sprites[i] = spritesheet.get(x, y, W, H);
  }
  //noStroke();
  noSmooth();
  frameRate(30);
}
 

wall[] walls;

void wallupdate(){
  int wallcnt =10;
  int wallnum[] = new int[wallcnt];
  walls = new wall[wallcnt];
  for(int j=0; j<wallcnt; j++){
    wallnum[j] = (50*j);
    walls[j] = new wall(((2*width/3))+wallwidth,(wallnum[j]),wallwidth,wallheight,walls);
    fill(255);
    rect(((2*width/3)),(wallnum[j]),wallwidth,wallheight);
    rect(((2*width/3))+wallwidth,(wallnum[j])+25,wallwidth,wallheight);
    //if (onwall(((2*width/3))+wallwidth,(wallnum[j])+25,wallwidth,wallheight) || onwall(((2*width/3))+wallwidth,(wallnum[j]),wallwidth,wallheight)){
    //    onwall=true;
    //}
  } 
}
void blockUpdate() {
  
  for (int i = 0; i<blocks.length; i++) {
 
    fill(100);


 
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
 
    rect(blocks[i][0], blocks[i][1], blocks[i][2], blocks[i][3]);
    if (blocks[i][4]==0) {
      fill(0, 250, 0);
      image(sprites[frameCount%sprites.length],blocks[i][0],blocks[i][1],blocks[i][2],blocks[i][3]);
      
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
   
  if(keys[82]){
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
  if(dead==true){
    fill(255,150,150);
  }
  rect(px, py, psize, psize);
}
 
 
 
 
 
void draw() {
  background(0);

  image(bg,0,0);
  playerInput();
  blockUpdate();
  //wallupdate();
  playerUpdate();
 
  fill(255, 0, 0);
  text(frameRate, 20, 20);
  text(pxv, 20, 30);
}

class wall{
  int wallx;
  int wally;
  int wallwidth;
  int wallheight;
  wall[] wa;
  
  wall(int wx, int wy, int ww,int wh, wall[] w){
    wallx = wx;
    wally = wy;
    wallwidth = ww;
    wallheight = wh;
    wa = w;
  }
}