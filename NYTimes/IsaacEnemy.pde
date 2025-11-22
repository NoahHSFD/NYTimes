public class IsaacEnemy {

  float x, y;
  float spriteY;                                                               //y coordinate where the enemy sprite is displayed (for example for jumping enemies)
  float w, r;
  float h;
  float baseSpeed, speed;                                                      //base speed and current speed
  float dx, dy;
  color clr = #F200FF;
  int facingX, facingY;                                                        //x=-1:left; x=1:right; y=-1:up; y=1:down
  ArrayList<IsaacProjectile> enemyProjectiles = new ArrayList<IsaacProjectile>();
  ArrayList<IsaacPuddle> enemyPuddles = new ArrayList<IsaacPuddle>();
  float shootTimer, puddleTimer;                                               //timer for projectiles/puddles
  float fireRate, puddleRate, jumpingRate, standingRate, randomMovementRate;   //controls rate at which projectiles are fired/puddles are left/enemy jumps/enemy stands still/enemy changes direction
  float projectileSpeed;                                                       //how fast projectiles fly
  float projectileTime, puddleTime;                                            //how long projectiles/puddles stay
  float puddleWidth, puddleHeight;
  float projectileSize;
  int projectileDamage, puddleDamage;
  int projectileAmount;                                                        //how many projectiles at once an enemy shoots
  int maxBullets;                                                              //how often an enemy can shoot before having to reload
  int bullets;                                                                 //how many bullets are left in a magazine
  float reloadTime;                                                            //time needed to reload bullets
  float reloadTimer;                                                           //timer to check when an enemy has finished reloading bullets
  float projectileKnockback;
  float knockbackEfficiency;                                                   //how much the enemy is affected by knockback
  float maxHp, hp;
  boolean flying;                                                              //whether the enemy is affected by the ground
  boolean standing;                                                            //whether the enemy is currently standing still
  boolean jumping;                                                             //whether the enemy is currently jumping into the air off screen
  boolean leavesTrail;                                                         //whether the enemy leaves an IsaacPuddle trail
  boolean following;                                                           //whether the enemy follows the player
  boolean randomMovement;                                                      //whether the enemy just walks around randomly
  boolean aiming;                                                              //whether projectiles are aimed at the player
  boolean explodesOnDeath, spawnsOnDeath, leavesCorpse;                        //whether en enemy explodes into projectiles/spawns enemies/leaves behind a corpse when it dies
  boolean shootsWhenHit, puddleWhenHit;                                        //shoots a projectile/leaves a puddle when hit
  boolean dead;                                                                //enemy object stays on the field after a while for projectiles and puddles to still remain on field
  boolean untargetable;                                                        //whether enemy can be hit by projectiles/beams
  boolean noContactDamage;                                                     //whether player takes damage on contact
  boolean noShadow;                                                            //whether a shadow is displayed
  boolean bossAttacking;                                                       //whether a boss is currently executing an attack
  boolean revives, reviving;                                                   //whether an enemy can/is being revived
  boolean corpse;                                                              //whether enemy is a corpse left behind after dying
  boolean flyable;                                                             //whether an enemy can be flown over without taking contact damage
  boolean projectileBounce;                                                    //whether projectiles bounce off of walls and obstacles
  boolean reloading;                                                           //whether an enemy is currently reloading bullets
  boolean timeStopped;                                                         //timestopped enemies and their projectiles can't move
  int bossAttackType, bossAttackAmount;                                        //different attacks a boss can execute; amount of how many total different attacks a boss has
  int deathSpawn, deathSpawnAmount;                                            //type/amount of enemies that get spawned when enemy dies
  int screamGap;                                                               //projectile gap in scream attack
  float bossAttackRate;                                                        //controls rate at which boss launches new attack after an old one is finished
  float bossAttackTimer;                                                       //timer for when a new boss attack starts
  float bossAttackDuration;                                                    //duration of boss attack
  float bossAttackDurationTimer;                                               //timer for how long a boss attack lasts
  float deathTime;                                                             //how long enemy object stays after death before being removed
  float standingTimer, standstillTimer;                                        //timer for when and how long the enemy stands still
  float standstillTime;                                                        //time how long the enemy stands still
  float jumpingTimer, airborneTimer;                                           //timers for when the enemy jumps and how long it stays in the air
  float airborneTime;                                                          //duration of how long enemy stays in the air
  float randomMovementTimer;                                                   //timer for enemies with random movement to change direction
  float revivalTimer;                                                          //timer for when the enemy revives
  float revivalTime;                                                           //time an enemy needs to revive
  int phase;                                                                   //boss phases
  int type;

  public IsaacEnemy(int type, float x, float y) {
    this.x = x;
    this.y = y;
    this.w = width*.05;
    this.r = w*.5;
    this.h = width*.05;
    this.facingX = int(round(random(-1, 1)));
    if(facingX != 0) {
      this.facingY = 0;
    } else {
      if(random(-1, 1) >= 0) {
        this.facingY = 1;
      } else {
        this.facingY = -1;
      }
    }
    this.baseSpeed = 3;
    this.dx = facingX;
    this.dy = facingY;
    this.projectileSpeed = 5;
    this.projectileTime = 80;
    this.airborneTime = 200;
    this.standstillTime = 100;
    this.puddleTime = 200;
    this.projectileSize = r;
    this.projectileDamage = 1;
    this.puddleDamage = 1;
    this.projectileAmount = 1;
    this.revivalTime = 200;
    this.maxHp = 200;
    this.type = type;
    switch(type) {
      case 0:
        this.clr = #F200FF;
        this.fireRate = 1;
        this.knockbackEfficiency = 1;
        this.projectileAmount = 7;
        this.projectileBounce = true;
        this.maxBullets = 10;
        this.bullets = maxBullets;
        this.reloadTime = 250;
        break;
      case 1:
        this.clr = #E7F00C;
        this.flying = true;
        this.fireRate = 1;
        this.knockbackEfficiency = 1;
        break;
      case 2:
        this.clr = #2836C6;
        this.fireRate = .5;
        this.shootTimer = 25;
        this.standingRate = 1;
        this.aiming = true;
        this.projectileTime = 160;
        break;
      case 3:
        this.clr = #E10DFA;
        this.baseSpeed = 1;
        this.fireRate = .5;
        this.jumpingRate = .2;
        this.flying = true;
        this.following = true;
        this.knockbackEfficiency = 1.2;
        this.revives = true;
        break;
      case 4:
        this.baseSpeed = 2;
        this.puddleRate = 40;
        this.knockbackEfficiency = .5;
        break;
      case 5:
        this.baseSpeed = 7;
        this.flying = true;
        if(dx != 0) {
          dx *= .5;
          dy = random(-1, 1) > 0 ? .5 : -.5;
        } else {
          dx = random(-1, 1) > 0 ? .5 : -.5;
          dy *= .5;
        }
        this.knockbackEfficiency = 1;
        this.explodesOnDeath = true;
        break;
      case 6:
        this.following = true;
        this.baseSpeed = 1;
        this.puddleRate = 40;
        this.knockbackEfficiency = 2;
        this.explodesOnDeath = true;
        break;
      case 7:
        this.maxHp = 500;
        this.following = true;
        this.revives = true;
        break;
      case 8:
        this.w *= .5;
        this.r = w*.5;
        this.randomMovement = true;
        break;
      case 10:                                                                                  //monstro
        this.w = width*.075;
        this.r = w*.5;
        this.baseSpeed = 2;
        this.fireRate = .5;
        this.puddleRate = 40;
        this.puddleTime = 500;
        this.jumpingRate = .3;
        this.airborneTime = 300;
        this.flying = true;
        this.following = true;
        this.maxHp = 5000;
        break;
      case 20:                                                                                  //gemini - contusion
        this.w *= 1.25;
        this.r = w*.5;
        this.following = true;
        this.maxHp = 2500;
        break;
      case 21:                                                                                  //gemini - suture
        this.w *= .5;
        this.r = w*.5;
        this.baseSpeed = 1;
        this.fireRate = .5;
        this.flying = true;
        this.following = true;
        this.maxHp = 2500;
        break;
      case 30:                                                                                  //gums - mouth
        this.baseSpeed = 0;
        this.w = width/4.;
        this.r = w*.5;
        this.h = height*.1;
        this.x = width/2. - r;
        this.y = 0;
        this.projectileTime = 250;
        this.untargetable = true;
        this.noContactDamage = true;
        this.noShadow = true;
        this.screamGap = int(random(0, projectileAmount+1));
        this.bossAttackAmount = 5;
        this.bossAttackRate = .2;
        break;
      case 31:                                                                                  //gums - teeth (31-36)
        this.baseSpeed = 0;                                                                     //healthy tooth
        this.maxHp = 1000;
        this.leavesCorpse = true;
        break;
      case 32:                                                                                  //brittle tooth
        this.baseSpeed = 0;
        this.shootsWhenHit = true;
        this.leavesCorpse = true;
        break;
      case 320:                                                                                 //brittle tooth - enamel projectile
        this.baseSpeed = 0;
        break;
      case 33:                                                                                  //bloody tooth
        this.baseSpeed = 0;
        this.explodesOnDeath = true;
        this.leavesCorpse = true;
        break;
      case 34:                                                                                  //rotting tooth
        this.baseSpeed = 0;
        this.puddleWhenHit = true;
        this.puddleTime = 500;
        this.leavesCorpse = true;
        break;
      case 35:                                                                                  //infested tooth
        this.baseSpeed = 0;
        this.spawnsOnDeath = true;
        this.deathSpawn = 8;
        this.deathSpawnAmount = 6;
        this.leavesCorpse = true;
        break;
      case 36:                                                                                  //gold tooth
        this.baseSpeed = 0;
        this.puddleWhenHit = true;
        this.leavesCorpse = true;
        break;
      case 40:                                                                                  //jhon
        this.maxHp = 500;
        this.w *= 2.;
        this.maxBullets = 5;
        this.bullets = maxBullets;
        this.fireRate = .5;
        this.reloadTime = 400;
        this.projectileDamage = 2;
        this.aiming = true;
        this.randomMovement = true;
        this.projectileTime = 500;
        this.projectileBounce = true;
        break;
    default:
    }
    if(randomMovement) {
      this.randomMovementRate = random(.2, 2);
      this.dx = random(-1, 1);
      this.dy = random(-1, 1);
    }
    this.speed = baseSpeed;
    this.r = w*.5;
    this.hp = maxHp;
    this.puddleWidth = w;
    this.puddleHeight = w;
    this.deathTime = puddleTime > projectileTime ? puddleTime : projectileTime;
  }

  void display() {
    pushStyle();
    if(!dead || leavesCorpse) {
    //fill(clr);
    //circle(x, y, w);
    //fill(#FFFFFF);
    //circle(x + facingX*r*.5, y + facingY*r*.5, r);
      fill(#000000, 70);
      noStroke();
      if(!noShadow) circle(x + (flying ? w*.15 : w*.05), y + (flying ? w*.5 : w*.05), ((airborneTime > 0) ? (((airborneTime/2.)-airborneTimer)/(airborneTime/2.))*w*1.1 : w*1.1));
      spriteY = jumping ? y + ((Math.abs(airborneTimer-airborneTime/2.)-airborneTime/2.)/(airborneTime/2.))*height : y;
      switch(type) {
        case 0:
          image(bocchiIcon, x-w, spriteY-w, 2.*w, 2.*w);
          break;
        case 1:
          image(ryouIcon, x-w, spriteY-w, 2.*w, 2.*w);
          break;
        case 2:
          image(kitaIcon, x-w, spriteY-w, 2.*w, 2.*w);
          break;
        case 3:
          image(nijikaIcon, x-w, spriteY-w, 2.*w, 2.*w);
          break;
        case 4:
          image(bocchiIconBack, x-w, spriteY-w, 2.*w, 2.*w);
          break;
        case 10:
          image(ryouIconBack, x-w, spriteY-w, 2.*w, 2.*w);
          break;
        case 20:
          image(nijikaIconRight, x-w, spriteY-w, 2.*w, 2.*w);
          for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
            if(e.type == 21 && !e.dead) {
              stroke(#000000);
              line(x, y, e.x, e.y);
            }
          }
          break;
        case 21:
          image(nijikaIconLeft, x-w, spriteY-w, 2.*w, 2.*w);
          break;
        case 30:
          image(gums, x, spriteY, w, h);
          break;
        case 31:
          if(jumping) {
            image(gumsToothHealthyFalling, x-w, spriteY-w, 2.*w, 2.*w);
          } else {
            image(gumsToothHealthy, x-w, spriteY-w, 2.*w, 2.*w);
          }
          break;
        case 32:
          if(jumping) {
            image(gumsToothBrittleFalling, x-w, spriteY-w, 2.*w, 2.*w);
          } else {
            image(gumsToothBrittle, x-w, spriteY-w, 2.*w, 2.*w);
          }
          break;
        case 33:
          if(jumping) {
            image(gumsToothBloodyFalling, x-w, spriteY-w, 2.*w, 2.*w);
          } else {
            image(gumsToothBloody, x-w, spriteY-w, 2.*w, 2.*w);
          }
          break;
        case 34:
          if(jumping) {
            image(gumsToothRottingFalling, x-w, spriteY-w, 2.*w, 2.*w);
          } else {
            image(gumsToothRotting, x-w, spriteY-w, 2.*w, 2.*w);
          }
          break;
        case 35:
          if(jumping) {
            image(gumsToothInfestedFalling, x-w, spriteY-w, 2.*w, 2.*w);
          } else {
            image(gumsToothInfested, x-w, spriteY-w, 2.*w, 2.*w);
          }
          break;
        case 36:
          if(jumping) {
            image(gumsToothHealthyFalling, x-w, spriteY-w, 2.*w, 2.*w);
          } else {
            image(gumsToothHealthy, x-w, spriteY-w, 2.*w, 2.*w);
          }
          break;
        case 40:
          image(jhon, x-r, spriteY-r, w, w);
          break;
        default:
          image(bocchiIconLeft, x-w, spriteY-w, 2.*w, 2.*w);
      }
      stroke(#000000);
      fill(#FF0000);
      if(!corpse) rect(x+r, y-r, map(hp, 0, maxHp, 0, 50), 10);
      popStyle();
    }
    //text(reloadTimer + " " + standing, x-r, y+r);
  }

  boolean update() {
    if(!timeStopped) {
      if(!dead) {
        if(!corpse) {
          if(!reviving) {
            if(!jumping) {
              if(!reloading) shootTimer += fireRate;
              puddleTimer += puddleRate;
              jumpingTimer += jumpingRate;
              randomMovementTimer += randomMovementRate;
              if(!standing) standingTimer += standingRate;
              if(!bossAttacking) bossAttackTimer += bossAttackRate;
              if(shootTimer >= 100) {
                if(aiming) {
                  shoot(is.player);
                } else {
                  shoot(projectileAmount);
                }
                shootTimer -= 100;
              }
              if(standingTimer >= 100) {
                stand();
                standingTimer -= 100;
              }
              if(standing && standstillTimer++ >= standstillTime) {
                standing = false;
                standstillTimer -= standstillTime;
              }
              if(reloading && reloadTimer++ >= reloadTime) {
                standing = false;
                reloading = false;
                reloadTimer -= reloadTime;
                bullets = maxBullets;
              }
              if(puddleTimer >= 100) {
                leavePuddle();
                puddleTimer -= 100;
              }
              if(jumpingTimer >= 100) {
                jump();
                jumpingTimer = 0;
              }
              if(bossAttackTimer >= 100) {
                bossAttack();
                bossAttackTimer -= 100;
              }
              if(randomMovementTimer >= 100) {
                dx = random(-1, 1);
                dy = random(-1, 1);
                randomMovementTimer -= 100;
                randomMovementRate = random(.2, 2);
              }
              if(following) {
                dx = (is.player.x-x)/(Math.abs(is.player.x-x) + Math.abs(is.player.y-y));
                dy = (is.player.y-y)/(Math.abs(is.player.x-x) + Math.abs(is.player.y-y));
                if(Math.abs(dy) >= Math.abs(dx)) {
                  facingX = 0;
                  if(dy > 0) {
                    facingY = 1;
                  } else {
                    facingY = -1;
                  }
                } else {
                  facingY = 0;
                  if(dx > 0) {
                    facingX = 1;
                  } else {
                    facingX = -1;
                  }
                }
              }
            } else {
              if(airborneTimer++ >= airborneTime) {
                airborneTimer = 0;
                jumping = false;
                switch(type) {
                  case 3:
                    shoot(5);
                    break;
                  case 10:
                    shoot(8);
                    break;
                  default:
                }
              }
            }
            if(bossAttacking && bossAttackDurationTimer++ <= bossAttackDuration) {
              switch(type) {
                case 30:
                  switch(bossAttackType) {
                    case 0:
                      gumsBreatheIn();
                      break;
                    case 1:
                      gumsCough(8, 16);
                      break;
                    case 2:
                      bossAttackDuration = 750;
                      gumsScream(projectileAmount, screamGap);
                      break;
                    case 3:
                      gumsQuiver();
                      break;
                    case 4:
                      gumsRetch();
                      break;
                    default:
                  }
                  break;
                default:
              }
            } else {
              switch(type) {
                case 30:
                  projectileAmount = int(random(12, 17));
                  screamGap = int(random(projectileAmount/3, (2*projectileAmount/3)+1));
                  break;
                default:
              }
              bossAttackDurationTimer = 0;
              bossAttacking = false;
            }
            if(!standing) {
              x += dx*speed;
              y += dy*speed;
            }
            switch(type) {
              case 21:
                for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
                  if(e.type == 20) {
                    if(!e.dead) {
                      if(Math.sqrt(Math.pow(Math.abs(x - e.x), 2) + Math.pow(Math.abs(y - e.y), 2)) > r*7) {
                        setX(x + Math.signum(e.x - x));
                        setY(y + Math.signum(e.y - y));
                      }
                    } else {
                      phase = 1;
                      fireRate = 0;
                      speed = baseSpeed*5;
                      knockbackEfficiency = 3;
                    }
                  }
                }
                break;
              case 30:
                int teeth = 0;
                for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
                  if((e.type == 31 && !e.corpse) ||
                     (e.type == 32 && !e.corpse) ||
                     (e.type == 33 && !e.corpse) ||
                     (e.type == 34 && !e.corpse) ||
                     (e.type == 35 && !e.corpse) ||
                     (e.type == 36 && !e.corpse)) {
                    teeth++;
                  }
                }
                dead = (teeth <= 0);
                break;
              default:
            }
            if(!(type == 30)) {
              if(x <= (r + is.borderWidth)) {
                x = (r + is.borderWidth);
                dx *= -1;
                facingX *= -1;
              } else if(x >= width - (r + is.borderWidth)) {
                x = width - (r + is.borderWidth);
                dx *= -1;
                facingX *= -1;
              }
              if(y <= (r + is.borderWidth)) {
                y = (r + is.borderWidth);
                dy *= -1;
                facingY *= -1;
              } else if(y >= height - (r + is.borderWidth)) {
                y = height - (r + is.borderWidth);
                dy *= -1;
                facingY *= -1;
              }
            }
          } else {
            if(revivalTimer++ >= revivalTime) {
              switch(type) {
                case 7:
                  maxHp *= .7;
                  break;
                default:
              }
              hp = maxHp;
              revivalTimer = 0;
              reviving = false;
            }
          }
        } else {
          switch(type) {
            case 31:
            case 32:
            case 33:
            case 34:
            case 35:
            case 36:
              for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
                if(e.type == 30 && e.dead) {
                  leavesCorpse = false;
                  corpse = false;
                  dead = true;
                }
              }
              break;
            default:
          }
        }
        if(intersects(is.player)) is.player.hit(1);
      }
      for(int i = 0; i >= 0 && i < enemyProjectiles.size(); i++) {
        if(i >= 0 && enemyProjectiles.get(i).intersects(is.player)) {
          is.player.hit(projectileDamage);
          enemyProjectiles.remove(i);
          i--;
        }
        if(i >= 0 && enemyProjectiles.get(i).update()) {
          enemyProjectiles.remove(i);
          i--;
        }
      }
      for(int i = 0; i >= 0 && i < enemyPuddles.size(); i++) {
        if(i >= 0 && enemyPuddles.get(i).intersects(is.player)) {
          is.player.hit(puddleDamage);
        }
        if(i >= 0 && enemyPuddles.get(i).update()) {
          enemyPuddles.remove(i);
          i--;
        }
      }
    if(dead) deathTime--;
    }
    return (deathTime < 0);
  }

  void shoot() {
    enemyProjectiles.add(new IsaacProjectile(x + facingX*r, y + facingY*r, facingX, facingY, projectileSpeed, projectileTime,
                                             projectileSize, projectileDamage, projectileKnockback, projectileBounce));
    if(maxBullets > 0 && bullets-- <= 0) {
      reload();
    }
  }
  
  void shootRandom() {
    enemyProjectiles.add(new IsaacProjectile(x, y, Math.toRadians(random(0, 360)), projectileSpeed, projectileTime, projectileSize,
                                             projectileDamage, projectileKnockback, projectileBounce));
    if(maxBullets > 0 && bullets-- <= 0) {
      reload();
    }
  }

  void shoot(IsaacPlayer p) {
    enemyProjectiles.add(new IsaacProjectile(x + facingX*r, y + facingY*r, (p.x-x)/(Math.abs(p.x-x) + Math.abs(p.y-y)), (p.y-y)/(Math.abs(p.x-x) + Math.abs(p.y-y)),
      projectileSpeed, projectileTime, projectileSize, projectileDamage, projectileKnockback, projectileBounce));
    if(maxBullets > 0 && bullets-- <= 0) {
      reload();
    }
  }
  
  void shoot(float amount) {
    if(maxBullets > 0) {
      if(amount >= bullets) {
        amount = bullets;
        bullets = 0;
        reload();
      } else {
        bullets -= amount;
      }
    }
    if(amount == 1) {
      enemyProjectiles.add(new IsaacProjectile(x + facingX*r, y + facingY*r, dx, dy, projectileSpeed, projectileTime, projectileSize,
                                               projectileDamage, projectileKnockback, projectileBounce));
    } else {
      for(float i = 0; i < amount; i++) {
        enemyProjectiles.add(new IsaacProjectile(x, y, Math.toRadians(360.*(i/amount)), projectileSpeed, projectileTime, projectileSize,
                                                 projectileDamage, projectileKnockback, projectileBounce));
      }
    }
  }
  
  void shoot(float amount, float x, float y, float delay) {
    if(maxBullets > 0) {
      if(amount >= bullets) {
        amount = bullets;
        bullets = 0;
        reload();
      } else {
        bullets -= amount;
      }
    }
    if(amount == 1) {
      enemyProjectiles.add(new IsaacProjectile(x, y, dx, dy, projectileSpeed, projectileTime, projectileSize, projectileDamage, projectileKnockback, projectileBounce));
      enemyProjectiles.get(enemyProjectiles.size()-1).setDelayTime(delay);
    } else {
      for(float i = 0; i < amount; i++) {
        enemyProjectiles.add(new IsaacProjectile(x, y, Math.toRadians(360.*(i/amount)), projectileSpeed, projectileTime, projectileSize,
                                                 projectileDamage, projectileKnockback, projectileBounce));
        enemyProjectiles.get(enemyProjectiles.size()-1).setDelayTime(delay);
      }
    }
  }
  
  void reload() {
    reloading = true;
    standing = true;
    standstillTime = reloadTime;
  }
  
  void spawnEnemy(int id, int amount, float x, float y) {
    for(int i = 0; i < amount; i++) {
      is.getCurrentMap().getCurrentRoom().enemyList.add(new IsaacEnemy(id, x, y));
    }
  }
  
  void leavePuddle() {
    enemyPuddles.add(new IsaacPuddle(x - r, y - r, puddleWidth, puddleHeight, puddleTime, puddleDamage));
  }
  
  void leavePuddle(float x, float y) {
    enemyPuddles.add(new IsaacPuddle(x, y, puddleWidth, puddleHeight, puddleTime, puddleDamage));
  }
  
  void leavePuddle(float x, float y, float pWidth, float pHeight, float pTime) {
    enemyPuddles.add(new IsaacPuddle(x, y, pWidth, pHeight, pTime, puddleDamage));
  }
  
  void gravity(IsaacPlayer player, float strength) {
    player.dx += strength*Math.signum(x + r - player.x);
    player.dy += strength*Math.signum(y - player.y);
  }
  
  void gumsBreatheIn() {
    gravity(is.player, 2);
    switch(int(bossAttackDurationTimer%50)) {
      case 0:
        enemyProjectiles.add(new IsaacProjectile(random(height*.11, width-height*.11), height*.89, x+r, y, projectileSpeed, projectileSize,
                                                 projectileDamage, projectileKnockback, projectileBounce));
        break;
      case 25:
        enemyProjectiles.add(new IsaacProjectile(height*.11 + ((width-2.0*height*.11)*int(random(0,2))), random(height*.2, height*.89), x+r, y,
                                                 projectileSpeed, projectileSize, projectileDamage, projectileKnockback, projectileBounce));
        break;
      default:
    }
  }
  
  void gumsCough(int minAmount, int maxAmount) {
    switch(int(bossAttackDurationTimer%150)) {
      case 10:
        for(int i = 0; i <= int(random(minAmount, maxAmount)); i++) {
          enemyProjectiles.add(new IsaacProjectile(x + r, height*.11, Math.toRadians(int(random(30, 151))), random(.5, 1.5)*projectileSpeed,
                                                   projectileTime, projectileSize, projectileDamage, projectileKnockback, projectileBounce));
        }
        for(int j = -1; j < 2; j++) {
          leavePuddle(x+w*.4+(j*w*.2), y+h, w*.2, w*.2, 100);
        }
        break;
      case 20:
        for(int j = -1; j < 2; j++) {
          leavePuddle(x+w*.4+(j*random(-w*.2, w*.2)), y+h+w*.2, w*.2, w*.2, 100);
        }
        break;
      case 30:
        for(int j = -1; j < 2; j++) {
          leavePuddle(x+w*.4+(j*random(-w*.4, w*.4)), y+h+(w*.2*2), w*.2, w*.2, 100);
        }
        break;
      case 40:
        for(int j = -1; j < 2; j++) {
          leavePuddle(x+w*.4+(j*random(-w*.6, w*.6)), y+h+(w*.2*3), w*.2, w*.2, 100);
        }
        break;
      case 50:
        for(int j = -1; j < 2; j++) {
          leavePuddle(x+w*.4+(j*random(-w*.8, w*.8)), y+h+(w*.2*4), w*.2, w*.2, 100);
        }
        break;
      default:
    }
  }
  
  void gumsScream(int amount, int gap) {
    if(bossAttackDurationTimer%75 == 0) {
      for(int i = 0; i <= amount; i++) {
        if(!(i==gap)) enemyProjectiles.add(new IsaacProjectile(x + r, height*.11, Math.toRadians(i*180/amount), projectileSpeed*.8, projectileTime,
                                                               projectileSize, projectileDamage, projectileKnockback, projectileBounce));
      }
    }
  }
  
  void gumsQuiver() {
    is.getCurrentMap().getCurrentRoom().setOffSet(random(-5, 5), random(-5, 5));
    if(bossAttackDurationTimer%100 == 0) {
      float xPos = random(height*.11, width-height*.1);
      float yPos = random(height*.11, height*.9);
      boolean overlap;
      do {
        overlap = false;
        for(IsaacObstacle o : is.getCurrentMap().getCurrentRoom().obstacleList) {
          while(xPos + width*.05 > o.x && xPos - width*.05 < o.x + o.w && yPos + width*.05 > o.y && yPos - width*.05 < o.y + o.h) {
            overlap = true;
            xPos = random(height*.11, width-height*.1);
            yPos = random(height*.11, height*.9);
          }
        }
      } while (overlap);
      spawnEnemy(int(random(31, 37)), 1, xPos, yPos);
      is.getCurrentMap().getCurrentRoom().enemyList.get(
      is.getCurrentMap().getCurrentRoom().enemyList.size()-1).fall();
      shoot(6, xPos, yPos, airborneTime*.5);
    }
  }
  
  void gumsRetch() {
    if(bossAttackDurationTimer%200 == 0) {
      spawnEnemy(7, 1, x+r, height*.1);
    }
  }
  
  void fall() {
    jumping = true;
    airborneTimer = airborneTime*.5;
  }

  void hit(IsaacProjectile p) {
    hp -= p.getDamage();
    x += p.getKnockback()*p.getDx()*knockbackEfficiency;
    y += p.getKnockback()*p.getDy()*knockbackEfficiency;
    if(shootsWhenHit) shootRandom();
    if(puddleWhenHit) leavePuddle(x + (random(-1.5, 1.5)*w), y + (random(-1.5, 1.5)*w));
    if(hp <= 0) {
      if(revives && !reviving) {
        hp = maxHp;
        reviving = true;
      } else {
        if(explodesOnDeath) shoot(6);
        if(spawnsOnDeath) spawnEnemy(deathSpawn, deathSpawnAmount, x, y);
        if(leavesCorpse) {
          switch(type) {
            case 31:
            case 32:
            case 33:
            case 34:
            case 35:
            case 36:
              this.flyable = true;
              break;
            default:
          }
          corpse = true;
        } else {
          dead = true;
        }
      }
    }
  }

  void hit(IsaacBeam b) {
    hp -= b.getDamage();
    x += b.getKnockback()*b.getDx()*knockbackEfficiency;
    y += b.getKnockback()*b.getDy()*knockbackEfficiency;
    if(hp <= 0) {
      if(revives && !reviving) {
        hp = maxHp;
        reviving = true;
      } else {
        if(explodesOnDeath) shoot(6);
        if(spawnsOnDeath) spawnEnemy(deathSpawn, deathSpawnAmount, x, y);
        if(leavesCorpse) {
          switch(type) {
            case 31:
            case 32:
            case 33:
            case 34:
            case 35:
            case 36:
              this.flyable = true;
              break;
            default:
          }
          corpse = true;
        } else {
          dead = true;
        }
      }
    }
  }
  
  void hit(IsaacBomb bo) {
    hp -= bo.getDamage();
    if(hp <= 0) {
      if(revives && !reviving) {
        hp = maxHp;
        reviving = true;
      } else {
        if(explodesOnDeath) shoot(6);
        if(spawnsOnDeath) spawnEnemy(deathSpawn, deathSpawnAmount, x, y);
        if(leavesCorpse) {
          switch(type) {
            case 31:
            case 32:
            case 33:
            case 34:
            case 35:
            case 36:
              this.flyable = true;
              break;
            default:
          }
          corpse = true;
        } else {
          dead = true;
        }
      }
    }
  }
  
  void bossAttack() {
    int oldAttackType = bossAttackType;
    bossAttacking = true;
    bossAttackDuration = random(800, 1000);
    bossAttackType = int(random(0, bossAttackAmount));
    if(oldAttackType == bossAttackType) bossAttack();
  }
  
  void setTimeStopped(boolean timeStopped) {
    this.timeStopped = timeStopped;
  }
  
  void stand() {
    standing = true;
  }
  
  void jump() {
    jumping = true;
  }

  void turnAround() {
    dx *= -1;
    dy *= -1;
    facingX *= -1;
    facingY *= -1;
  }
  
  void turnAroundX() {
    dx *= -1;
    facingX *= -1;
  }
  
  void turnAroundY() {
    dy *= -1;
    facingY *= -1;
  }

  void setFireRate(int fireRate) {
    this.fireRate = fireRate;
  }

  void setX(float x) {
    this.x = x;
  }

  void setY(float y) {
    this.y = y;
  }
  
  void setPosition(float x, float y) {
    this.x = x;
    this.y = y;
  }

  float getR() {
    return r;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }

  void collision(IsaacObstacle o) {
    if(following) {
      if(o.intersectsR(this)) {
        setX(o.x + o.w + r);
      } else if(o.intersectsL(this)) {
        setX(o.x - r);
      } else if(o.intersectsU(this)) {
        setY(o.y - r);
      } else if(o.intersectsD(this)) {
        setY(o.y + o.h + r);
      } else {
        if(dx < 0) {
          setX(o.x - r);
        } else {
          setX(o.x + o.w + r);
        }
      }
    } else {
      if(o.intersectsR(this)) {
        setX(o.x + o.w + r);
        turnAroundX();
      } else if(o.intersectsL(this)) {
        setX(o.x - r);
        turnAroundX();
      } else if(o.intersectsU(this)) {
        setY(o.y - r);
        turnAroundY();
      } else if(o.intersectsD(this)) {
        setY(o.y + o.h + r);
        turnAroundY();
      } else {
        if(dx < 0) {
          setX(o.x - r);
        } else {
          setX(o.x + o.w + r);
        }
      }
    }
  }

  boolean intersects(IsaacPlayer player) {
    return !(flyable && player.flying) && !dead && !noContactDamage && !jumping && player.r + r >= sqrt(pow((player.x - x), 2) + pow((player.y - y), 2));
  }

  boolean intersects(IsaacProjectile projectile) {
    return !corpse && !dead && !untargetable && !jumping && projectile.r + r*1.05 >= sqrt(pow((projectile.x - x), 2) + pow((projectile.y - y), 2));
  }

  boolean intersects(IsaacBeam beam) {
    return !corpse && !dead && !untargetable && !jumping && x - r < beam.x + beam.w && x + r > beam.x && y - r < beam.y + beam.h && y + r > beam.y;
  }

  boolean intersects(IsaacBomb bomb) {
    return !corpse && !dead && !untargetable && !jumping && bomb.exploding && (bomb.explosionTime == 1) &&  (r + bomb.explosionR >= sqrt(pow((bomb.x - x), 2) + pow((bomb.y - y), 2)));
  }

  boolean intersects(IsaacObstacle obstacle) {
    return x - r < obstacle.x + obstacle.w && x + r > obstacle.x && y - r < obstacle.y + obstacle.h && y + r > obstacle.y;
  }
}
