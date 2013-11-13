Map map;
Player player;
Camera camera;
//Monster[] monsters;
//Item[] items;
//Hud hud;

void setup() {
  // define screen dimensions
  size(640, 480);
  
  // create entities
  map = new Map();
  player = new Player();
  camera = new Camera();
  frameRate(60);
  //hud = new Hud();
}

// render stuff on screen
void draw() {
  
  player.move();
  camera.move();
  map.draw();
  player.draw();
  
  //for (monster : monsters) monster.draw();
  //for (item : items) item.draw();
  //hud.draw();
}
