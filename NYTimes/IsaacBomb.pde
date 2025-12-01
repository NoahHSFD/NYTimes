public class IsaacBomb {
  
  float x, y;
  float r, w;
  float explosionWidth, explosionHeight;
  float explosionR, explosionW;
  float explosionTime, explosionDuration;                                                 //time until explosion, duration of explosion itself
  float damage;
  boolean exploding;                                                                      //whether the bomb is currently exploding
  color clr = #000000;
  
  public IsaacBomb(float x, float y, float w, float explosionW, float explosionTime, float damage) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.r = w*.5;
    this.explosionW = explosionW;
    this.explosionR = explosionW*.5;
    this.explosionTime = explosionTime;
    this.explosionDuration = 15;
    this.damage = damage;
  }
  
  void display() {
    pushStyle();
    if(exploding) {
      noStroke();
      fill(#FF0000);
      circle(x, y, explosionW);
    } else {
      fill(clr);
      circle(x, y, w);
    }
    popStyle();
  }
  
  boolean update() {
    if(!exploding && explosionTime-- <= 0) {
      explosionTime = 0;
      explode();
    }
    if(intersects(is.player)) is.player.hit(1);
    return (exploding && (explosionTime++ >= explosionDuration));
  }
  
  void explode() {
    exploding = true;
  }
  
  float getDamage() {
    return damage;
  }
  
  boolean intersects(IsaacPlayer player) {
    return exploding && (explosionTime == 1) && (player.r + explosionR >= sqrt(pow((player.x - x), 2) + pow((player.y - y), 2)));
  }
}
