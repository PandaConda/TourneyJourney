// detect tile collisions in response to horizontal movement
boolean horizontalTileCollision(int x, int y, int w, int h, int xv) {
  // this prevents modding negative numbers
  x += map.tiles[0].length * map.tiles[0][0].image.width;
  y += map.tiles.length * map.tiles[0][0].image.height;
  
  // moving left
  if (xv < 0) {
    // top left
    if (map.tiles[((y - h) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x - w + xv) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].passable == false) return true;
    // bottom left
    if (map.tiles[((y + h - 1) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x - w + xv) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].passable == false) return true;
  // moving right
  } else if (xv > 0) {
    // top right
    if (map.tiles[((y - h) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x + w + xv - 1) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].passable == false) return true;
    // bottom right
    if (map.tiles[((y + h - 1) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x + w + xv - 1) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].passable == false) return true;
  }
  // no collisions
  return false;
}

// detect tile collisions in response to vertical movement
boolean verticalTileCollision(int x, int y, int w, int h, int yv) {
  // this prevents modding negative numbers
  x += map.tiles[0].length * map.tiles[0][0].image.width;
  y += map.tiles.length * map.tiles[0][0].image.height;
  
  // moving up
  if (yv < 0) {
    // top left
    if (map.tiles[((y - h + yv) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x - w) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].passable == false) return true;

    // top right
    if (map.tiles[((y - h + yv) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x + w - 1) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].passable == false) return true;

  // moving down
  } else if (yv > 0) {
    // bottom left
    if (map.tiles[((y + h + yv - 1) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x - w) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].passable == false) return true;
      
    // bottom right
    if (map.tiles[((y + h + yv - 1) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x + w - 1) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].passable == false) return true;
  }
  // no collisions
  return false;
}

// detect tile damage in response to horizontal movement
boolean horizontalTileDamage(int x, int y, int w, int h, int xv) {
  // this prevents modding negative numbers
  x += map.tiles[0].length * map.tiles[0][0].image.width;
  y += map.tiles.length * map.tiles[0][0].image.height;
  
  // moving left
  if (xv < 0) {
    // top left
    if (map.tiles[((y - h) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x - w + xv) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].damaging == true) return true;
    // bottom left
    if (map.tiles[((y + h - 1) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x - w + xv) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].damaging == true) return true;
  // moving right
  } else if (xv > 0) {
    // top right
    if (map.tiles[((y - h) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x + w + xv - 1) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].damaging == true) return true;
    // bottom right
    if (map.tiles[((y + h - 1) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x + w + xv - 1) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].damaging == true) return true;
  }
  // no damage
  return false;
}

// detect tile damage in response to vertical movement
boolean verticalTileDamage(int x, int y, int w, int h, int yv) {
  // this prevents modding negative numbers
  x += map.tiles[0].length * map.tiles[0][0].image.width;
  y += map.tiles.length * map.tiles[0][0].image.height;
  
  // moving up
  if (yv < 0) {
    // top left
    if (map.tiles[((y - h + yv) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x - w) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].damaging == true) return true;

    // top right
    if (map.tiles[((y - h + yv) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x + w - 1) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].damaging == true) return true;

  // moving down
  } else if (yv > 0) {
    // bottom left
    if (map.tiles[((y + h + yv - 1) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x - w) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].damaging == true) return true;
      
    // bottom right
    if (map.tiles[((y + h + yv - 1) % (map.tiles.length * map.tiles[0][0].image.height)) / map.tiles[0][0].image.height]
      [((x + w - 1) % (map.tiles[0].length * map.tiles[0][0].image.width)) / map.tiles[0][0].image.width].damaging == true) return true;
  }
  // no collisions
  return false;
}
