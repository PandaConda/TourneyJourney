// items regenerate hp, gp or tp
class Item {
  int x, y;
  PImage image;
  int hp;
  int gp;
  int tp;
  int timer;
  
  public Item(int x, int y, Item item) {
    this.x = x;
    this.y = y;
    this.image = item.image;
    this.hp = item.hp;
    this.tp = item.tp;
    this.gp = item.gp;
    this.timer = item.timer;
  }
  
  public Item(PImage image, int hp, int tp, int gp, int timer) {
    this.image = image;
    this.image.resize(20, 20);
    this.hp = hp;
    this.tp = tp;
    this.gp = gp;
    this.timer = timer;
  }
  
  // render the item
  void draw() {
    // translate map coordinates to screen coordinates
    int x = (width / 2) + this.x - camera.x;
    if (this.x >= map.tiles[0].length * map.tiles[0][0].image.width / 2)
      x -= map.tiles[0].length * map.tiles[0][0].image.width;
    int y = (height / 2) + this.y - camera.y;
    if (this.y >= map.tiles.length * map.tiles[0][0].image.height / 2)
      y -= map.tiles.length * map.tiles[0][0].image.height;
      
    // shift right/down if it brings the item closer to the camera  
    if (abs((width / 2) - x) > abs(x + (map.tiles[0].length * map.tiles[0][0].image.width) - (width / 2)))
      x += map.tiles[0].length * map.tiles[0][0].image.width;
    if (abs((height / 2) - y) > abs(y + (map.tiles.length * map.tiles[0][0].image.height) - (height / 2)))
      y += map.tiles.length * map.tiles[0][0].image.height;

    // make sure the item is on the map before drawing it
    if (x >= -this.image.width / 2 && x <= width + (this.image.width / 2) &&
    y >= -this.image.height / 2 && y <= height + (this.image.height / 2)) {
  
      
      // draw the item
      if (map.slowtime == true) tint(126, 126);
      imageMode(CENTER);
      image(this.image, x, y);
    }
  }
  
  void move() {
  if (!verticalTileCollision(this.x, this.y, this.image.width / 2, this.image.height / 2, 1))
    this.y = (this.y + 1) % (map.tiles.length * map.tiles[0][0].image.height);
  }
}



// load a list of items
Item[] loadItemList() {
  Item[] item_list = {
    new Item(loadImage("data/items/hp.png"), 200, 0, 0, (int)(frameRate * 5)),
    new Item(loadImage("data/items/tp.png"), 0, 200, 0, (int)(frameRate * 5)),
    new Item(loadImage("data/items/gp.png"), 0, 0, 200, (int)(frameRate * 5))
  };
  return item_list;
}
