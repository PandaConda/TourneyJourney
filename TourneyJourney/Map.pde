class Map {
  PImage background;
  Tile[][] tiles;
  boolean gravity;
  boolean slowtime;
  boolean paused;
  int num_enemies;
  
  // Constructor
  Map(int level) {
    this.background = this.loadBackgroundAndAudio(level);
    this.tiles = this.loadTiles(level);
    this.gravity = true;
    this.slowtime = false;
    this.paused = false;
  }
  
  PImage loadBackgroundAndAudio(int level) {
    PImage background = null;
    BufferedReader file_reader = createReader("data/levels/" + level + "/properties.dat");
    try {background = loadImage("data/backgrounds/" + file_reader.readLine());}
    catch (IOException e) {e.printStackTrace();}
    background.resize(width, height);

    if (audio != null) audio.pause();
    try {audio = minim.loadFile("audio/music/" + file_reader.readLine());}
    catch (IOException e) {e.printStackTrace();}
    audio.play();
    return background;
  }
  
  // load the tiles from a file into an array
  Tile[][] loadTiles(int level) {

    String[] line = null;
    // start reading tile data
    BufferedReader tile_file_reader =
      createReader("data/levels/" + level + "/tiles/list.dat");

    // get the number of tiles for this map
    Tile[] tile_types = null;
    try {tile_types = new Tile[parseInt(tile_file_reader.readLine())];}
    catch (IOException e) {e.printStackTrace();}

    // parse the tile data for each tile
    for (int i = 0; i < tile_types.length; i++) {
      try {line = split(tile_file_reader.readLine(), ", ");}
      catch (IOException e) {e.printStackTrace();}
      tile_types[i] = new Tile(loadImage("data/tiles/" + line[0] + ".png"), 
        parseBoolean(line[1]), parseBoolean(line[2]), parseBoolean(line[3]));
    }

    // load the tile configuration from a file
    BufferedReader map_file_reader =
      createReader("data/levels/" + level + "/tiles/map.dat");

  
    // get the dimensions of the map
    try {line = split(map_file_reader.readLine(), ' ');}
    catch (IOException e) {e.printStackTrace();}
    this.tiles = new Tile[parseInt(line[1])][parseInt(line[0])];
    
    // load the tile data from the file
    for (int i = 0; i < tiles.length; i++) {
      String map_data_row = null;
      try {map_data_row = map_file_reader.readLine();}
      catch (IOException e) {e.printStackTrace();}
      for (int j = 0; j < tiles[i].length; j++) {
        tiles[i][j] = tile_types[(int)(map_data_row.charAt(j) - 'a')];
      }
    }
    return tiles;
  }
  
  // render the map on the screen
  void draw() {
    imageMode(CORNERS);
    if (slowtime == true)
      tint(255, 15);
    image(background, 0, 0);
    
    // avoid having to recompute/rewrite these every time
    final int left = (width / 2) - camera.x;
    final int top = (height / 2) - camera.y;
    final int t_width = map.tiles[0][0].image.width;
    final int t_height = map.tiles[0][0].image.height;
    
    // render tilemap
    for (int i = ((camera.y - (height / 2)) / t_height) - 1;
    i <= (camera.y + (height / 2)) / t_height; i++) {
      for (int j = ((camera.x - (width / 2)) / t_width) - 1;
      j <= (camera.x + (width / 2)) / t_width; j++) {
        if (!(this.tiles[(i + map.tiles.length) % map.tiles.length][(j + map.tiles[0].length) % map.tiles[0].length].exit == true &&
        !(wave == num_waves && this.num_enemies == 0))) {
          if (this.slowtime == true) {
            if (tiles[(i + map.tiles.length) % map.tiles.length]
            [(j + map.tiles[0].length) % map.tiles[0].length].passable == true)
              tint(255, 15);
            else
              tint(126, 126);
          }
            
          image(tiles[(i + map.tiles.length) % map.tiles.length]
            [(j + map.tiles[0].length) % map.tiles[0].length].image,
            left + (j * t_width),
            top + (i * t_height));
        }
      }
    }
  }
  
  // turn gravity on or off
  void flipGravity() {
    if (started == true && !(this.gravity == true && player.real_gp == 0) && !(player.mode == Mode.DEAD && this.gravity == true)) {
      this.gravity = !this.gravity;
      player.yspd = player.base_yspd;
      if (player.yd != YDir.CENTER) {
        if (w_pressed && !s_pressed) {
          player.yd = YDir.UP;
          player.yv = -1;
        } else if (s_pressed && !w_pressed) {
          player.yd = YDir.DOWN;
          player.yv = 1;
        } else {
          player.yd = YDir.CENTER;
          player.yv = 0;
        }
      }
    }
    if (this.gravity == false)
      hud.gp_scale = 0.5;
  }
  
  // change the rate at which time passes
  void changeTimeSpeed() {
    if (started == true && !(this.slowtime == false && player.real_tp == 0) && !(player.mode == Mode.DEAD && this.slowtime == false)) {
      this.slowtime = !this.slowtime;
      if (slowtime) {
        loadPixels();
        for (int i = 0; i < width * height; i++)
          pixels[i] = color(0, 0, 0, 255);
        updatePixels();
      }
    }
  }
}
