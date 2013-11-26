public class Tile {
  PImage image;
  boolean passable;
  boolean damaging;
  
  // Constructor
  public Tile(PImage image, boolean passable, boolean damaging) {
    this.image = image;
    this.image.resize(40, 40);
    this.passable = passable;
    this.damaging = damaging;
  }
}
