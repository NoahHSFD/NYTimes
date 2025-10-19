public class IsaacCollectible {
  
  float x, y;
  float w = width*.0125;
  float r = w*.5;
  color clr = #2AF72C;
  CollectibleEffect effect;
  
  public IsaacCollectible(float x, float y) {
    this.x = x;
    this.y = y;
    this.effect = CollectibleEffect.FIRERATEUP;
  }
  
  public IsaacCollectible() {
    this.x = width*.5;
    this.y = height*.5;
    this.w = width*.0125;
    this.r = w*.5;
    this.effect = CollectibleEffect.FIRERATEUP;
  }
  
  public IsaacCollectible(int effect) {
    this.x = width*.5;
    this.y = height*.5;
    this.w = width*.0125;
    this.r = w*.5;
    switch(effect) {
      case 0:
        this.effect = CollectibleEffect.ADDFAMILIAR;
        this.clr = #2AF72C;
        break;
      case 1:
        this.effect = CollectibleEffect.SPEEDUP;
        this.clr = #FFFFFF;
        break;
      case 2:
        this.effect = CollectibleEffect.CHANGESTYLE;
        this.clr = #FF0000;
        break;
      case 3:
        this.effect = CollectibleEffect.FIRERATEUP;
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
      case FIRERATEUP:
        player.fireRateUp();
        break;
      case SPEEDUP:
        player.speedUp();
        break;
      case PROJECTILESIZEUP:
        player.projectileSizeUp();
        break;
      case CHANGESTYLE:
        player.changeStyle();
        break;
      case CHANGEID:
        player.changeId();
        break;
      case ADDFAMILIAR:
        player.addFamiliar();
        break;
      default:
    }
  }
  
  boolean intersects(IsaacPlayer player) {
    return x - r < player.x + player.r && x + r > player.x - player.r && y - r < player.y + player.r && y + r > player.y - player.r;
  }
}
