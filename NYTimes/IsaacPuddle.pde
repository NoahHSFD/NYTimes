public class IsaacPuddle {
  
  float x, y;
  float w, h;
  float time;
  color clr = #00FF00;
  float damage = 1;
  
  public IsaacPuddle(float x, float y, float w, float h, float time, float damage) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.time = time;
    this.damage = damage;
  }
  
  void display() {
    pushStyle();
    noStroke();
    fill(clr);
    rect(x, y, w, h);
    popStyle();
  }
  
  boolean update() {
    if(time-- < 0) return true;
    return false;
  }
  
  float getDamage() {
    return damage;
  }
  
  boolean intersects(IsaacPlayer player) {
    return !player.flying && this.x < player.x + player.r && this.x + this.w > player.x - player.r && this.y < player.y + player.r && this.y + this.h > player.y - player.r;
  }
}
