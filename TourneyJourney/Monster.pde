/*class Monster {
  int cur_x, cur_y;
  int dst_x, dst_y;
  int range;
  int spd;
  boolean flying;
  PImage image;
  
  public Monster(int x, int y, int range, int spd, boolean flying, PImage image) {
    this.cur_x = this.dst_x = x;
    this.cur_y = this.dst_y = y;
    this.vel_x = this.vel_y = 0;
    this.range = range;
    this.spd = sdp;
    this.flying = flying;
  }
  
  // determine if a point is within range of the monster
  boolean seek(int x, int y) {
    int xd, yd;
    boolean clear_path = true;
    double distance;
    
    if (abs(this.cur_x - x) > map.tiles[0][0].width * map.tiles[0].length / 2) {
      if (x < map.tiles[0][0].width * map.tiles[0].length / 2)
        x += map.tiles[0][0].width * map.tiles[0].length / 2;
      else
        x -= map.tiles[0][0].width * map.tiles[0].length / 2;
    }
    xd = abs(this.cur_x - x);
    
    if (abs(this.cur_y - y) > map.tiles[0][0].height * map.tiles.length / 2) {
      if (y < map.tiles[0][0].height * map.tiles.length / 2)
        y += map.tiles[0][0].height * map.tiles.length / 2;
      else
        y -= map.tiles[0][0].height * map.tiles.length / 2;
    }
    yd = abs(this.cur_y - y);
        
    if (sqrt(sq(xd) + sq(yd)) <= this.range) {
      for (int i = min(x, cur_x); i += xd / map.tiles[0][0].image.width; i++) {} 
    }
  }
  
  // upadate the monster's coordinates
  void move() {
    for (int i = 0; i < this.spd; i++) {
    if (this.cur_x < this.dst_x) {
      if (this.dst_x - this.cur_x > map.tiles[0][0].width * map.tiles[0].length / 2)
        this.cur_x += map.tiles[0][0].width * map.tiles[0].length;
    } else if (this.cur_x > this.dst_x) {
      if (this.dst_x - this.cur_x > map.tiles[0][0].width * map.tiles[0].length / 2)
        this.cur_x += map.tiles[0][0].width * map.tiles[0].length;
    }
    this.cur_x %= map.tiles[0][0].width * map.tiles[0].length;
    this.cur_y %= map.tiles[0][0].height * map.tiles.length;
    this.dst_x %= map.tiles[0][0].width * map.tiles[0].length;
    this.dst_x %= map.tiles[0][0].height * map.tiles.length;
  }
}*/
