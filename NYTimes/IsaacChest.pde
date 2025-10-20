public class IsaacChest {
  
  float x, y;
  float w, h;
  color clr = #2AF72C;
  boolean open;
  int content;
  
  public IsaacChest(float x, float y, int content) {
    this.x = x;
    this.y = y;
    this.w = width*.025;
    this.h = w;
    this.content = content;
  }
  
  void display() {
    pushStyle();
    fill(clr);
    rect(x, y, w, h);
    popStyle();
  }
  
  boolean update() {
    if(!open && intersects(is.player) && is.player.keys > 0) {
      open(is.player);
      return true;
    }
    return false;
  }
  
  void open(IsaacPlayer player) {
    player.removeKey();
    clr = #FF0000;
    open = true;
  }
  
  boolean intersects(IsaacPlayer player) {
    return x < player.x + player.r && x + w > player.x - player.r && y < player.y + player.r && y + h > player.y - player.r;
  }
}
