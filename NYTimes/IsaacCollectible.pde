public class IsaacCollectible {
  
  float x, y;
  float w = width*.0125;
  float r = w*.5;
  color clr = #2AF72C;
  int effect;
  boolean collectable;                                                                    //whether the player can pick up the item
  boolean priced;                                                                         //whether the item is for sale and has a price
  int price;
  
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
      case -2:
        this.clr = #191919;
        break;
      case -1:
        this.clr = #44D3B5;
        break;
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
  
  void display() {
    pushStyle();
    fill(clr);
    circle(x, y, w);
    if(priced) {
      fill(#FFFFFF);
      textAlign(CENTER, CENTER);
      text(price, x, y + w*2);
    }
    popStyle();
  }
  
  boolean update() {
    collectable = priced ? price <= is.player.coins : true;
    if(collectable && intersects(is.player)) {
      pickUp(is.player);
      return true;
    }
    return false;
  }
  
  void pickUp(IsaacPlayer player) {
    if(priced) is.player.coins -= price;
    switch(effect) {
      case -2:                                                                              //time stop
        player.setActivatable(this);
        break;
      case -1:                                                                              //necronomicon
        player.setActivatable(this);
        break;
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
      case 10:                                                                               //5 big booms
        player.addPassive(effect);
        player.bombs = 5;
        break;
      default:
    }
  }
  
  void setPrice(int price) {
    this.priced = true;
    this.price = price;
  }
  
  void activate() {
    switch(effect) {
      case -2:
        is.player.stopTime();
        break;
      case -1:
        is.getCurrentMap().getCurrentRoom().damageAllEnemies(40);
        break;
      default:
    }
  }
  
  boolean intersects(IsaacPlayer player) {
    return x - r < player.x + player.r && x + r > player.x - player.r && y - r < player.y + player.r && y + r > player.y - player.r;
  }
}
