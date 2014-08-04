class Creature {
  int x, y;          // player coordinates (center)
  PImage left, center, right;
  PImage image;

  Mode mode;
  int real_hp, max_hp;    // hit points
  
  final float base_xspd;
  final float base_yspd;
  float xspd, yspd;           // speed
  final float max_yspd;

  // direction player is facing
  XDir xd;
  YDir yd;

  // player velocity
  int xv, yv;
  
  int jmp;
  
  // Constructor
  Creature(PImage left, PImage center, PImage right, int hp) {
    this.left = left;
    this.center = this.image = center;
    this.right = right;

    this.x = x;
    this.y = y;

    this.xd = XDir.CENTER;
    this.yd = YDir.CENTER;

    this.xv = 0;
    this.yv = 0;

    this.base_xspd = this.xspd = 4;
    this.base_yspd = this.yspd = 4;
    this.max_yspd = 32;

    this.real_hp = hp;
    
    this.jmp = (int)(this.image.height * 1.3);
  }

  // move the creature by updating the coordinates
  void move() {
    for (int i = 0; i < (this.xspd > this.yspd ? (int)this.xspd : (int)this.yspd); i++) {
      if (i < (int)this.xspd)
        if (!horizontalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, this.xv))
          this.x = (this.x + this.xv + (map.tiles[0][0].image.width * map.tiles[0].length)) % (map.tiles[0][0].image.width * map.tiles[0].length);
        else if (this.real_hp > 0 && horizontalTileDamage(this.x, this.y, this.image.width / 2, this.image.height / 2, this.xv))
          this.changeHP(-1);
      if (i < (int)this.yspd)
        if (!verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, this.yv))
          this.y = (this.y + this.yv + (map.tiles[0][0].image.height * map.tiles.length)) % (map.tiles[0][0].image.height * map.tiles.length);
        else if (this.real_hp > 0 && verticalTileDamage(this.x, this.y, this.image.width / 2, this.image.height / 2, this.yv))
          this.changeHP(-1);
    }
  }

  // render the creature on screen
  // overloaded in Player and Enemy
  void draw() {
    
  }

  // change the HP
  // overloaded in Player and Enemy
  void changeHP(int d_hp) {
    
  }
}

