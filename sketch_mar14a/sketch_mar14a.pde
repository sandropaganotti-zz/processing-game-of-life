final int[] white = {255,255,255};
final int[] black = {0,0,0};

int grid_width = 100;
int grid_height = 100;
int canvas_width = 600;
int canvas_height = 600;
int box_width = canvas_width/grid_width;
int box_height = canvas_height/grid_height;
Spot[][] grid = new Spot[grid_width][grid_height];
int frames_to_skip = 0;
int current_frame  = 0;

boolean pause = false;

class Spot{ 
  int[]   rgb, rgb_next;
  int     x,y;
  Spot[]  neighbours;
  
  Spot(int gx, int gy, int[] c){
    rgb      = c; 
    rgb_next = new int[3]; 
    x       = gx;
    y       = gy;
  }
    
  void set_neighbors(Spot[][] grid){
    int xp = (x+1 == grid.length ? 0 : x+1);
    int xm = (x-1 == -1 ? grid.length - 1 : x-1);
    int yp = (y+1 == grid[0].length ? 0 : y+1);
    int ym = (y-1 == -1 ? grid[0].length - 1 : y-1);
    
    neighbours = new Spot[] {  grid[xm][ym], grid[xm][y ], grid[xm][yp],  
                               grid[x ][ym],               grid[x ][yp],  
                               grid[xp][ym], grid[xp][y ], grid[xp][yp] 
                            };
  }
  
  void compute(){
    int black_neighbours = 0;
    for(int z=0; z < neighbours.length; z++)
      if(neighbours[z].rgb == black)
        black_neighbours ++;  
        
    switch(black_neighbours){
      case 0:
      case 1:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
        to_color(white);
        break;
      case 2:
        to_color(rgb);
        break;
      case 3:
        to_color(black);
        break;
    }
  } 
  
  void advance(){
    rgb = rgb_next;
    rgb_next = new int[3];
  }
  
  void draw(int bw,int bh){
     fill(rgb[0],rgb[1],rgb[2]);
     rect(x*bw,y*bh,bw,bh);  
  }
 
  void to_color(int[] c){ rgb_next = c; }
}


void setup(){
 size(canvas_width,canvas_height);   
 stroke(125);
 
 for(int x=0; x<grid_width; x++)
   for(int y=0;y<grid_height;y++)
     grid[x][y] = new Spot(x,y,white);
     
 for(int x=0; x<grid_width; x++)
   for(int y=0;y<grid_height;y++)
     grid[x][y].set_neighbors(grid);
}

void draw(){
 if(pause) return; 
 current_frame ++;      
 if(current_frame < frames_to_skip) return;
 if(current_frame >= frames_to_skip) current_frame = 0;
 
 for(int x=0; x<grid_width; x++)
   for(int y=0;y<grid_height;y++)
    grid[x][y].draw(box_width,box_height);

 for(int x=0; x<grid_width; x++)
   for(int y=0;y<grid_height;y++)
     grid[x][y].compute();

 for(int x=0; x<grid_width; x++)
   for(int y=0;y<grid_height;y++)
     grid[x][y].advance();

}

void keyPressed() {
  switch(key){
    case 'p':
      pause = !pause;
      break;
    case 'i':
      frames_to_skip --;
      if(frames_to_skip < 0) frames_to_skip = 0;
      break;
    case 'd':
      frames_to_skip ++;
      if(frames_to_skip > 30) frames_to_skip = 30;
      break;    
  }
}

void mousePressed(){
  Spot elected = grid[mouseX/box_width][mouseY/box_height];
  elected.rgb = (elected.rgb == black ? white : black);
  elected.draw(box_width,box_height);
}
