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
  boolean bouncing;                                                                    //whether projectile can bouce off of walls and obstacles
  IsaacEnemy targetEnemy;                                                              //enemy to be followed
  
  public IsaacProjectile(float x, float y, float dx, float dy, float speed, float time, float w, float damage, float knockback, boolean bouncing) {
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
    this.bouncing = bouncing;
  }
  
  public IsaacProjectile(float x, float y, float dx, float dy, float speed, float time, float w, float damage, float knockback, boolean followingEnemy, IsaacEnemy targetEnemy, boolean bouncing) {
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
    this.bouncing = bouncing;
  }
  
  public IsaacProjectile(float x, float y, double radians, float speed, float time, float w, float damage, float knockback, boolean bouncing) {
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
    this.bouncing = bouncing;
  }
  
  public IsaacProjectile(float x, float y, float x2, float y2, float speed, float w, float damage, float knockback, boolean bouncing) {
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
    this.bouncing = bouncing;
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
      if(x <= borderWidth) {
        setX(borderWidth);
        if(bouncing) {
          dx *= -1;
        } else {
          return true;
        }
      } else if(x >= width-borderWidth) {
        setX(width-borderWidth);
        if(bouncing) {
          dx *= -1;
        } else {
          return true;
        }
      }
      if(y <= borderWidth) {
        setY(borderWidth);
        if(bouncing) {
          dy *= -1;
        } else {
          return true;
        }
      } else if(y >= height-borderWidth) {
        setY(height-borderWidth);
        if(bouncing) {
          dy *= -1;
        } else {
          return true;
        }
      }
      if(time-- <= 0) {
        return true;
      }
    }
    return false;
  }
  
  void setX(float x) {
    this.x = x;
  }
  
  void setY(float y) {
    this.y = y;
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
    return player.r + r >= sqrt(pow((player.x - x), 2) + pow((player.y - y), 2));
  }
  
  boolean intersects(IsaacObstacle o) {
    return x - r < o.x + o.w && x + r > o.x && y - r < o.y + o.h && y + r > o.y;
  }
}
