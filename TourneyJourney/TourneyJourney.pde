import ddf.minim.*;

Minim minim;
AudioPlayer audio;

PImage logo;
Map map;
Player player;
Camera camera;
Monster[] monsters;
Monster[] graves;
int num_graves;
Item[] item_list;
Item[] items;
Hud hud;
int level, num_levels;
int wave, num_waves;
boolean started;
boolean winner;

void setup() {
  minim = new Minim(this);
  
  // load the logo
  logo = loadImage("data/hud/logo.png");
  
  // initialize the game
  level = 1;
  num_levels = new File(dataPath("levels/")).list().length;
  wave = 1;
  num_waves = new File(dataPath("levels/" + level + "/monsters/waves/")).list().length;
  started = false;
  winner = false;
  
  // define screen dimensions
  size(1920, 1080);
  
  // create entities
  map = new Map(level);
  player = new Player(level,
    loadImage("data/player/sprites/left.png"),
    loadImage("data/player/sprites/center.png"),
    loadImage("data/player/sprites/right.png"),
    500,
    500,
    500);
  monsters = loadMonsters(level, wave);
  graves = loadGraves(level);
  num_graves = 0;
  item_list = loadItemList();
  items = new Item[monsters.length];
  for (Item item : items) item = null;
  camera = new Camera();
  hud = new Hud();
  frameRate(60);
}

// render stuff on screen
void draw() {

  if (!audio.isPlaying()) {
    audio.rewind();
    audio.play();
  }

   if (started == true) {
    if (map.paused == false) {
      // load new wave or level if necessary
      if (map.num_enemies == 0) {
        if (level <= num_levels) {
          if (wave < num_waves) {
            monsters = loadMonsters(level, ++wave);
          } else if ((level == num_levels && wave == num_waves) ||
          (map.tiles[player.y / map.tiles[0][0].image.height]
          [player.x / map.tiles[0][0].image.width].exit == true &&
          w_pressed == true)) {
            // load the next level once all waves have been cleared and the player enters a door
            if (level++ == num_levels) return;
            player.real_hp += (num_levels - 1) * 200;
            wave = 1;
            num_waves = new File(dataPath("levels/" + level + "/monsters/waves/")).list().length;
            map = new Map(level);
            graves = loadGraves(level);
            num_graves = 0;
            player.x = map.tiles[0][0].image.width * map.tiles[0].length / 2;
            player.y = map.tiles[0][0].image.height * map.tiles.length / 2;
            for (int i = 0; i < items.length; i++)
              items[i] = null;
              monsters = loadMonsters(level, wave);
          }
        } else if (player.mode != Mode.DEAD) {
          winner = true;
        }
      }
      
      // move phase
      player.move();
      for (int i = 0; i < num_graves; i++)
        graves[i].move();
      for (Monster monster : monsters)
        if (monster.real_hp > 0)
          monster.move();
      for (int i = 0; i < items.length; i++)
        if (items[i] != null) items[i].move();
      if (player.mode != Mode.DEAD) camera.move();    
  
      // draw phase
      map.draw();
      for (int i = 0; i < num_graves; i++)
        graves[i].draw();
      for (Monster monster : monsters)
        if (monster.real_hp > 0)
          monster.draw();
      if (player.mode != Mode.DEAD) player.draw();
      
      for (int i = 0; i < items.length; i++)
        if (items[i] != null)
          items[i].draw();
      hud.draw();
      
      // show winning screen if player wins
      if (winner == true) {
        imageMode(CENTER);
        image(hud.win_image, width / 2, height / 2);
      // show losing screen if player loses
      } else if (player.mode == Mode.DEAD) {
        imageMode(CENTER);
        image(hud.lose_image, width / 2, height / 2);
      }
    }
  } else {
    // show title screen
    background(0);
    imageMode(CENTER);
    image(logo, width / 2, height / 5);
    textFont(createFont("Monospaced", 32));
    textAlign(CENTER);
    text("Abandon hope all ye who press [ ENTER ] here\n" +
      "[ WASD / ARROWS ] to Move\n" +
      "[ G ] for Gravity\n" +
      "[ T ] for Time\n" +
      "[ P ] to Pause\n" +
      "[ ESC ] to Exit",
      width / 2, height / 2);
  }
}

void stop() {
  audio.close();
  minim.stop();
  super.stop();
}

//enable fullscreen mode
boolean sketchFullScreen() {
  return true;
}
