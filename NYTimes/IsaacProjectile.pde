public class IsaacProjectile {
  
  float x, y;
  float w = width*.0125;
  float r = w*.5;
  float dx, dy;
  float speed = 7;
  float time = 100;                                                                    //how long the projectile exists
  color clr = #00FFFF;
  float damage = 30;
  float knockback;
  float delayTime, delayTimer;                                                         //delay until the projectile spawns
  boolean followingEnemy, followingPlayer;                                             //whether the projectile follows an enemy/player
  IsaacEnemy targetEnemy;                                                              //enemy to be followed
  
  public IsaacProjectile(float x, float y, float dx, float dy, float speed, float time, float w, float damage, float knockback) {
    this.w = w;
    this.r = w*.5;
    this.x = x + dx*r;
    this.y = y + dy*r;
    this.dx = dx;
    this.dy = dy;
    this.speed = speed;
    this.time = time;
    this.damage = damage;
    this.knockback = knockback;
  }
  
  public IsaacProjectile(float x, float y, float dx, float dy, float speed, float time, float w, float damage, float knockback, boolean followingEnemy, IsaacEnemy targetEnemy) {
    this.w = w;
    this.r = w*.5;
    this.x = x + dx*r;
    this.y = y + dy*r;
    this.dx = dx;
    this.dy = dy;
    this.speed = speed;
    this.time = time;
    this.damage = damage;
    this.knockback = knockback;
    this.followingEnemy = followingEnemy;
    this.targetEnemy = targetEnemy;
  }
  
  public IsaacProjectile(float x, float y, double radians, float speed, float time, float w, float damage, float knockback) {
    this.w = w;
    this.r = w*.5;
    this.x = x;
    this.y = y;
    this.dx = (float)Math.cos(radians);
    this.dy = (float)Math.sin(radians);
    this.speed = speed;
    this.time = time;
    this.damage = damage;
    this.knockback = knockback;
  }
  
  public IsaacProjectile(float x, float y, float x2, float y2, float speed, float w, float damage, float knockback) {
    this.w = w;
    this.r = w*.5;
    this.x = x;
    this.y = y;
    this.time = 1000;
    this.dx = (x2-x)/(Math.abs(x2-x)+Math.abs(y2-y));
    this.dy = (y2-y)/(Math.abs(x2-x)+Math.abs(y2-y));
    this.speed = speed;
    this.damage = damage;
    this.knockback = knockback;
  }
  
  void display() {
    if(delayTimer >= delayTime) {
      pushStyle();
      fill(clr);
      strokeWeight(2);
      circle(x, y, w);
      noStroke();
      fill(#FFFFFF);
      circle(x - r*.3, y - r*.3, r*.85);
      popStyle();
    }
  }
  
  boolean update() {
    if(delayTimer++ >= delayTime) {
      if(followingEnemy && !targetEnemy.dead && !targetEnemy.jumping && !targetEnemy.corpse && !targetEnemy.untargetable) {
        dx = (targetEnemy.x-x)/(Math.abs(targetEnemy.x-x) + Math.abs(targetEnemy.y-y));
        dy = (targetEnemy.y-y)/(Math.abs(targetEnemy.x-x) + Math.abs(targetEnemy.y-y));
      }
      x += dx*speed;
      y += dy*speed;
      if (x <= is.borderWidth) {
        return true;
      } else if (x >= width-is.borderWidth) {
        return true;
      }
      if (y <= is.borderWidth) {
        return true;
      } else if (y >= height-is.borderWidth) {
        return true;
      }
      if(time-- <= 0) {
        return true;
      }
    }
    return false;
  }
  
  void setSpeed(int speed) {
    this.speed = speed;
  }
  
  void setTime(int time) {
    this.time = time;
  }
  
  void setDelayTime(float delayTime) {
    this.delayTime = delayTime;
  }
  
  void setTarget(IsaacEnemy targetEnemy) {
    this.targetEnemy = targetEnemy;
  }
  
  float getDamage() {
    return damage;
  }
  
  float getKnockback() {
    return knockback;
  }
  
  float getDx() {
    return dx;
  }
  
  float getDy() {
    return dy;
  }
  
  boolean intersects(IsaacPlayer player) {
    return player.r + r >= sqrt(pow((player.x - this.x), 2) + pow((player.y - this.y), 2));
  }
  
  boolean intersects(IsaacObstacle o) {
    return this.x - this.r < o.x + o.w && this.x + this.r > o.x && this.y - this.r < o.y + o.h && this.y + this.r > o.y;
  }
}
