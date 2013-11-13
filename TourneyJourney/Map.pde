class Map {
  Tile[][] tiles;
  boolean gravity;
  
  // Constructor
  Map() {
    loadTiles(1);
    gravity = false;
  }
  
  // load the tiles from a file into an array
  void loadTiles(int level) {

    String[] line = null;
    // start reading tile data
    BufferedReader tile_file_reader =
      createReader("data/levels/" + level + "/tiles.dat");

    // get the number of tiles for this map
    Tile[] tile_types = null;
    try {tile_types = new Tile[parseInt(tile_file_reader.readLine())];}
    catch (IOException e) {e.printStackTrace();}

    // parse the tile data for each tile
    for (int i = 0; i < tile_types.length; i++) {
      try {line = split(tile_file_reader.readLine(), ", ");}
      catch (IOException e) {e.printStackTrace();}
      tile_types[i] = new Tile(loadImage("data/tiles/" + line[0] + "/tile.png"), 
        parseBoolean(line[1]), parseBoolean(line[2]));
    }

    // load the tile configuration from a file
    BufferedReader map_file_reader =
      createReader("data/levels/" + level + "/map.dat");

  
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
  }
  
  // render the map on the screen
  void draw() {
    imageMode(CORNERS);
    
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
        image(tiles[(i + map.tiles.length) % map.tiles.length]
          [(j + map.tiles[0].length) % map.tiles[0].length].image,
          left + (j * t_width),
          top + (i * t_height));
      }
    }
  }
  
  // turn gravity on or off
  void flipGravity() {
    this.gravity = !this.gravity;
    player.yspd = player.base_yspd;
    if (player.yd == YDir.DOWN) {
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
}
