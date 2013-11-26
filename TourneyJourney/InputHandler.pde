private static boolean w_pressed = false;
private static boolean a_pressed = false;
private static boolean s_pressed = false;
private static boolean d_pressed = false;
private static boolean t_pressed = false;

void keyPressed() {
  if (player.stun_timer == 0 && (map.paused == false || key == 'p' || key == 'P')) {
    switch (key) {
      // moving
      case 'w': case 'W': pressUp(); return;
      case 'a': case 'A': pressLeft(); return;
      case 's': case 'S': pressDown(); return;
      case 'd': case 'D': pressRight(); return;
      case CODED: // arrow keys
        switch(keyCode) {
          case UP: pressUp(); return;
          case LEFT: pressLeft(); return;
          case DOWN: pressDown(); return;
          case RIGHT: pressRight(); return;
          default: return;
        }
      case 'g': case 'G': map.flipGravity(); return;
      case 't': case 'T': map.changeTimeSpeed(); return;
      case 'p': case 'P': map.paused = !map.paused; return;
    }
  }
}

void keyReleased() {
  if (player.stun_timer == 0) {
    switch (key) {
      // moving
      case 'w': case 'W': releaseUp(); return;
      case 'a': case 'A': releaseLeft(); return;
      case 's': case 'S': releaseDown(); return;
      case 'd': case 'D': releaseRight(); return;
      case CODED: // arrow keys
        switch(keyCode) {
          case UP: releaseUp(); return;
          case LEFT: releaseLeft(); return;
          case DOWN: releaseDown(); return;
          case RIGHT: releaseRight(); return;
          default: return;
        }
      case 'q': case 'Q': return; // TODO switch to left equip
      case 'e': case 'E': return; // TODO switch to right equip
      case ' ': return; // TODO use current equip
    }
  }
}

private void pressUp() {
  w_pressed = true;
  if (!(map.gravity == true && !verticalTileCollision(player.x, player.y, player.w / 2, player.h / 2, 1))) {
    player.yd = YDir.UP;
    player.yv = -1;
    if (map.gravity == true) player.yspd = player.jmp / 6;
  }
}

private void releaseUp() {
  w_pressed = false;
  if (map.gravity == false) {
    if (s_pressed) player.yv = 1;
    else player.yv = 0;
  }
}

private void pressLeft() {
  a_pressed = true;
  if (player.walljump == true) {
    player.xd = XDir.LEFT;
    player.xv = -1;
  }
}

private void releaseLeft() {
  a_pressed = false;
  if (player.walljump == true) {
    if (d_pressed) player.xv = 1;
    else player.xv = 0;
  }
}

private void pressDown() {
  s_pressed = true;
  if (!(map.gravity == true && player.yd != YDir.CENTER)) {  
    player.yd = YDir.DOWN;
    player.yv = 1;
  } else if (map.gravity == true) {
    player.mode = Mode.DUCKING;
  }
}

private void releaseDown() {
  s_pressed = false;
  if (map.gravity == false) {
    if (w_pressed) player.yv = -1;
    else player.yv = 0;
  } else {
    player.mode = Mode.STANDING;
  }
}

private void pressRight() {
  d_pressed = true;
  if (player.walljump == true) {
    player.xd = XDir.RIGHT;
    player.xv = 1;
  }
}

private void releaseRight() {
  d_pressed = false;
  if (player.walljump == true) {
    if (a_pressed) player.xv = -1;
    else player.xv = 0;
  }
}

