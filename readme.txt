Tourney Journey ReadMe

Run in processing.

Currently only level 1 works. I plan on changing this before the deadline.
Right now it's a demo.

To modify the levels, go to data/levels/1/

The monsters folder contains 2 files:

list.dat: contains the number of types of monsters on the level on the
first line, followed by 1 type of monster on each line.
Each monster type specifies the name of the monster
(must match up with a .png in data/monsters), it's HP, it's range, and
whether or not it can fly (not implemented).

map.dat: contains the number of monsters appearing on the map on the first
row, followed by data on each individual monster. The first
monster appearing in list.dat corresponds to a, the second to b, and
so on. This is followed by the x and y coordinates for each monster.

The tiles folder uses a similar system:

list.dat: contains the name of the tile image (located in data/tiles/*.png),
whether it is passable (non-solid), and whether it damages the player. This
is listed for each type of tile on the map. The number on the first row is
the number of types of tiles on the map.

map.dat: the first 2 numbers specify the width and height of the map in
terms of number of tiles. The first tile in tiles.dat corresponds to a,
the second to b, and so on. Some sample maps are contained in the test_maps
folder. These may not work on full 1920x1080 mode. In this case try changing
it to 640x480 inside TourneyJourney.pde. The one currently stored as the map being loaded works.

Controls:
  wasd/arrow keys to move
  g/G to change gravity
  t/T to change time
  p/P to pause
  ESC to quit

Bugs/todo:
  Enemies teleport. I plan to fix this by making bigger levels. ftw.
  No game over screen when dying. Not implemented yet.
  Currently only 1 level supported. Need to implement level progression.
  Also need to implement menus.
  Add music if I have time/can be bothered.
  Add credits for assets I found on the interwebs.
  Clean up code/data (don't judge)
