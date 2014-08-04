class Monster extends Creature {
  int dst_x, dst_y;
  int range;
  boolean flying;
  
  public Monster(Monster monster) {
    super(monster.left, monster.center, monster.right, monster.real_hp);
    this.max_hp = this.real_hp;
    this.range = monster.range;
    this.flying = monster.flying;
    this.xspd = 2;
    this.yspd = 2;
  }
  
  public Monster(PImage left, PImage center, PImage right, int hp, int range, boolean flying) {
    super(left, center, right, hp);
    
    this.range = range;
    this.flying = flying;
    int rnd = (int)random(2);
    // either go left
    if (rnd == 0) {
      this.dst_x = this.x - map.tiles[0][0].image.width;
      this.dst_y = this.y;
    // or go right
    } else if (rnd == 1) {
      this.dst_x = this.x + map.tiles[0][0].image.width;
      this.dst_y = this.y;
    }
  }
  
  // TODO
  // determine if an unobstructed line can be drawn between the monster
  // and a point. Rarely happens so low priority.
  boolean seek(int x, int y) {
    return true;
  }
  
  // update the monster's coordinates
  void move() {
    // if the player is within the monster's range then follow it
    if (this.real_hp > 0) {
      if (player.real_hp > 0 &&
      sqrt(pow(this.x - player.x, 2) + pow(this.y - player.y, 2)) < this.range &&
      sqrt(pow(this.x - player.x, 2) + pow(this.y - player.y, 2)) > min(this.image.width, player.image.width) &&
      verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1) &&
      this.seek(player.x, player.y)) {
        this.dst_x = player.x;
        this.dst_y = player.y;
      // otherwize if currently moving left
      } else if (this.xd == XDir.LEFT) {
        // if there's no collision
        if (!horizontalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, -1)) {
          // if there's a drop
          if (this.yd == YDir.CENTER && !verticalTileCollision(this.x - map.tiles[0][0].image.width, this.y, this.image.width / 2, this.image.height / 2, 1)) {
            int rnd = (int)random(2);
            // either turn around
            if (rnd == 0) {
              this.dst_x = this.x + map.tiles[0][0].image.width;
              this.dst_y = this.y;
            // or jump
            } else if (rnd == 1) {
              this.dst_x = this.x - map.tiles[0][0].image.width;
              if (!verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, -1))
                this.dst_y = this.y - map.tiles[0][0].image.height;
            }
          // keep walking normally
          } else {
            this.dst_x = this.x - map.tiles[0][0].image.width;
            this.dst_y = this.y;
          }
        // otherwize jump if there's a step
        } else if (!horizontalTileCollision(this.x, this.y - map.tiles[0][0].image.height, this.image.width / 2, this.image.height / 2, -1)) {
          this.dst_x = this.x - map.tiles[0][0].image.width;
          this.dst_y = this.y - map.tiles[0][0].image.height;
        // otherwize turn around
        } else {
          this.dst_x = this.x + map.tiles[0][0].image.width;
          this.dst_y = this.y;
        }
      //otherwize if currently moving right
      } else if (this.xd == XDir.RIGHT) {
        // if there's no collision
        if (!horizontalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
          // if there's a drop
          if (this.yd == YDir.CENTER && !verticalTileCollision(this.x + map.tiles[0][0].image.width, this.y, this.image.width / 2, this.image.height / 2, 1)) {
            int rnd = (int)random(2);
            // either turn around
            if (rnd == 0) {
              this.dst_x = this.x - map.tiles[0][0].image.width;
              this.dst_y = this.y;
            // or jump
            } else if (rnd == 1) {
              this.dst_x = this.x + map.tiles[0][0].image.width;
              if (!verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, -1))
                this.dst_y = this.y - map.tiles[0][0].image.height;
            }
          // keep walking normally
          } else {
            this.dst_x = this.x + map.tiles[0][0].image.width;
            this.dst_y = this.y;
          }
        // otherwize jump if there's a step
        } else if (!horizontalTileCollision(this.x, this.y - map.tiles[0][0].image.height, this.image.width / 2, this.image.height / 2, 1)) {
          this.dst_x = this.x + map.tiles[0][0].image.width;
          this.dst_y = this.y - map.tiles[0][0].image.height;
        // otherwize turn around
        } else {
          this.dst_x = this.x - map.tiles[0][0].image.width;
          this.dst_y = this.y;
        }
      // if direction is perfectly up or down move randomly
      } else if (this.yd == YDir.UP) {
        int rnd = (int)random(2);
        if (rnd == 0) this.dst_x = this.x - map.tiles[0][0].image.width;
        else if (rnd == 1) this.dst_x = this.x + map.tiles[0][0].image.width;
      }
      // determine x direction based on destination
      if ((width / 2) + this.x - camera.x < (width / 2) + this.dst_x - camera.x) {
        this.xd = XDir.RIGHT;
        this.image = this.right;
        this.xv = 1;
      } else if ((width / 2) + this.x - camera.x > (width / 2) + this.dst_x - camera.x) {
        this.xd = XDir.LEFT;
        this.image = this.left;
        this.xv = -1;
      } else {
        this.xv = 0;
        this.xd = XDir.CENTER;
      }
      
      // make sure the monster doesn't get stuck in the player
      if (this.x == player.x && this.y == player.y) {
        int rnd = (int)random(2);
        if (rnd == 0) {
          this.dst_x = this.x - 1;
          this.dst_y = this.y - 1;
        } else if (rnd == 1) {
          this.dst_x = this.x + 1;
          this.dst_y = this.y - 1;
        }
      }
    }
    
    // check for monster collisions
    for (Monster monster : monsters) {
      if (this.real_hp > 0 &&
      monster.real_hp > 0 &&
      monster != this &&
      abs((this.x + this.xv) - monster.x) < min(this.image.width, monster.image.width) &&
      abs((this.y + this.yv) - monster.y) < min(this.image.height, monster.image.height)) {
        if (this.yd == YDir.DOWN &&
        (this.y + (this.image.height / 2) + this.yv) - (monster.y - (monster.image.height / 2)) < this.yspd) {
          this.yd = YDir.UP;
          this.yv = -1;
        } else if (this.yd == YDir.UP &&
        (monster.y + (monster.image.height / 2) - (this.y - (this.image.height / 2) + this.yv) < this.yspd)) {
          this.yd = YDir.DOWN;
          this.yv = 1;
        } else if (this.dst_x < this.x) {
          this.xd = XDir.RIGHT;
          this.image = this.right;
          this.xv = 1;
          this.dst_x = this.x + max(this.image.width, monster.image.width);
          monster.xd = XDir.LEFT;
          this.image = this.left;
          monster.xv = -1;
          monster.dst_x = this.x - max(this.image.width, monster.image.width);
        } else if (this.dst_x > this.x) {
          this.xd = XDir.LEFT;
          this.image = this.left;
          this.xv = -1;
          this.dst_x = dst_x - max(this.image.width, monster.image.width);
          monster.xd = XDir.RIGHT;
          this.image = this.left;
          monster.xv = 1;
          monster.dst_x = dst_x + max(this.image.width, monster.image.width);
        }
        super.move();
        return;
      }
    }
    
    // account for gravity
    // monster is jumping upwards
    if (this.yd == YDir.UP) {
      if (verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, -1)) {
        this.xd = XDir.CENTER;
        this.xv = 0;
        this.yd = YDir.DOWN;
        this.yv = 1;
        if (this.yspd > 4) this.yspd = 4;
      // if the monster reaches the maximum jumping height
      } else if (this.yspd < 1) {
        this.yd = YDir.DOWN;
        this.yv = 1;
      // if the monster is free to keep moving upwards normally
      } else {
//        this.yspd -= this.yspd / (this.jmp / 6) * (this.image.height / map.tiles[0][0].image.height); // this version reduces jump height for bigger monsters, but increases it for smaller monsters
          this.yspd -= this.yspd / (this.jmp / 6);
      }
    // the monster is standing on the ground
    } else if (this.yd == YDir.CENTER) {
      // if there's no ground below the monster make it fall
      if (!verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
        this.yd = YDir.DOWN;
        this.yv = 1;
        this.yspd = 4;
      } else if (this.real_hp > 0 && map.gravity == true && verticalTileDamage(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
        this.changeHP(-1);
      }
    // the monster is falling downwards
    } else if (this.yd == YDir.DOWN) {
      // if the monster lands
      if (verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1)) {
        if (this.real_hp <= 0) {
          this.xd = XDir.CENTER;
          this.xv = 0;
        }
        // if the monster was falling at terminal velocity then stun him
        if (this.yspd == this.max_yspd) {
          this.changeHP(-500);
          this.yd = YDir.CENTER;
          this.yv = 0;
          this.yspd = 4;
        // otherwize the monster hits the ground normally
        } else {
          this.yd = YDir.CENTER;
          this.yv = 0;
          this.yspd = 4;
          if (this.real_hp > 0 && verticalTileDamage(this.x, this.y, this.image.width / 2, this.image.height / 2, 1))
            this.changeHP(-1);
        }
      // if the monster does not hit the ground then keep falling
      } else {
        if (this.yspd < this.max_yspd) this.yspd += 0.5;
        if (this.yspd > this.max_yspd) this.yspd = this.max_yspd;
      }
    }
    
    // if target is above monster then jump
    if (this.real_hp > 0 &&
    verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1) && (height / 2) + this.y - camera.y > (height / 2) + this.dst_y - camera.y) {
      this.yd = YDir.UP;
      this.yv = -1;
      this.yspd = this.jmp / 6; 
    }
    
    if (map.slowtime == true)
      this.xspd /= 2;
    super.move();
    if (map.slowtime == true)
      this.xspd *= 2;
  }
  
  void draw() {
    // translate map coordinates to screen coordinates
    int x = (width / 2) + this.x - camera.x;
    if (this.x >= map.tiles[0].length * map.tiles[0][0].image.width / 2)
      x -= map.tiles[0].length * map.tiles[0][0].image.width;
    int y = (height / 2) + this.y - camera.y;
    if (this.y >= map.tiles.length * map.tiles[0][0].image.height / 2)
      y -= map.tiles.length * map.tiles[0][0].image.height;

    // shift right/down if it brings the monster closer to the player  
    if ((width / 2) - x > x + (map.tiles[0].length * map.tiles[0][0].image.width) - (width / 2))
      x += map.tiles[0].length * map.tiles[0][0].image.width;
    if ((height / 2) - y > y + (map.tiles.length * map.tiles[0][0].image.height) - (height / 2))
      y += map.tiles.length * map.tiles[0][0].image.height;

    // make sure the enemy is on the map before drawing it
    if (x >= -this.image.width / 2 && x <= width + (this.image.width / 2) &&
    y >= -this.image.height / 2 && y <= height + (this.image.height / 2)) {  
      // draw the monster
      if (map.slowtime == true) tint(126, 126);
      imageMode(CENTER);
      image(this.image, x, y);
      
      if (this.real_hp > 0) {
        rectMode(CENTER);
        stroke(0, 0, 0, 255);
        fill(255, 0, 0, 255);
        rect(x, y - (this.image.height / 2) - 15, (int)(max(this.left.width, this.center.width, this.right.width) * ((float)this.real_hp / (float)this.max_hp)), 10, 18, 18, 18, 18);
      }
    }
  }
  
  void changeHP(int d_hp) {
    this.real_hp += d_hp;
    if (this.real_hp <= 0) {
      player.kp++;
      map.num_enemies--;
      hud.kp_scale = 2.0;
      this.dst_x = this.x;
      this.xd = XDir.CENTER;
      this.xv = 0;
      this.dst_y = this.y;
      this.image = loadImage("data/monsters/grave.png");
      this.image.resize(
        max(this.center.width, this.center.height),
        max(this.center.width, this.center.height));
      
      graves[num_graves++] = this;
              
      int rnd_num = (int)random(item_list.length + 1);
      if (rnd_num != item_list.length) {
        for (int i = 0; i < items.length; i++) {
          if (items[i] == null) {
            items[i] = new Item(this.x, this.y, item_list[rnd_num]);
            break;
          }
        }
      }
    }
  }
}

