public class IsaacObstacle {
  
  float x, y;
  float w, h;
  float spriteY;                                                                        //y position of the sprite while it's falling
  float shadowW;                                                                        //shadow width
  boolean traversible;                                                                  //whether it can be flown over
  boolean destructible;                                                                 //whether it can be destroyed with bombs
  boolean falling;                                                                      //whether it's currently falling
  float fallingTime, fallingTimer;                                                      //duration and timer for the fall
  color clr = #000000;
  SoundFile fallingSound;
  int type;                                                                             //0 = hole; 1 = block; 2 = anvil
  
  public IsaacObstacle(float x, float y, float w, float h, int type) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.type = type;
    switch(type) {
      case 0:
        this.clr = #000000;
        this.traversible = true;
        break;
      case 1:
        this.clr = #FFFFFF;
        this.traversible = false;
        this.destructible = true;
        break;
      case 2:
        this.clr = #AAAAAA;
        this.traversible = false;
        this.destructible = true;
        this.falling = true;
        this.fallingTime = 100;
        this.fallingTimer = this.fallingTime;
        this.shadowW = this.w*1.5;
        try {
          fallingSound = sfx.get(6);
        } catch(Exception e) {
          println(e + "Can't set obstacle falling sound.");
        }
        break;
      default:
    }
  }
  
  void display() {
    pushStyle();
    fill(#000000, 70);
    noStroke();
    circle(x + w*.5, y + h*.5, fallingTimer > 0 ? ((fallingTime-fallingTimer)/fallingTime)*shadowW : shadowW);
    stroke(2);
    fill(clr);
    spriteY = falling ? y - (fallingTimer/fallingTime)*height : y;
    rect(x, spriteY, w, h);
    popStyle();
  }
  
  void update() {
    if(type == 2) {
      if(falling && fallingTimer-- <= 0) {
        try {
          fallingSound.stop();
          fallingSound.removeFromCache();
          fallingSound.play();
        } catch(Exception e) {
          println(e + "Can't play obstacle falling sound.");
        }
        falling = false;
        if(intersects(is.player)) is.player.hit(1);
        for(int i = 0; i < is.getCurrentMap().getCurrentRoom().enemyList.size(); i++) {
          if(intersects(is.getCurrentMap().getCurrentRoom().enemyList.get(i))) {
            is.getCurrentMap().getCurrentRoom().enemyList.get(i).damage(200);
          }
          if(i >= 0 && is.getCurrentMap().getCurrentRoom().enemyList.get(i).update()) {
            i--;
          }
        }
      } else if(fallingTimer <= 0 && fallingTimer-- >= -50) {
        is.getCurrentMap().getCurrentRoom().setOffSet(random(-5, 5), random(-5, 5));
      } else {
        is.getCurrentMap().getCurrentRoom().setOffSet(0, 0);
      }
    }
    if(!(is.player.getFlying() && traversible)) {
      if(intersectsR(is.player) && is.player.dx < 0) {
        is.player.setX(x + w + is.player.getR());
      }
      if(intersectsL(is.player) && is.player.dx > 0) {
        is.player.setX(x - is.player.getR());
      }
      if(intersectsD(is.player) && is.player.dy < 0) {
        is.player.setY(y + h + is.player.getR());
      }
      if(intersectsU(is.player) && is.player.dy > 0) {
        is.player.setY(y - is.player.getR());
      }
    }
  }
  
  boolean intersects(IsaacPlayer player) {
    return x < player.x - player.r && x + w > player.x - player.r && y < player.y + player.r && y + h > player.y - player.r;
  }
  
  boolean intersects(IsaacEnemy enemy) {
    return enemy.h == 0 ? x < enemy.x - enemy.r && x + w > enemy.x - enemy.r && y < enemy.y + enemy.r && y + h > enemy.y - enemy.r :
                          x < enemy.x - enemy.r && x + w > enemy.x - enemy.r && y < enemy.y + enemy.h && y + h > enemy.y;
  }
  
  boolean intersectsR(IsaacPlayer player) {
    return !falling && x + w < player.x && x + w > player.x - player.r && y < player.y + player.r && y + h > player.y - player.r;
  }
  
  boolean intersectsL(IsaacPlayer player) {
    return !falling && x < player.x + player.r && x > player.x && y < player.y + player.r && y + h > player.y - player.r;
  }
  
  boolean intersectsD(IsaacPlayer player) {
    return !falling && x < player.x + player.r && x + w > player.x - player.r && y + h < player.y && y + h > player.y - player.r;
  }
  
  boolean intersectsU(IsaacPlayer player) {
    return !falling && x < player.x + player.r && x + w > player.x - player.r && y < player.y + player.r && y > player.y;
  }
  
  boolean intersectsR(IsaacEnemy enemy) {
    return !falling && x + w < enemy.x && x + w > enemy.x - enemy.r && y < enemy.y + enemy.r && y + h > enemy.y - enemy.r;
  }
  
  boolean intersectsL(IsaacEnemy enemy) {
    return !falling && x < enemy.x + enemy.r && x > enemy.x && y < enemy.y + enemy.r && y + h > enemy.y - enemy.r;
  }
  
  boolean intersectsD(IsaacEnemy enemy) {
    return !falling && x < enemy.x + enemy.r && x + w > enemy.x - enemy.r && y + h < enemy.y && y + h > enemy.y - enemy.r;
  }
  
  boolean intersectsU(IsaacEnemy enemy) {
    return !falling && x < enemy.x + enemy.r && x + w > enemy.x - enemy.r && y < enemy.y + enemy.r && y > enemy.y;
  }
  
  boolean intersects(IsaacProjectile p) {
    return !falling && !traversible && x < p.x + p.r && x + w > p.x - p.r && y < p.y + p.r && y + h > p.y - p.r;
  }
  
  boolean intersects(IsaacBomb bomb) {
    return !falling && bomb.exploding && (bomb.explosionTime == 1) &&
            (x < bomb.x + bomb.explosionR && x + w > bomb.x - bomb.explosionR && y < bomb.y + bomb.explosionR && y + h > bomb.y - bomb.explosionR);
  }
}
