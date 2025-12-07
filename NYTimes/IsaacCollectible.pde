public class IsaacCollectible {
  
  float x, y;
  float w = width*.0125;
  float r = w*.5;
  color clr = #2AF72C;
  int effect;
  boolean collectable;                                                                    //whether the player can pick up the item
  
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
    this.collectable = true;
    this.effect = effect;
    switch(effect) {
      case 0:
        this.clr = #FFFF00;
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
  
  public IsaacCollectible(int effect, float x, float y) {
    this.x = x;
    this.y = y;
    this.w = width*.0125;
    this.r = w*.5;
    this.collectable = true;
    this.effect = effect;
    switch(effect) {
      case 0:
        this.clr = #FFFF00;
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
      case 8:
        this.clr = #191919;
        break;
      case 9:
        this.clr = #44D3B5;
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
    if(collectable && intersects(is.player)) {
      pickUp(is.player);
      return true;
    }
    return false;
  }
  
  void pickUp(IsaacPlayer player) {
    switch(effect) {
      case 0:
        player.addCoin();
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
        player.addFamiliar();
        break;
      case 6:
        player.setFlying(true);
        break;
      case 7:
        player.setProjectileFollowing(true);
        break;
      default:
        player.setActivatable(this);
    }
  }
  
  void activate() {
    switch(effect) {
      case 8:
        is.player.stopTime();
        break;
      case 9:
        is.getCurrentMap().getCurrentRoom().damageAllEnemies(40);
        break;
      default:
    }
  }
  
  boolean intersects(IsaacPlayer player) {
    return x - r < player.x + player.r && x + r > player.x - player.r && y - r < player.y + player.r && y + r > player.y - player.r;
  }
}
