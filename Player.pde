class Player extends Creature {
  int fake_hp;                     // hit points
  int real_tp, fake_tp, max_tp;    // time points
  int real_gp, fake_gp, max_gp;    // gravity points
  int kp;                          // kill points
  
  boolean walljump;

  int hp_pause;

  //  PlayerState state;
  //  int frame, num_frames;

  int jmp;
  int jmp_count, jmp_max;
  
  int stun_timer;
  
  // Constructor
  Player(int level, PImage left, PImage center, PImage right, int hp, int tp, int gp) {
    super(left, center, right, hp);
    
    int[] coordinates = new int[2];
    BufferedReader file_reader = createReader("data/levels/" + level + "/properties.dat");
    try {
      file_reader.readLine();
      coordinates = parseInt(file_reader.readLine().split(" "));
    } catch (IOException e) {
      e.printStackTrace();
    }
    
    this.x = coordinates[0];
    this.y = coordinates[1];
    
    this.mode = Mode.STANDING;
    
    this.fake_hp = hp; this.max_hp = 9999;
    this.real_tp = this.fake_tp = tp; this.max_tp = 9999;
    this.real_gp = this.fake_gp = gp; this.max_gp = 9999;
    this.kp = 0;

    this.jmp = (int)(this.image.height * 1.3);
    this.jmp_count = 0;
    this.jmp_max = 2;
    this.stun_timer = 0;

    this.hp_pause = 0;
    this.walljump = true;
  }

  // move the player by updating the coordinates
  void move() {
    super.move();

    // account for gravity if its turned on
    if (map.gravity == true) {
      // player is jumping upwards
      if (this.yd == YDir.UP) {
        // if the player hits a tile with his head
        if (verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, -1)) {
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
        } else if (verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1) && w_pressed) {
          this.jmp_count = 1;
          this.yspd = this.jmp / 6;
          this.walljump = true;
        // if the player is free to keep moving upwards normally
        } else {
          this.yspd -= this.yspd / (this.jmp / 6);
        }
        // the player is standing on the ground
      } else if (this.yd == YDir.CENTER) {
        // if there's no ground below the player make him fall
        if (!verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
          this.jmp_count = 1;
          this.yd = YDir.DOWN;
          this.yv = 1;
          this.yspd = 4;
        // if there is ground and he wants to jump then let him jump
        } else if (w_pressed &&
        !(verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, -1) &&
        verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1))) {
          this.walljump = true;
          this.jmp_count = 1;
          this.yd = YDir.UP;
          this.yv = -1;
          this.yspd = this.jmp / 6;
        } else if (map.gravity == true && verticalTileDamage(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
          this.changeHP(-50);
        }
      // the player is falling downwards
      } else if (this.yd == YDir.DOWN) {
        // if the player lands
        if (verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
          this.jmp_count = 1;
          this.walljump = true;
          if (a_pressed && !d_pressed) {
            this.xd = XDir.LEFT;
            this.image = this.left;
            this.xv = -1;
          } else if (!a_pressed && d_pressed) {
            this.xd = XDir.RIGHT;
            this.image = this.right;
            this.xv = 1;
          } else if (!a_pressed && !d_pressed) {
            this.xd = XDir.CENTER;
            this.image = this.center;
            this.xv = 0;
          }
          // if the player was falling at terminal velocity then stun him
          if (this.yspd == this.max_yspd) {
            this.hp_pause = 0;
            this.changeHP(-150);
            this.setStunTimer((int)(frameRate / 2));
            this.setHPPause((int)(frameRate / 2));
            this.yd = YDir.CENTER;
            this.yv = 0;
            this.yspd = 4;
            a_pressed = s_pressed = d_pressed = w_pressed = false;
            // otherwize the player hits the ground normally
          } else {
            this.yd = YDir.CENTER;
            this.yv = 0;
            this.yspd = 4;
            if (map.gravity == true && verticalTileDamage(this.x, this.y, this.image.width / 2, this.image.height / 2, 1))
              this.changeHP(-50);
          }
        // if the player does not hit the ground then keep falling
        } else {
          // slow fall when touching a wall
          if (horizontalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, this.xv)) {
            if (a_pressed && !d_pressed) {
              this.xd = XDir.LEFT;
              this.image = this.left;
              this.xv = -1;
            } else if (!a_pressed && d_pressed) {
              this.xd = XDir.RIGHT;
              this.image = this.right;
              this.xv = 1;
            } else if (!a_pressed && !d_pressed) {
              this.xd = XDir.CENTER;
              this.image = this.center;
              this.xv = 0;
            }
            this.yspd = this.jmp / 12;
            this.walljump = true;
          }
          // wall jump
          if (w_pressed && this.walljump == true && horizontalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, this.xv)) {
            this.yd = YDir.UP;
            this.yv = -1;
            this.yspd = this.jmp / 6;
            this.walljump = false;
            this.jmp_count = 1;
            
            // bounce player off wall
            if (!verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, map.tiles[0][0].image.height)) {
              if (horizontalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, -1)) {
                this.xd = XDir.RIGHT;
                this.image = this.right;
                this.xv = 1;
              } else if (horizontalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
                this.xd = XDir.LEFT;
                this.image = this.left;
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
              this.image = this.left;
              this.xv = -1;
            } else if (!a_pressed && d_pressed) {
              this.xd = XDir.RIGHT;
              this.image = this.right;
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
      if (verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
        this.xd = XDir.CENTER;
        this.yd = YDir.CENTER;
        this.xv = this.yv = 0;
      }
    }
  
    // check for monster collisions
    for (Monster monster : monsters) {
      if (monster.real_hp > 0 &&
        abs(monster.x - this.x) < (monster.image.width / 2) + (this.image.width / 2) &&
        abs(monster.y - this.y) < (monster.image.height / 2) + (this.image.height / 2)) {
        // jump on monster
        if (map.gravity == true &&
        this.y + (this.image.height / 2) >= monster.y - (monster.image.height / 2) &&
        this.y + (this.image.height / 2) <= monster.y - (monster.image.height / 2) + this.yspd) {
          monster.changeHP(-(int)this.yspd);
          this.yd = YDir.UP;
          this.yv = -1;
          this.yspd = this.jmp / 6;
          this.walljump = true;
          this.jmp_count = 1;
          
          int rnd = (int)random(2);
          if (rnd == 0) monster.dst_x = monster.x + 1;
          else if (rnd == 0) monster.dst_x = monster.x - 1;
          
        // get hit by monster
        } else if (this.hp_pause == 0) {
          this.changeHP(-25);
          this.setHPPause((int)(frameRate * 0.5));
          if (map.gravity == true) {
            if (monster.x > this.x || horizontalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
              this.xd = XDir.LEFT;
              this.image = this.left;
              this.xv = -1;
            } else if (monster.x < this.x || horizontalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, -1)) {
              this.xd = XDir.RIGHT;
              this.image = this.right;
              this.xv = 1;
            }
            this.yd = YDir.UP;
            this.yv = -1;
            this.yspd = this.jmp / 6;
            this.walljump = true;
            this.jmp_count = 1;
          }
          a_pressed = s_pressed = d_pressed = w_pressed = false;
        }
      }
    }
    
    // check for item collisions
    for (int i = 0; i < items.length; i++) {      
      if (items[i] != null &&
      abs(this.x - items[i].x) <= this.image.width - items[i].image.width &&
      abs(this.y - items[i].y) <= this.image.height - items[i].image.height) {
        this.changeHP(items[i].hp);
        this.changeTP(items[i].tp);
        this.changeGP(items[i].gp);
        items[i] = null;
      }
    }

    // change hp in smaller chunks
    if (this.fake_hp > this.real_hp)
      for (int i = 0; i <= (int)log(this.fake_hp - this.real_hp); i++)
        this.fake_hp--;
    else if (this.fake_hp < this.real_hp)
      for (int i = 0; i <= (int)log(this.real_hp - this.fake_hp); i++)
        this.fake_hp++;
  
    // pause hp makes player temporarily invunerable after taking a hit
    if (this.hp_pause > 0)
      this.hp_pause--;
      
    // flip gravity if gp points run out
    if (map.gravity == false) {
      if (--this.real_gp == 0) {
        map.flipGravity();
        hud.gp_scale = 0.5;
      }
    }
    
    // reduce gp in smaller chunks
    if (this.fake_gp > this.real_gp)
      for (int i = 0; i <= (int)log(this.fake_gp - this.real_gp); i++)
        this.fake_gp--;
    else if (this.fake_gp < this.real_gp)
      for (int i = 0; i <= (int)log(this.real_gp - this.fake_gp); i++)
        this.fake_gp++;
        
    if (map.slowtime == true) {
      if (--this.real_tp == 0) {
        map.changeTimeSpeed();
        hud.tp_scale = 0.5;
      }
    }
    
    // change tp in smaller chunks
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
    if (map.slowtime == true) tint(126, min(this.fake_hp, 126), min(this.fake_hp, 126), 126);
    else if (!winner) tint(255, min(this.fake_hp, 255), min(this.fake_hp, 255));
    else tint(255, 255, 255);
    
    imageMode(CENTER);
    image(this.image, 
    (width / 2) + x, 
    (height / 2) + y);
  }

  // stun player
  void setStunTimer(int stun_time) {
    if (this.stun_timer < stun_time && stun_time > 0) this.stun_timer = stun_time;
  }
  
  // make player temporarily invunerable
  void setHPPause(int hp_pause) {
    if (this.hp_pause < hp_pause && hp_pause > 0) this.hp_pause = hp_pause;
  }

  // change the HP and the heart size
  void changeHP(int d_hp) {
    if (this.hp_pause == 0) {
      if (d_hp < 0 && this.real_hp > 0) {
        
        if (this.real_hp > -d_hp) this.real_hp += d_hp;
        else this.real_hp = 0;

        if (-d_hp > this.max_hp) hud.hp_scale = 0;
        else hud.hp_scale = 0.5;

      } else if (d_hp > 0 && this.real_hp < this.max_hp) {

        if (this.real_hp + d_hp < this.max_hp) this.real_hp += d_hp;
        else this.real_hp = this.max_hp;

        hud.hp_scale = 2;
      }

      if (this.real_hp <= 0) {
        this.mode = Mode.DEAD;
        if (map.gravity == false) map.flipGravity();
        if (map.slowtime == true) map.changeTimeSpeed();
        this.setStunTimer(-1);
      }
    }
  }
  
  // change the TP and the image size
  void changeTP(int d_tp) {
    if (d_tp < 0 && this.real_tp > 0) {
      if (this.real_tp > -d_tp) this.real_tp += d_tp;
      else this.real_tp = 0;
  
      if (-d_tp > this.max_tp) hud.tp_scale = 0;
      else hud.tp_scale = 0.5;
  
    } else if (d_tp > 0 && this.real_tp < this.max_tp) {
  
      if (this.real_tp + d_tp < this.max_tp) this.real_tp += d_tp;
      else this.real_tp = this.max_tp;
  
      hud.tp_scale = 2;
    }
  }
    
  // change the GP and the image size
  void changeGP(int d_gp) {
    if (d_gp < 0 && this.real_gp > 0) {
      if (this.real_gp > -d_gp) this.real_gp += d_gp;
      else this.real_gp = 0;
  
      if (-d_gp > this.max_gp) hud.gp_scale = 0;
      else hud.gp_scale = 0.5;
  
    } else if (d_gp > 0 && this.real_gp < this.max_gp) {
  
      if (this.real_gp + d_gp < this.max_gp) this.real_gp += d_gp;
      else this.real_gp = this.max_gp;
  
      hud.gp_scale = 2;
    }
  }
}
