class Player {
  int x, y;          // player coordinates (center)
  int w, h;          // player dimensions
  PImage image;      // player image
  
  Mode mode;
//  int hp, max_hp;     // hit points
//  int mp, max_mp;     // mana points
  final float base_xspd;
  final float base_yspd;
  float xspd, yspd;           // speed
  final float max_yspd;
  
  // direction player is facing
  XDir xd;
  YDir yd;
  
  // player velocity
  int xv, yv;
  
//  PlayerState state;
//  int frame, num_frames;
  
  int jmp;
  int stun_timer;
  // Constructor
  Player() {
    this.image = loadImage("data/player/sprites/dummy.png");

    this.w = this.image.width;
    this.h = this.image.height;
    
    this.x = map.tiles[0].length * map.tiles[0][0].image.width / 2;
    this.y = map.tiles.length * map.tiles[0][0].image.height / 2;
       
    this.xd = XDir.CENTER;
    this.yd = YDir.CENTER;
     
    this.xv = 0;
    this.yv = 0;
    
//     this.hp = this.max_hp = 10;
//     this.mp = this.max_mp = 10;

    this.base_xspd = this.xspd = 4;
    this.base_yspd = this.yspd = 4;
    this.max_yspd = 32;
    
    this.mode = Mode.STANDING;
    
    this.jmp = (int)(this.h * 1.3);
    this.stun_timer = 0;
  }

  // move the player by updating the coordinates
  void move() {
    
    for (int i = 0; i < (int)this.xspd; i++) {
      if (!horizontalTileCollision(this.x, this.y, this.w / 2, this.h / 2, this.xv)) {
        this.x = (this.x + this.xv + (map.tiles[0][0].image.width * map.tiles[0].length)) % (map.tiles[0][0].image.width * map.tiles[0].length);
      }
    }

    // move in the y direction
    for (int i = 0; i < (int)(this.yspd); i++) {
      if (!verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, this.yv)) {
        this.y = (this.y + this.yv + (map.tiles[0][0].image.height * map.tiles.length)) % (map.tiles[0][0].image.height * map.tiles.length);
      }
    }

    // account for gravity if its turned on
    if (map.gravity == true) {
      // player is jumping upwards
      if (this.yd == YDir.UP) {
        // if the player hits a tile with his head
        if (verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, -1)) {
          this.yd = YDir.DOWN;
          this.yv = 1;
          if (this.yspd > 4) this.yspd = 4;
        // if the player reaches the maximum jumping hight
        } else if (this.yspd < 1) {
          this.yd = YDir.DOWN;
          this.yv = 1;
       // if the player lands on a block and wants to keep jumping
        } else if (verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, 1) && w_pressed) {
          this.yspd = this.jmp / 6;
        // if the player is free to keep moving upwards normally
        } else {
          this.yspd -= this.yspd / (this.jmp / 6);
        }
      // the player is standing on the ground
      } else if (this.yd == YDir.CENTER) {
        // if there's no ground below the player make him fall
        if (!verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, 1)) {
          this.yd = YDir.DOWN;
          this.yv = 1;
          this.yspd = 4;
        // if there is ground and he wants to jump then let him jump
        } else if (w_pressed) {
          this.yd = YDir.UP;
          this.yv = -1;
          this.yspd = this.jmp / 6;
        }
      // the player is falling downwards
      } else if (this.yd == YDir.DOWN) {
        // if the player lands
        if (verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, 1)) {
          // if the player was falling at terminal velocity then stun him
          if (this.yspd == this.max_yspd) {
            this.setStunTimer((int)(frameRate / 2));
            this.yd = YDir.CENTER;
            this.yv = 0;
            this.yspd = 4;
            a_pressed = s_pressed = d_pressed = w_pressed = false;
          // otherwize the player hits the ground normally
          } else {
            this.yd = YDir.CENTER;
            this.yv = 0;
            this.yspd = 4; 
          }
        // if the player does not hit the ground then keep falling
        } else {
          if (this.yspd < this.max_yspd) this.yspd += 0.5;//this.yspd / this.max_yspd * 4;
          if (this.yspd > this.max_yspd) this.yspd = this.max_yspd;
        }
      }
    }
    
    if (this.stun_timer > 0) {
      this.stun_timer--;
      if (verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, 1)) {
        this.xd = XDir.CENTER;
        this.yd = YDir.CENTER;
        this.xv = this.yv = 0;
      }
    }
  }
  
  // render the player on screen
  void draw() {
    int x;
    int y;
    
    // calculate x
    if (camera.x <= camera.max_x_distance * 2 &&
      this.x >= (map.tiles[0].length * map.tiles[0][0].image.width) - (camera.max_x_distance * 2)) {
      x = this.x - (camera.x + (map.tiles[0].length * map.tiles[0][0].image.width));
    } else if (camera.x >= (map.tiles[0].length * map.tiles[0][0].image.width) - (camera.max_x_distance * 2) &&
      this.x <= camera.max_x_distance * 2) {
      x = (this.x + (map.tiles[0].length * map.tiles[0][0].image.width)) - camera.x;
    } else {
      x = this.x - camera.x;
    }
    
    // calculate y
    if (camera.y <= camera.max_y_distance * 2 &&
      this.y >= (map.tiles.length * map.tiles[0][0].image.height) - (camera.max_y_distance * 2)) {
      y = this.y - (camera.y + (map.tiles.length * map.tiles[0][0].image.height));
    } else if (camera.y >= (map.tiles.length * map.tiles[0][0].image.height) - (camera.max_y_distance * 2) &&
      this.y <= camera.max_y_distance * 2) {
      y = (this.y + (map.tiles.length * map.tiles[0][0].image.height)) - camera.y;
    } else {
      y = this.y - camera.y;
    }
    
    // draw the player
    imageMode(CENTER);
    image(this.image,
      (width / 2) + x,
      (height / 2) + y);
  }
  
  void setStunTimer(int stun_time) {
    if (this.stun_timer < stun_time && stun_time > 0) this.stun_timer = stun_time;
  }
}
