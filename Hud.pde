class Hud {
  PImage hp_image;    // health points
  PImage kp_image;    // kill points
  PImage tp_image;    // slowtime points
  PImage gp_image;    // gravity points
  PImage win_image;   // image displayed when player wins
  PImage lose_image;  // image displayed when player loses
  
  // factos which icons are scaled by
  float hp_scale;
  float kp_scale;
  float tp_scale;
  float gp_scale;
  
  public Hud() {
    // load images and resize them. Also initialize icon scale factors to 1
    this.hp_image = loadImage("data/hud/hp.png");
    this.hp_image.resize(40, 40);
    this.hp_scale = 1;
    this.kp_image = loadImage("data/hud/kp.png");
    this.kp_image.resize(40, 40);
    this.kp_scale = 1;
    this.tp_image = loadImage("data/hud/tp.png");
    this.tp_image.resize(40, 40);
    this.tp_scale = 1;
    this.gp_image = loadImage("data/hud/gp.png");
    this.gp_image.resize(40, 40);
    this.gp_scale = 1;
    this.win_image = loadImage("data/hud/win.png");
    this.win_image.resize(width / 2, (width / 2) * (this.win_image.height / this.win_image.width));
    this.lose_image = loadImage("data/hud/lose.png");
    this.lose_image.resize(width / 2, (width / 2) * (this.lose_image.height / this.lose_image.width));
  }
  
  // render the HUD
  void draw() {
    if (map.slowtime == true) tint(255, 255);
    
    // draw transparent boxes
    rectMode(CORNER);
    stroke(0, 0, 0, 193);
    fill(63, 63, 63, 193);
    
    rect(width - 201, height - 41, width, height, 18, 0, 0, 0); // bottom right
    rect(-1, height - 41, 200, height,            0, 18, 0, 0); // bottom left
    rect(-1, -1, 200, 40,                         0, 0, 18, 0); // top left
    rect(width - 201, -1, width, 40,              0, 0, 0, 18); // top right
    
    rect(199, -1, width - 400, 29);          // top
    rect(199, height - 28, width - 400, 29); // bottom
    
    // draw HP overlay
    imageMode(CENTER);
    rectMode(CENTER);
    textSize(18);
    textAlign(CENTER, CENTER);
    
    if (abs(this.hp_scale - 1) < 0.01) this.hp_scale = 1;
    if (this.hp_scale < 1) this.hp_scale += 0.01;
    else if (this.hp_scale > 1) this.hp_scale -= 0.01;
    
    image(this.hp_image, 20, 20, (int)(this.hp_image.width * this.hp_scale), (this.hp_image.height * this.hp_scale));
    fill(255, (int)(255 * ((float)(player.fake_hp + 1) / (float)(player.max_hp + 1))), 0);
    text(player.fake_hp / 1000, 60, 16);
    text(player.fake_hp / 100 % 10, 100, 16);
    text(player.fake_hp / 10 % 10, 140, 16);
    text(player.fake_hp % 10, 180, 16);
    
    // draw killcount overlay
    if (abs(this.kp_scale - 1) < 0.01) this.kp_scale = 1;
    if (this.kp_scale < 1) this.kp_scale += 0.01;
    else if (this.kp_scale > 1) this.kp_scale -= 0.01;
    
    image(this.kp_image, width - 20, 20, this.kp_image.width * this.kp_scale, this.kp_image.height * this.kp_scale);
    fill(255, (int)(255 * ((float)(player.kp + 1) / (float)(9999))), 0);
    text(player.kp / 1000, width - 180, 16);
    text(player.kp / 100 % 10, width - 140, 16);
    text(player.kp / 10 % 10, width - 100, 16);
    text(player.kp % 10, width - 60, 16);
    
    // draw time meter overlay
    if (abs(this.tp_scale - 1) < 0.01) this.tp_scale = 1;
    if (this.tp_scale < 1) this.tp_scale += 0.01;
    else if (this.tp_scale > 1) this.tp_scale -= 0.01;
    
    image(this.tp_image, 20, height - 20, this.tp_image.width * tp_scale, this.tp_image.height * tp_scale);
    fill(255, (int)(255 * ((float)(player.fake_tp + 1) / (float)(player.max_tp + 1))), 0);
    text(player.fake_tp / 1000, 60, height - 20);
    text(player.fake_tp / 100 % 10, 100, height - 20);
    text(player.fake_tp / 10 % 10, 140, height - 20);
    text(player.fake_tp % 10, 180, height - 20);
    
    // draw gravity meter overlay
    if (abs(this.gp_scale - 1) < 0.01) this.gp_scale = 1;
    if (this.gp_scale < 1) this.gp_scale += 0.01;
    else if (this.gp_scale > 1) this.gp_scale -= 0.01;
    
    image(this.gp_image, width - 20, height - 20, this.gp_image.width * gp_scale, this.gp_image.height * gp_scale);
    fill(255, (int)(255 * ((float)(player.fake_gp + 1) / (float)(player.max_gp + 1))), 0);
    text(player.fake_gp / 1000, width - 180, height - 20);
    text(player.fake_gp / 100 % 10, width - 140, height - 20);
    text(player.fake_gp / 10 % 10, width - 100, height - 20);
    text(player.fake_gp % 10, width - 60, height - 20);
  }
}
