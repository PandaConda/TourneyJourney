class Player {
  int x, y;          // player coordinates (center)
  int w, h;          // player dimensions
  PImage image;      // player image

  Mode mode;
  int real_hp, fake_hp, max_hp;    // hit points
  int real_tp, fake_tp, max_tp;    // time points
  int real_gp, fake_gp, max_gp;    // gravity points
  int kp;                          // kill points
  
  final float base_xspd;
  final float base_yspd;
  float xspd, yspd;           // speed
  final float max_yspd;
  boolean walljump;

  // direction player is facing
  XDir xd;
  YDir yd;

  // player velocity
  int xv, yv;

  int hp_pause;

  //  PlayerState state;
  //  int frame, num_frames;

  int jmp;
  int jmp_count, jmp_max;
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

    this.base_xspd = this.xspd = 4;
    this.base_yspd = this.yspd = 4;
    this.max_yspd = 32;

    this.mode = Mode.STANDING;

    this.real_hp = this.fake_hp = this.max_hp = 9999;
    this.real_tp = this.fake_tp = this.max_tp = 500;
    this.real_gp = this.fake_gp = this.max_gp = 500;
    this.kp = 1234;

    this.jmp = (int)(this.h * 1.3);
    this.jmp_count = 0;
    this.jmp_max = 2;
    this.stun_timer = 0;

    this.hp_pause = 0;
    this.walljump = true;
  }

  // move the player by updating the coordinates
  void move() {
    for (int i = 0; i < (this.xspd > this.yspd ? (int)this.xspd : (int)this.yspd); i++) {
      if (i < (int)this.xspd)
        if (!horizontalTileCollision(this.x, this.y, this.w / 2, this.h / 2, this.xv))
          this.x = (this.x + this.xv + (map.tiles[0][0].image.width * map.tiles[0].length)) % (map.tiles[0][0].image.width * map.tiles[0].length);
        else if (horizontalTileDamage(this.x, this.y, this.w / 2, this.h / 2, this.xv))
          this.changeHP(-50);
      if (i < (int)this.yspd)
        if (!verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, this.yv))
          this.y = (this.y + this.yv + (map.tiles[0][0].image.height * map.tiles.length)) % (map.tiles[0][0].image.height * map.tiles.length);
        else if (verticalTileDamage(this.x, this.y, this.w / 2, this.h / 2, this.yv))
          this.changeHP(-50);
    }

    // account for gravity if its turned on
    if (map.gravity == true) {
      // player is jumping upwards
      if (this.yd == YDir.UP) {
        // if the player hits a tile with his head
        if (verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, -1)) {
          this.xd = XDir.CENTER;
          this.xv = 0;
          this.yd = YDir.DOWN;
          this.yv = 1;
          this.walljump = false;
          if (this.yspd > 4) this.yspd = 4;
        // if the player reaches the maximum jumping height
        } else if (this.yspd < 1) {
          this.yd = YDir.DOWN;
          this.yv = 1;
        // if the player lands on a block and wants to keep jumping
        } else if (verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, 1) && w_pressed) {
          this.jmp_count = 1;
          this.yspd = this.jmp / 7;
          this.walljump = true;
        // if the player is free to keep moving upwards normally
        } else {
          this.yspd -= this.yspd / (this.jmp / 6);
        }
        // the player is standing on the ground
      } else if (this.yd == YDir.CENTER) {
        // if there's no ground below the player make him fall
        if (!verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, 1)) {
          this.jmp_count = 1;
          this.yd = YDir.DOWN;
          this.yv = 1;
          this.yspd = 4;
        // if there is ground and he wants to jump then let him jump
        } else if (w_pressed &&
          !(verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, -1) && verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, 1))) {
          this.walljump = true;
          this.jmp_count = 1;
          this.yd = YDir.UP;
          this.yv = -1;
          this.yspd = this.jmp / 6;
        } else if (map.gravity == true && verticalTileDamage(this.x, this.y, this.w / 2, this.h / 2, 1)) {
          this.changeHP(-50);
        }
      // the player is falling downwards
      } else if (this.yd == YDir.DOWN) {
        // if the player lands
        if (verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, 1)) {
          this.jmp_count = 1;
          this.walljump = true;
          if (a_pressed && !d_pressed) {
            this.xd = XDir.LEFT;
            this.xv = -1;
          } else if (!a_pressed && d_pressed) {
            this.xd = XDir.RIGHT;
            this.xv = 1;
          } else if (!a_pressed && !d_pressed) {
            this.xd = XDir.CENTER;
            this.xv = 0;
          }
          // if the player was falling at terminal velocity then stun him
          if (this.yspd == this.max_yspd) {
            this.hp_pause = 0;
            this.changeHP(-500);
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
            if (map.gravity == true && verticalTileDamage(this.x, this.y, this.w / 2, this.h / 2, 1))
              this.changeHP(-50);
          }
        // if the player does not hit the ground then keep falling
        } else {
          // slow fall when touching a wall
          if (horizontalTileCollision(this.x, this.y, this.w / 2, this.h / 2, this.xv)) {
            if (a_pressed && !d_pressed) {
              this.xd = XDir.LEFT;
              this.xv = -1;
            } else if (!a_pressed && d_pressed) {
              this.xd = XDir.RIGHT;
              this.xv = 1;
            } else if (!a_pressed && !d_pressed) {
              this.xd = XDir.CENTER;
              this.xv = 0;
            }
            this.yspd = this.jmp / 12;
            this.walljump = true;
          }
          // wall jump
          if (w_pressed && this.walljump == true && horizontalTileCollision(this.x, this.y, this.w / 2, this.h / 2, this.xv)) {
            this.yd = YDir.UP;
            this.yv = -1;
            this.yspd = this.jmp / 6;
            this.walljump = false;
            this.jmp_count = 1;
            
            // bounce player off wall
            if (!verticalTileCollision(this.x, this.y, this.w / 2, this.h / 2, map.tiles[0][0].image.height)) {
              if (horizontalTileCollision(this.x, this.y, this.w / 2, this.h / 2, -1)) {
                this.xd = XDir.RIGHT;
                this.xv = 1;
              } else if (horizontalTileCollision(this.x, this.y, this.w / 2, this.h / 2, 1)) {
                this.xd = XDir.LEFT;
                this.xv = -1;
              }
            }

          // jump again if the player holds down jump button and there are jumps left
          } else if (w_pressed && jmp_count < jmp_max) {
            this.jmp_count++;
            this.yd = YDir.UP;
            this.yv = -1;
            this.yspd = this.jmp / 6;
            if (a_pressed && !d_pressed) {
              this.xd = XDir.LEFT;
              this.xv = -1;
            } else if (!a_pressed && d_pressed) {
              this.xd = XDir.RIGHT;
              this.xv = 1;
            } else if (!a_pressed && !d_pressed) {
              this.xd = XDir.CENTER;
              this.xv = 0;
            }
          } else {
            if (this.yspd < this.max_yspd) this.yspd += 0.5;
            if (this.yspd > this.max_yspd) this.yspd = this.max_yspd;
          }
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
  
    if (this.fake_hp > this.real_hp)
      for (int i = 0; i <= (int)log(this.fake_hp - this.real_hp); i++)
        this.fake_hp--;
    else if (this.fake_hp < this.real_hp)
      for (int i = 0; i <= (int)log(this.real_hp - this.fake_hp); i++)
        this.fake_hp++;
  
    if (this.hp_pause > 0)
      this.hp_pause--;
      
    if (map.gravity == false)
      if (--this.real_gp == 0)
        map.flipGravity();
    
    if (this.fake_gp > this.real_gp)
      for (int i = 0; i <= (int)log(this.fake_gp - this.real_gp); i++)
        this.fake_gp--;
    else if (this.fake_gp < this.real_gp)
      for (int i = 0; i <= (int)log(this.real_gp - this.fake_gp); i++)
        this.fake_gp++;
        
    if (map.slowtime == true)
      if (--this.real_tp == 0)
        map.changeTimeSpeed();
    
    if (this.fake_tp > this.real_tp)
      for (int i = 0; i <= (int)log(this.fake_tp - this.real_tp); i++)
        this.fake_tp--;
    else if (this.fake_tp < this.real_tp)
      for (int i = 0; i <= (int)log(this.real_tp - this.fake_tp); i++)
        this.fake_tp++;
  }

  // render the player on screen
  void draw() {
    int x;
    int y;

    // calculate x
    if (camera.x <= camera.max_x_distance * 2 &&
      this.x >= (map.tiles[0].length * map.tiles[0][0].image.width) - (camera.max_x_distance * 2)) {
      x = this.x - (camera.x + (map.tiles[0].length * map.tiles[0][0].image.width));
    } 
    else if (camera.x >= (map.tiles[0].length * map.tiles[0][0].image.width) - (camera.max_x_distance * 2) &&
      this.x <= camera.max_x_distance * 2) {
      x = (this.x + (map.tiles[0].length * map.tiles[0][0].image.width)) - camera.x;
    } 
    else {
      x = this.x - camera.x;
    }

    // calculate y
    if (camera.y <= camera.max_y_distance * 2 &&
      this.y >= (map.tiles.length * map.tiles[0][0].image.height) - (camera.max_y_distance * 2)) {
      y = this.y - (camera.y + (map.tiles.length * map.tiles[0][0].image.height));
    } 
    else if (camera.y >= (map.tiles.length * map.tiles[0][0].image.height) - (camera.max_y_distance * 2) &&
      this.y <= camera.max_y_distance * 2) {
      y = (this.y + (map.tiles.length * map.tiles[0][0].image.height)) - camera.y;
    } 
    else {
      y = this.y - camera.y;
    }

    // draw the player
    if (map.slowtime == true) tint(126, 126);
    imageMode(CENTER);
    image(this.image, 
    (width / 2) + x, 
    (height / 2) + y);
  }

  void setStunTimer(int stun_time) {
    if (this.stun_timer < stun_time && stun_time > 0) this.stun_timer = stun_time;
  }

  // change the HP and the heart size
  void changeHP(int d_hp) {
    if (this.hp_pause == 0) {
      if (d_hp < 0 && this.real_hp > 0) {

        /*    // flash when taking damage if slomode is on
         if (map.slowtime == true) {
         loadPixels();
         for (int i = 0; i < width * height; i++)
         pixels[i] = color(0, 0, 0, 255);
         updatePixels();
         }
         */
        if (this.real_hp > -d_hp) this.real_hp += d_hp;
        else this.real_hp = 0;

        if (-d_hp > this.max_hp)
          hud.hp_scale = 0;
        else if (hud.hp_scale > 1 + ((float)d_hp / (float)this.max_hp))
          hud.hp_scale = 1 + ((float)d_hp / (float)this.max_hp);

        this.hp_pause = 120;
      } 
      else if (d_hp > 0 && this.real_hp < this.max_hp) {

        if (this.real_hp + d_hp < this.max_hp) this.real_hp += d_hp;
        else this.real_hp = this.max_hp;

        if (d_hp > this.max_hp)
          hud.hp_scale = 2;
        else if (hud.hp_scale < 1 - ((float)d_hp / (float)this.max_hp))
          hud.hp_scale = 1 - ((float)d_hp / (float)this.max_hp);
      }

      this.hp_pause = 120;
      if (this.real_hp == 0)
        this.mode = Mode.DEAD;
    }
  }
}

