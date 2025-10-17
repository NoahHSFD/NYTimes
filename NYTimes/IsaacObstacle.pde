public class IsaacObstacle {
  
  float x, y;
  float w, h;
  boolean traversible;                                                                  //whether it can be flown over
  boolean destructible;                                                                 //whether it can be destroyed with bombs
  color clr = #000000;
  int type;                                                                             //0 = hole; 1 = block
  
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
        break;
      default:
    }
  }
  
  void display() {
    pushStyle();
    fill(clr);
    rect(x, y, w, h);
    popStyle();
  }
  
  void update() {
    if(!(is.player.getFlying() && traversible)) {
      if(intersectsR(is.player) && is.player.moveKeys[3] == -1) {
        is.player.setX(x + w + is.player.getR());
      }
      if(intersectsL(is.player) && is.player.moveKeys[2] == 1) {
        is.player.setX(x - is.player.getR());
      }
      if(intersectsD(is.player) && is.player.moveKeys[0] == -1) {
        is.player.setY(y + h + is.player.getR());
      }
      if(intersectsU(is.player) && is.player.moveKeys[1] == 1) {
        is.player.setY(y - is.player.getR());
      }
    }
  }
  
  boolean intersectsR(IsaacPlayer player) {
    return x + w < player.x && x + w > player.x - player.r && y < player.y + player.r && y + h > player.y - player.r;
  }
  
  boolean intersectsL(IsaacPlayer player) {
    return x < player.x + player.r && x > player.x && y < player.y + player.r && y + h > player.y - player.r;
  }
  
  boolean intersectsD(IsaacPlayer player) {
    return x < player.x + player.r && x + w > player.x - player.r && y + h < player.y && y + h > player.y - player.r;
  }
  
  boolean intersectsU(IsaacPlayer player) {
    return x < player.x + player.r && x + w > player.x - player.r && y < player.y + player.r && y > player.y;
  }
  
  boolean intersectsR(IsaacEnemy enemy) {
    return x + w < enemy.x && x + w > enemy.x - enemy.r && y < enemy.y + enemy.r && y + h > enemy.y - enemy.r;
  }
  
  boolean intersectsL(IsaacEnemy enemy) {
    return x < enemy.x + enemy.r && x > enemy.x && y < enemy.y + enemy.r && y + h > enemy.y - enemy.r;
  }
  
  boolean intersectsD(IsaacEnemy enemy) {
    return x < enemy.x + enemy.r && x + w > enemy.x - enemy.r && y + h < enemy.y && y + h > enemy.y - enemy.r;
  }
  
  boolean intersectsU(IsaacEnemy enemy) {
    return x < enemy.x + enemy.r && x + w > enemy.x - enemy.r && y < enemy.y + enemy.r && y > enemy.y;
  }
  
  boolean intersects(IsaacProjectile p) {
    return !traversible && x < p.x + p.r && x + w > p.x - p.r && y < p.y + p.r && y + h > p.y - p.r;
  }
}