Monster[] loadMonsters(int level, int wave) {
  BufferedReader monster_list_reader = createReader("data/levels/" + level + "/monsters/list.dat");
  
  Monster[] monster_list = null;
  
  try {monster_list = new Monster[parseInt(monster_list_reader.readLine())];}
  catch (IOException e) {e.printStackTrace();}
  
  String[] line = null;
  
  // parse the tile data for each tile
  for (int i = 0; i < monster_list.length; i++) {
    try {line = split(monster_list_reader.readLine(), ", ");}
    catch (IOException e) {e.printStackTrace();}
    monster_list[i] = new Monster(
      loadImage("data/monsters/" + line[0] + "/left.png"),
      loadImage("data/monsters/" + line[0] + "/center.png"),
      loadImage("data/monsters/" + line[0] + "/right.png"),
      parseInt(line[1]), parseInt(line[2]), parseBoolean(line[3]));
  }
    
  // load the tile configuration from a file
  BufferedReader monster_map_reader =
    createReader("data/levels/" + level + "/monsters/waves/" + wave + ".dat");
  
  Monster[] monsters = null;
  // get the number of monsters
  try {monsters = new Monster[parseInt(monster_map_reader.readLine())];}
  catch (IOException e) {e.printStackTrace();}
  map.num_enemies = monsters.length;
    
  // load the monster data from the file
  for (int i = 0; i < monsters.length; i++) {
    try {line = split(monster_map_reader.readLine(), ", ");}
    catch (IOException e) {e.printStackTrace();}
    monsters[i] = new Monster(monster_list[(int)line[0].charAt(0) - 'a']);
    monsters[i].x = monsters[i].dst_x = parseInt(line[1]);
    monsters[i].y = monsters[i].dst_y = parseInt(line[2]);
  }
  return monsters;
}

// create an array to hold the graves
Monster[] loadGraves(int level) {
  int num_graves = 0;
  String[] waves = new File(dataPath("levels/" + level + "/monsters/waves/")).list();
  for (String wave : waves) {
      BufferedReader wave_reader = createReader(dataPath("levels/" + level + "/monsters/waves/" + wave));
      try {num_graves += parseInt(wave_reader.readLine());}
      catch (IOException e) {e.printStackTrace();}
  }
  return new Monster[num_graves];
}
