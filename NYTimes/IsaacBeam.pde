public class IsaacBeam {
  
  float x, y;
  float w, h;
  float dx, dy;
  float time;                                                                        //how long the beam exists
  color clr = #00FFFF;
  float damage = 1;
  float knockback;
  
  public IsaacBeam(float x, float y, float w, float h, float dx, float dy, float time, float charge, float knockback) {
    this.dx = dx;
    this.dy = dy;
    if(dx == 1) {
      this.w = h;
      this.h = w;
      this.x = x;
      this.y = y-(w*.5);
    } else if(dx == -1) {
      this.w = h;
      this.h = w;
      this.x = x-h;
      this.y = y-(w*.5);
    } else if(dy == 1) {
      this.w = w;
      this.h = h;
      this.x = x-(w*.5);
      this.y = y-h;
    } else {
      this.w = w;
      this.h = h;
      this.x = x-(w*.5);
      this.y = y;
    }
    this.time = time;
    this.damage *= charge*.25;
    this.knockback = knockback;
  }
  
  void display() {
    pushStyle();
    fill(clr);
    rect(x, y, w, h);
    popStyle();
  }
  
  boolean update() {
    if(dx == 1) {
      w = width - is.borderWidth - is.player.getX();
      x = is.player.getX();
      y = is.player.getY() - (h*.5);
      for(IsaacObstacle o : is.getCurrentMap().getCurrentRoom().obstacleList) {
        if(!o.traversible) {
          if(o.y < (y + h) && (o.y + o.h) > y && (o.x - x) > 0 && (o.x - x) < w) {
            w = o.x - x;
          }
        }
      }
      for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
        if(!e.dead && !e.corpse && !e.jumping && !e.untargetable) {
          if(e.y - e.r < (y + h) && (e.y + e.r) > y && (e.x - x) > 0 && (e.x - x) < w) {
            w = e.x - x;
          }
        }
      }
    } else if(dx == -1) {
      w = is.player.getX() - is.borderWidth;
      x = is.player.getX() - w;
      y = is.player.getY() - (h*.5);
      for(IsaacObstacle o : is.getCurrentMap().getCurrentRoom().obstacleList) {
        if(!o.traversible) {
          if(o.y < (y + h) && (o.y + o.h) > y && is.player.getX() - (o.x + o.w) > 0 && is.player.getX() - (o.x + o.w) < x + w) {
            x = o.x + o.w;
            w = is.player.getX() - x;
          }
        }
      }
      for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
        if(!e.dead && !e.corpse && !e.jumping && !e.untargetable) {
          if(e.y - e.r < (y + h) && (e.y + e.r) > y && is.player.getX() - (e.x) > 0 && is.player.getX() - (e.x) < w) {
            x = e.x;
            w = is.player.getX() - x;
          }
        }
      }
    } else if(dy == -1) {
      h = is.player.getY() - is.borderWidth;
      x = is.player.getX() - (w*.5);
      y = is.player.getY() - h;
      for(IsaacObstacle o : is.getCurrentMap().getCurrentRoom().obstacleList) {
        if(!o.traversible) {
          if(o.x < (x + w) && (o.x + o.w) > x && is.player.getY() - (o.y + o.h) > 0 && is.player.getY() - (o.y + o.h) < y + h) {
            y = o.y + o.h;
            h = is.player.getY() - y;
          }
        }
      }
      for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
        if(!e.dead && !e.corpse && !e.jumping && !e.untargetable) {
          if(e.x - e.r < (x + w) && (e.x + e.r) > x && is.player.getY() - (e.y) > 0 && is.player.getY() - (e.y) < h) {
            y = e.y;
            h = is.player.getY() - y;
          }
        }
      }
    } else {
      h = height - is.borderWidth - is.player.getY();
      x = is.player.getX() - (w*.5);
      y = is.player.getY();
      for(IsaacObstacle o : is.getCurrentMap().getCurrentRoom().obstacleList) {
        if(!o.traversible) {
          if(o.x < (x + w) && (o.x + o.w) > x && (o.y - y) > 0 && (o.y - y) < h) {
            h = o.y - y;
          }
        }
      }
      for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
        if(!e.dead && !e.corpse && !e.jumping && !e.untargetable) {
          if(e.x - e.r < (x + w) && (e.x + e.r) > x && (e.y - y) > 0 && (e.y - y) < h) {
            h = e.y - y;
          }
        }
      }
    }
    if(time-- <= 0) {
      return true;
    }
    return false;
  }
  
  void setTime(int time) {
    this.time = time;
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
}
