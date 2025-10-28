public class IsaacCollectible {
  
  float x, y;
  float w = width*.0125;
  float r = w*.5;
  color clr = #2AF72C;
  int effect;
  
  public IsaacCollectible(float x, float y) {
    this.x = x;
    this.y = y;
    this.effect = 3;
    this.clr = #000000;
  }
  
  public IsaacCollectible() {
    this.x = width*.5;
    this.y = height*.5;
    this.w = width*.0125;
    this.r = w*.5;
    this.effect = 3;
  }
  
  public IsaacCollectible(int effect) {
    this.x = width*.5;
    this.y = height*.5;
    this.w = width*.0125;
    this.r = w*.5;
    this.effect = effect;
    switch(effect) {
      case 0:
        this.clr = #2AF72C;
        break;
      case 1:
        this.clr = #FFFFFF;
        break;
      case 2:
        this.clr = #FF0000;
        break;
      case 3:
        this.clr = #000000;
        break;
      default:
    }
  }
  
  void display() {
    pushStyle();
    fill(clr);
    circle(x, y, w);
    popStyle();
  }
  
  boolean update() {
    if(intersects(is.player)) {
      pickUp(is.player);
      return true;
    }
    return false;
  }
  
  void pickUp(IsaacPlayer player) {
    switch(effect) {
      case 0:
        player.addFamiliar();
        break;
      case 1:
        player.speedUp();
        break;
      case 2:
        player.changeStyle();
        break;
      case 3:
        player.fireRateUp();
        break;
      case 4:
        player.projectileSizeUp();
        break;
      case 5:
        player.changeId();
        break;
      case 6:
        player.setFlying(true);
        break;
      case 7:
        player.setProjectileFollowing(true);
        break;
      default:
        player.fireRateUp();
    }
  }
  
  boolean intersects(IsaacPlayer player) {
    return x - r < player.x + player.r && x + r > player.x - player.r && y - r < player.y + player.r && y + r > player.y - player.r;
  }
}
