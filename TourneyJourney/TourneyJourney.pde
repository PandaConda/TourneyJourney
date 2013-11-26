Map map;
Player player;
Camera camera;
//Monster[] monsters;
//Item[] items;
Hud hud;

void setup() {
  // define screen dimensions
  size(1920, 1080);
  
  // create entities
  map = new Map();
  player = new Player();   
  camera = new Camera();
  hud = new Hud();
  frameRate(60);
}

// render stuff on screen
void draw() {
  if (map.paused == false) {
    player.move();
    camera.move();
    map.draw();
    player.draw();
    
    //for (monster : monsters) monster.draw();
    //for (item : items) item.draw();
    hud.draw();
  }
}

//enable fullscreen mode
boolean sketchFullScreen() {
  return true;
}
