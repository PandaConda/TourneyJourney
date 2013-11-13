class Camera {
  int x, y;  // camera coordinates
  final int max_x_distance; // max x distance from the player
  final int max_y_distance; // max y distance from the player
  
  // Constructor
  Camera() {
    // initialize camera coordinates to player coordinates
    this.x = player.x;
    this.y = player.y;
    
    this.max_x_distance = (int)(map.tiles[0][0].image.width * 1.5);
    this.max_y_distance = (int)(map.tiles[0][0].image.height * 1.5);
  }
  
  // move the camera if it gets too far away from the player
  void move() {

    // handle x edges
    // left edge
    if (this.x <= this.max_x_distance * 2 &&
      player.x >= (map.tiles[0].length * map.tiles[0][0].image.width) - (this.max_x_distance * 2)) {
      this.x += (map.tiles[0].length * map.tiles[0][0].image.width);
    // right edge
    } else if (this.x >= (map.tiles[0].length * map.tiles[0][0].image.width) - (this.max_x_distance * 2) &&
      player.x <= this.max_x_distance * 2) {
      this.x -= (map.tiles[0].length * map.tiles[0][0].image.width);
    }

    // move x
    if (this.x < player.x - this.max_x_distance) {
      this.x = player.x - this.max_x_distance;
    } else if (this.x > player.x + this.max_x_distance) {
      this.x = player.x + this.max_x_distance;
    } else if (this.x < player.x) {
      this.x += (log(player.x - this.x) / player.xspd) + 1;
    } else if (this.x > player.x) {
      this.x -= (log(this.x - player.x) / player.xspd) + 1;
    }
    this.x = (this.x + (map.tiles[0].length * map.tiles[0][0].image.width)) % (map.tiles[0].length * map.tiles[0][0].image.width);

    // handle y edges
    // top edge
    if (this.y <= this.max_y_distance * 2 &&
      player.y >= (map.tiles.length * map.tiles[0][0].image.height) - (this.max_y_distance * 2)) {
      this.y += (map.tiles.length * map.tiles[0][0].image.height);
    // bottom edge
    } else if (this.y >= (map.tiles.length * map.tiles[0][0].image.height) - (this.max_y_distance * 2) &&
      player.y <= this.max_y_distance * 2) {
      this.y -= (map.tiles.length * map.tiles[0][0].image.height);
    }

    // move y
    if (this.y < player.y - this.max_y_distance) {
      this.y = player.y - this.max_y_distance;
    } else if (this.y > player.y + this.max_y_distance) {
      this.y = player.y + this.max_y_distance;
    } else if (this.y < player.y) {
      this.y += (log(player.y - this.y) / player.yspd) + 1;
    } else if (this.y > player.y) {
      this.y -= (log(this.y - player.y) / player.yspd) + 1;
    }
    this.y = (this.y + (map.tiles.length * map.tiles[0][0].image.height)) % (map.tiles.length * map.tiles[0][0].image.height);
  }
}
