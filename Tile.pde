public class Tile {
  PImage image;
  boolean passable;
  boolean damaging;
  boolean exit;
  
  // Constructor
  public Tile(PImage image, boolean passable, boolean damaging, boolean exit) {
    this.image = image;
    this.image.resize(40, 40);
    this.passable = passable;
    this.damaging = damaging;
    this.exit = exit;
  }
}
