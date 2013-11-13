public class Tile {
  PImage image;
  boolean passable;
  boolean damaging;
  boolean pushable;
  
  // Constructor
  public Tile(PImage image, boolean passable, boolean damaging) {
    this.image = image;
    this.passable = passable;
    this.damaging = damaging;
  }
}
