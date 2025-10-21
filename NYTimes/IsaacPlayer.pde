public class IsaacPlayer {
  
  float x, y;
  float w, r;
  float speed;
  color clr = #FF0000;
  int[] moveKeys = new int[4];
  int[] facingKeys = new int[4];
  int facingX, facingY;                                                      //x=-1:left; x=1:right; y=-1:up; y=1:down
  ArrayList<IsaacProjectile> playerProjectiles = new ArrayList<IsaacProjectile>();
  ArrayList<IsaacBeam> playerBeams = new ArrayList<IsaacBeam>();
  ArrayList<IsaacFamiliar> playerFamiliars = new ArrayList<IsaacFamiliar>();
  float shootTimer;                                                          //timer to know when to shoot projectiles
  float fireRate;                                                            //controls rate at which projectiles are fired
  float projectileSpeed;                                                     //how fast projectiles fly
  float projectileTime;                                                      //how long projectiles stay
  float projectileDamage;
  float projectileKnockback, beamKnockback;
  boolean projectileFollowing;                                               //whether projectiles follow enemies
  IsaacEnemy target;                                                         //enemy to be targeted by projectiles
  int maxLives;
  int lives;
  int bombs;
  int keys;                                                                  //for chests/closed doors
  boolean invulnerable;
  boolean projectileBounce;
  boolean flying;                                                            //whether player can fly over flyable enemies/obstacles/puddles
  float invulnerableTimer;                                                   //timer to check invulnerability
  float defaultInvulnerabilityTime;                                          //time how long player stays invulberable after being hit
  float invulnerabilityTime;
  float projectileSize, beamWidth, explosionWidth;
  float beamTime;                                                            //how long the beam stays
  int projectileStyle;                                                       //0 = shoot projectiles, 1 = charge attacks
  boolean charging, shooting;
  float maxCharge, charge, chargeRate;
  int id;                                                                    //0 = Bocchi, 1 = Ryou, 2 = Kita, 3 = Nijika
  PImage playerIcon, playerIconLeft, playerIconRight, playerIconBack;
  
  public IsaacPlayer(int id) {
    this.id = id;
    switch(id) {
      case 0:
        playerIcon = bocchiIcon;
        playerIconLeft = bocchiIconLeft;
        playerIconRight = bocchiIconRight;
        playerIconBack = bocchiIconBack;
        setBgm(0);
        break;
      case 1:
        playerIcon = ryouIcon;
        playerIconLeft = ryouIconLeft;
        playerIconRight = ryouIconRight;
        playerIconBack = ryouIconBack;
        setBgm(1);
        break;
      case 2:
        playerIcon = kitaIcon;
        playerIconLeft = kitaIconLeft;
        playerIconRight = kitaIconRight;
        playerIconBack = kitaIconBack;
        setBgm(2);
        break;
      case 3:
        playerIcon = nijikaIcon;
        playerIconLeft = nijikaIconLeft;
        playerIconRight = nijikaIconRight;
        playerIconBack = nijikaIconBack;
        setBgm(3);
        break;
      default:
        playerIcon = bocchiIcon;
        playerIconLeft = bocchiIconLeft;
        playerIconRight = bocchiIconRight;
        playerIconBack = bocchiIconBack;
        setBgm(0);
    }
    this.x = width*.5;
    this.y = height*.5;
    this.w = width*.05;
    this.r = w*.5;
    this.speed = 5;
    this.facingY = 1;
    this.fireRate = 1;
    this.projectileSpeed = 7;
    this.projectileTime = 70;
    this.projectileDamage = 50;
    this.projectileKnockback = 10;
    this.beamKnockback = .2;
    this.maxLives = 10;
    this.lives = maxLives;
    this.bombs = 99;
    this.keys = 9;
    this.invulnerable = false;
    this.defaultInvulnerabilityTime = 120;
    this.invulnerabilityTime = defaultInvulnerabilityTime;
    this.flying = true;
    this.projectileSize = r;
    this.explosionWidth = w*4.;
    this.projectileFollowing = true;
    this.beamWidth = w;
    this.beamTime = FPS*.5;
    this.maxCharge = 50;
    this.chargeRate = .5;
  }
  
  void init() {
    x = width*.5;
    y = height*.5;
    playerProjectiles.clear();
    shootTimer = 0;
    invulnerabilityTime = defaultInvulnerabilityTime;
    charge = 0;
  }
  
  void display() {
    pushStyle();
    fill(#000000, 70);
    noStroke();
    circle(x+w*.05, y+w*.05, w*1.1);
    stroke(#000000);
    fill(clr);
    imageMode(CENTER);
    if(invulnerable) tint(255, 127);
    if(facingX == -1) {
      image(playerIconLeft, x, y, 2*w, 2*w);
    } else if(facingX == 1) {
      image(playerIconRight, x, y, 2*w, 2*w);
    } else if(facingY == -1) {
      image(playerIconBack, x, y, 2*w, 2*w);
    } else {
      image(playerIcon, x, y, 2*w, 2*w);
    }
    for(IsaacFamiliar f : playerFamiliars) {
      f.display();
    }
    if(projectileStyle == 1) {
      rect(x+r, y-r, map(charge, 0, maxCharge, 0, 50), 10);
    }
    for(IsaacBeam b : playerBeams) {
      b.display();
    }
    for(IsaacProjectile p : playerProjectiles) {
      p.display();
    }
    fill(#FFFFFF, 1);
    noStroke();
    circle(x, y, w*10);
    stroke(#000000);
    for(int i = 0; i < maxLives; i++) {
      if(i < lives) {
        fill(#FF0000);
        circle(width*.075 + i*width*.04, height*.075, width*.03);
      } else {
        fill(#FF0000, 50);
        circle(width*.075 + i*width*.04, height*.075, width*.03);
      }
    }
    fill(#000000);
    circle(width*.075, height*.125, width*.03);
    fill(#FFFFFF);
    text("x " + bombs, width*.11, height*.125);
    fill(#FFFFFF);
    text("KEYS", width*.075, height*.175);
    text("x " + keys, width*.11, height*.175);
    popStyle();
  }
  
  void update() {
    if(facingKeys[0] == -1) {
      facingX = 0;
      facingY = -1;
    } else if(facingKeys[1] == 1) {
      facingX = 0;
      facingY = 1;
    } else if(facingKeys[2] == 1) {
      facingX = 1;
      facingY = 0;
    } else if(facingKeys[3] == -1) {
      facingX = -1;
      facingY = 0;
    }
    if(invulnerable) {
      clr = #793E3E;
      if(++invulnerableTimer >= invulnerabilityTime) {
        invulnerableTimer = 0;
        invulnerabilityTime = defaultInvulnerabilityTime;
        invulnerable = false;
        clr = #FF0000;
      }
    }
    switch(projectileStyle) {
      case 0:
        if(shooting) {
          shootTimer += fireRate;
          if(shootTimer >= 100) {
            target = null;
            if(projectileFollowing) {
              float minX = width*width;
              float minY = height*height;
              for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
                if(!e.dead && !e.corpse && !e.jumping && !e.untargetable) {
                  if((float)Math.pow(e.x - x, 2) + (float)Math.pow(e.y - y, 2) < minX + minY) {
                    minX = (float)Math.pow(e.x - x, 2);
                    minY = (float)Math.pow(e.y - y, 2);
                    target = e;
                  }
                }
              }
            }
            shootProjectile(target);
            shootTimer -= 100;
          }
        }
        break;
      case 1:
        if(charging && charge < maxCharge) {
          charge += chargeRate;
        }
        break;
      default:
    }
    for(int i = 0; i < playerProjectiles.size(); i++) {
      if(playerProjectiles.get(i).update()) {
        playerProjectiles.remove(i);
        i--;
      }
    }
    for(int j = 0; j < playerBeams.size(); j++) {
      if(playerBeams.get(j).update()) {
        playerBeams.remove(j);
        j--;
      }
    }
    x += (moveKeys[2] + moveKeys[3])*speed;
    y += (moveKeys[0] + moveKeys[1])*speed;
    if (x <= r + is.borderWidth) {
      x = r + is.borderWidth;
    } else if (x >= width - (r + is.borderWidth)) {
      x = width - (r + is.borderWidth);
    }
    if (y <= r + is.borderWidth) {
      y = r + is.borderWidth;
    } else if (y >= height - (r + is.borderWidth)) {
      y = height - (r + is.borderWidth);
    }
    for(IsaacFamiliar f : playerFamiliars) {
      f.update(this);
    }
    if(playerFamiliars.size() >= 3 && bgm != bgms.get(5)) {
      setBgm(5);
    }
  }
  
  void setId(int id) {
    this.id = id;
    switch(id) {
      case 0:
        playerIcon = bocchiIcon;
        playerIconLeft = bocchiIconLeft;
        playerIconRight = bocchiIconRight;
        playerIconBack = bocchiIconBack;
        setBgm(0);
        break;
      case 1:
        playerIcon = ryouIcon;
        playerIconLeft = ryouIconLeft;
        playerIconRight = ryouIconRight;
        playerIconBack = ryouIconBack;
        setBgm(1);
        break;
      case 2:
        playerIcon = kitaIcon;
        playerIconLeft = kitaIconLeft;
        playerIconRight = kitaIconRight;
        playerIconBack = kitaIconBack;
        setBgm(2);
        break;
      case 3:
        playerIcon = nijikaIcon;
        playerIconLeft = nijikaIconLeft;
        playerIconRight = nijikaIconRight;
        playerIconBack = nijikaIconBack;
        setBgm(3);
        break;
      default:
        playerIcon = bocchiIcon;
        playerIconLeft = bocchiIconLeft;
        playerIconRight = bocchiIconRight;
        playerIconBack = bocchiIconBack;
        setBgm(0);
    }
  }
  
  void changeStyle() {
    if(projectileStyle == 0) {
      projectileStyle = 1;
    } else {
      projectileStyle = 0;
    }
  }
  
  void changeId() {
    setId((id+1)%4);
  }
  
  void shootProjectile() {
    playerProjectiles.add(new IsaacProjectile(x, y, facingX, facingY, projectileSpeed, projectileTime, projectileSize,
                                              projectileDamage, projectileKnockback, projectileBounce));
  }
  
  void shootProjectile(float amount) {
    for(float i = 0; i < amount; i++) {
      playerProjectiles.add(new IsaacProjectile(x, y, Math.toRadians(360.*(i/amount)), projectileSpeed, projectileTime, projectileSize,
                                                projectileDamage, projectileKnockback, projectileBounce));
    }
  }
    
  void shootProjectile(IsaacEnemy e) {
    if(e != null) {
      playerProjectiles.add(new IsaacProjectile(x + facingX*r, y + facingY*r, (e.x-x)/(Math.abs(e.x-x) + Math.abs(e.y-y)), (e.y-y)/(Math.abs(e.x-x) + Math.abs(e.y-y)),
        projectileSpeed, projectileTime, projectileSize, projectileDamage, projectileKnockback, projectileFollowing, e, projectileBounce));
    } else {
      shootProjectile();
    }
  }
  
  void addFamiliar(int id, int position) {
    playerFamiliars.add(new IsaacFamiliar(this, id, position));
  }
  
  void addFamiliar() {
    if(playerFamiliars.size() < 3) {
      playerFamiliars.add(new IsaacFamiliar(this, (id + 1 + playerFamiliars.size())%4, playerFamiliars.size()));
    }
  }
  
  void setFlying(boolean flying) {
    this.flying = flying;
  }
  
  void fireRateUp() {
    fireRate += 2;
    for(IsaacFamiliar f : playerFamiliars) {
      f.fireRateUp();
    }
    chargeRate += .1;
  }
  
  void speedUp() {
    speed += .2;
  }
  
  void projectileSizeUp() {
    projectileSize += 10;
    beamWidth += 10;
    for(IsaacFamiliar f : playerFamiliars) {
      f.projectileSizeUp();
    }
  }
    
  void setFireRate(int fireRate) {
    this.fireRate = fireRate;
  }
  
  void setSpeed(int speed) {
    this.speed = speed;
  }
  
  void setX(float x) {
    this.x = x;
  }
  
  void setY(float y) {
    this.y = y;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  float getR() {
    return r;
  }
  
  boolean getInvulnerable() {
    return invulnerable;
  }
  
  boolean getFlying() {
    return flying;
  }
  
  void invulnerable(float invulnerabilityTime) {
    this.invulnerabilityTime = invulnerabilityTime;
    invulnerable = true;
  }
  
  void hit(int damage) {
    if(!invulnerable) {
      lives -= damage;
      invulnerable = true;
      if(lives <= 0) {
        lives = maxLives;
        init();
      }
    }
  }
  
  void shoot() {
    switch(projectileStyle) {
      case 0:
        shooting = true;
        break;
      case 1:
        charging = true;
        break;
      default:
    }
  }
  
  void shootBeam() {
    playerBeams.add(new IsaacBeam(x, y, beamWidth, height*.4, facingX, facingY, beamTime, charge, beamKnockback));
    charge = 0;
  }
  
  void placeBomb() {
    is.getCurrentMap().getCurrentRoom().bombList.add(new IsaacBomb(x, y, w, explosionWidth, 200, 100));
    bombs--;
  }
  
  void removeKey() {
    keys--;
  }
  
  void resetMovement() {
    moveKeys[0] = 0;
    moveKeys[1] = 0;
    moveKeys[2] = 0;
    moveKeys[3] = 0;
  }
    
  
  void setMovement(int k) {
    switch (k) {
      case 87:                              //W
        moveKeys[0] = -1;
        facingX = 0;
        facingY = -1;
        break;
      case 38:                              //Arrow Up
        facingKeys[0] = -1;
        shoot();
        break;
      case 83:                              //S
        moveKeys[1] = 1;
        facingX = 0;
        facingY = 1;
        break;
      case 40:                              //Arrow Down
        facingKeys[1] = 1;
        shoot();
        break;
      case 68:                              //D
        moveKeys[2] = 1;
        facingY = 0;
        facingX = 1;
        break;
      case 39:                              //Arrow Right
        facingKeys[2] = 1;
        shoot();
        break;
      case 65:                              //A
        moveKeys[3] = -1;
        facingY = 0;
        facingX = -1;
        break;
      case 37:                              //Arrow Left
        facingKeys[3] = -1;
        shoot();
        break;
      default:
    }
  }
  
  void stopMovement(int k) {
    switch (k) {
      case 87:                              //W
        moveKeys[0] = 0;
        if(moveKeys[2] != 0) {
          facingY = 0;
          facingX = 1;
        } else if(moveKeys[1] != 0) {
          facingY = 1;
          facingX = 0;
        } else if(moveKeys[3] != 0) {
          facingY = 0;
          facingX = -1;
        }
        break;
      case 38:                              //Arrow Up
        facingKeys[0] = 0;
        if(facingKeys[1] == 0 && facingKeys[2] == 0 && facingKeys[3] == 0) {
          if(charging) {
            facingX = 0;
            facingY = -1;
            shootBeam();
            charging = false;
          }
          shooting = false;
        }
        break;
      case 83:                              //S
        moveKeys[1] = 0;
        if(moveKeys[0] != 0) {
          facingY = -1;
          facingX = 0;
        } else if(moveKeys[2] != 0) {
          facingY = 0;
          facingX = 1;
        } else if(moveKeys[3] != 0) {
          facingY = 0;
          facingX = -1;
        }
        break;
      case 40:                              //Arrow Down
        facingKeys[1] = 0;
        if(facingKeys[0] == 0 && facingKeys[2] == 0 && facingKeys[3] == 0) {
          if(charging) {
            facingX = 0;
            facingY = 1;
            shootBeam();
            charging = false;
          }
          shooting = false;
        }
        break;
      case 68:                              //D
        moveKeys[2] = 0;
        if(moveKeys[0] != 0) {
          facingY = -1;
          facingX = 0;
        } else if(moveKeys[1] != 0) {
          facingY = 1;
          facingX = 0;
        } else if(moveKeys[3] != 0) {
          facingY = 0;
          facingX = -1;
        }
        break;
      case 39:                              //Arrow Right
        facingKeys[2] = 0;
        if(facingKeys[0] == 0 && facingKeys[1] == 0 && facingKeys[3] == 0) {
          if(charging) {
            facingX = 1;
            facingY = 0;
            shootBeam();
            charging = false;
          }
          shooting = false;
        }
        break;
      case 65:                              //A
        moveKeys[3] = 0;
        if(moveKeys[0] != 0) {
          facingY = -1;
          facingX = 0;
        } else if(moveKeys[1] != 0) {
          facingY = 1;
          facingX = 0;
        } else if(moveKeys[2] != 0) {
          facingY = 0;
          facingX = 1;
        }
        break;
      case 37:                              //Arrow Left
        facingKeys[3] = 0;
        if(facingKeys[0] == 0 && facingKeys[1] == 0 && facingKeys[2] == 0) {
          if(charging) {
            facingX = -1;
            facingY = 0;
            shootBeam();
            charging = false;
          }
          shooting = false;
        }
        break;
      default:
    }
  }
  
  void pressKey(int k){
    //if(k == 32 && projectileStyle == 1) {
      //if(!charging) {
        //shoot();
      //}
    //} else {
    if(k == 16 && bombs > 0) placeBomb();
    setMovement(k);
    //}
  }
  
  void releaseKey(int k){
    //if(k == 32 && projectileStyle == 1) {
      //if(charging) {
        //shootBeam();
        //charging = false;
      //}
    //} else {
      stopMovement(k);
    //}
  }
  
  public class IsaacFamiliar {
    
    float x, y;
    float w, r;
    int id;
    int position;
    color clr = #FFFFFF;
    int facingX, facingY;         
    float shootTimer;                                                            //timer to know when to shoot projectiles
    float fireRate;                                                              //controls rate at which projectiles are fired
    float projectileSpeed;                                                       //how fast projectiles fly
    float projectileTime;                                                        //how long projectiles stay
    float projectileSize;
    float projectileDamage;
    float projectileKnockback;
    boolean projectileFollowing;                                                 //whether the projectiles follow enemies
    boolean autoShooting;                                                        //whether familiar automatically shoots or only when player is shooting/charging
    IsaacEnemy target;                                                           //enemy to be targeted by projectiles
    PImage familiarIcon, familiarIconLeft, familiarIconRight, familiarIconBack;
    
    public IsaacFamiliar(IsaacPlayer p, int id, int position) {
      this.id = id;
      switch(id) {
        case 0:
          familiarIcon = bocchiIcon;
          familiarIconLeft = bocchiIconLeft;
          familiarIconRight = bocchiIconRight;
          familiarIconBack = bocchiIconBack;
          break;
        case 1:
          familiarIcon = ryouIcon;
          familiarIconLeft = ryouIconLeft;
          familiarIconRight = ryouIconRight;
          familiarIconBack = ryouIconBack;
          break;
        case 2:
          familiarIcon = kitaIcon;
          familiarIconLeft = kitaIconLeft;
          familiarIconRight = kitaIconRight;
          familiarIconBack = kitaIconBack;
          break;
        case 3:
          familiarIcon = nijikaIcon;
          familiarIconLeft = nijikaIconLeft;
          familiarIconRight = nijikaIconRight;
          familiarIconBack = nijikaIconBack;
          break;
        default:
          familiarIcon = bocchiIconBack;
          familiarIconLeft = bocchiIconBack;
          familiarIconRight = bocchiIconBack;
          familiarIconBack = bocchiIconBack;
      }
      this.facingX = p.facingX;
      this.facingY = p.facingY;
      this.w = p.w;
      this.r = w*.5;
      this.position = position;
      if(p.playerFamiliars.isEmpty()) {
        this.shootTimer = p.shootTimer;
      } else {
        this.shootTimer = p.playerFamiliars.get(0).shootTimer;
      }
      switch(position) {
        case 0:
          this.x = p.x - facingX*(p.r + w*.25);
          this.y = p.y + facingY*(p.r + w*.25);
          break;
        case 1:
          this.x = p.x + facingX*(p.r + w*.25);
          this.y = p.y - facingY*(p.r + w*.25);
          break;
        case 2:
          this.x = p.x - facingX*(p.r + w*.25);
          this.y = p.y - facingY*(p.r + w*.25);
          break;
        default:
      }
      this.fireRate = p.fireRate*.5;
      this.projectileSpeed = p.projectileSpeed;
      this.projectileTime = p.projectileTime;
      this.projectileSize = p.projectileSize*.5;
      this.projectileDamage = p.projectileDamage*.5;
      this.projectileKnockback = p.projectileKnockback*.1;
      this.projectileFollowing = true;
    }
    
    void display() {
      pushStyle();
      fill(clr);
      imageMode(CENTER);
      if(facingX == -1) {
        image(familiarIconLeft, x, y, w, w);
      } else if(facingX == 1) {
        image(familiarIconRight, x, y, w, w);
      } else if(facingY == -1) {
        image(familiarIconBack, x, y, w, w);
      } else {
        image(familiarIcon, x, y, w, w);
      }
      popStyle();
    }
    
    void update(IsaacPlayer p) {
      this.facingX = p.facingX;
      this.facingY = p.facingY;
      switch(position) {
        case 0:
          this.x = p.x + facingY*(p.r + w*.25);
          this.y = p.y - facingX*(p.r + w*.25);
          break;
        case 1:
          this.x = p.x - facingY*(p.r + w*.25);
          this.y = p.y + facingX*(p.r + w*.25);
          break;
        case 2:
          this.x = p.x - facingX*(p.r + w*.25);
          this.y = p.y - facingY*(p.r + w*.25);
          break;
        default:
      }
      if(p.shooting || p.charging || autoShooting) {
        shootTimer += fireRate;
        if(shootTimer >= 100) {
          target = null;
          if(projectileFollowing) {
            float minX = width*width;
            float minY = height*height;
            for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
              if(!e.dead && !e.corpse && !e.jumping && !e.untargetable) {
                if((float)Math.pow(e.x - x, 2) + (float)Math.pow(e.y - y, 2) < minX + minY) {
                  minX = (float)Math.pow(e.x - x, 2);
                  minY = (float)Math.pow(e.y - y, 2);
                  target = e;
                }
              }
            }
          }
          shoot(p, target);
          shootTimer -= 100;
        }
      }
    }
    
    void shoot(IsaacPlayer p) {
      p.playerProjectiles.add(new IsaacProjectile(x, y, facingX, facingY, projectileSpeed, projectileTime, projectileSize, projectileDamage,
                                                  projectileKnockback, projectileBounce));
    }
    
    void shoot(IsaacPlayer p, IsaacEnemy e) {
      if(e != null) {
        p.playerProjectiles.add(new IsaacProjectile(x + facingX*r, y + facingY*r, (e.x-x)/(Math.abs(e.x-x) + Math.abs(e.y-y)), (e.y-y)/(Math.abs(e.x-x) + Math.abs(e.y-y)),
          projectileSpeed, projectileTime, projectileSize, projectileDamage, projectileKnockback, projectileFollowing, e, projectileBounce));
      } else {
        shoot(p);
      }
    }
    
    void fireRateUp() {
      fireRate += 1;
    }
    
    void projectileSizeUp() {
      projectileSize += 5;
    }
  }
}
