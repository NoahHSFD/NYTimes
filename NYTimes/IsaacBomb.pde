public class IsaacBomb {
  
  float x, y;
  float r, w;
  float explosionWidth, explosionHeight;
  float explosionR, explosionW;
  float explosionTime, explosionDuration;                                                 //time until explosion, duration of explosion itself
  float damage;
  boolean exploding;                                                                      //whether the bomb is currently exploding
  color clr = #000000;
  SoundFile explosionSound;
  
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
    if(is.player.passiveEffects.contains(10)) {
      switch(is.player.bombs) {
        case 1:
          this.damage *= 5;
          this.w *= 2;
          this.r = this.w*.5;
          this.explosionW *= 2;
          this.explosionR = this.explosionW*.5;
          break;
        case 2:
          this.damage *= 4;
          this.w *= 1.8;
          this.r = this.w*.5;
          this.explosionW *= 1.8;
          this.explosionR = this.explosionW*.5;
          break;
        case 3:
          this.damage *= 3;
          this.w *= 1.6;
          this.r = this.w*.5;
          this.explosionW *= 1.6;
          this.explosionR = this.explosionW*.5;
          break;
        case 4:
          this.damage *= 2.5;
          this.w *= 1.4;
          this.r = this.w*.5;
          this.explosionW *= 1.4;
          this.explosionR = this.explosionW*.5;
          break;
        case 5:
          this.damage *= 2;
          this.w *= 1.2;
          this.r = this.w*.5;
          this.explosionW *= 1.2;
          this.explosionR = this.explosionW*.5;
          break;
        default:
          this.damage *= 2;
          this.w *= 1.2;
          this.r = this.w*.5;
          this.explosionW *= 1.2;
          this.explosionR = this.explosionW*.5;
      }
    }
    try {
      if(is.player.passiveEffects.contains(10)) {
        switch(is.player.bombs) {
          case 1:
            this.explosionSound = sfx.get(5);
            break;
          case 2:
            this.explosionSound = sfx.get(4);
            break;
          case 3:
            this.explosionSound = sfx.get(3);
            break;
          case 4:
            this.explosionSound = sfx.get(2);
            break;
          case 5:
            this.explosionSound = sfx.get(1);
            break;
          default:
            this.explosionSound = sfx.get(1);
        }
      } else {
        this.explosionSound = sfx.get(0);
      }
    } catch(Exception e) {
      println(e + "\nCan't set explosion sound.");
    }
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
    try {
      explosionSound.removeFromCache();
      explosionSound.stop();
      explosionSound.play();
    } catch(Exception e) {
      println(e + "\nCan't play explosion sound.");
    }
  }
  
  float getDamage() {
    return damage;
  }
  
  boolean intersects(IsaacPlayer player) {
    return exploding && (explosionTime == 1) && (player.r + explosionR >= sqrt(pow((player.x - x), 2) + pow((player.y - y), 2)));
  }
}
