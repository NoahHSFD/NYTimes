public class IsaacMap {
  
  IsaacRoom[][] rooms;
  int currentRoomX, currentRoomY;
  float mapWidth, mapHeight;                                                    //highest X value of the map for minimap display purposes
  IsaacMinimap minimap;
  color clr = #00FFFF;
  JSONObject[] roomData;
  
  public IsaacMap(JSONObject[] rooms) {
    roomData = rooms;
    mapWidth = 0;
    mapHeight = 0;
    for(int i = 0; i < rooms.length; i++) {
      if(rooms[i].getIntList("coordinates").get(0) > mapWidth) mapWidth = rooms[i].getIntList("coordinates").get(0);
      if(rooms[i].getIntList("coordinates").get(1) > mapHeight) mapHeight = rooms[i].getIntList("coordinates").get(1);
    }
    mapWidth++;
    mapHeight++;
    this.rooms = new IsaacRoom[int(mapWidth)][int(mapHeight++)];
    for(int i = 0; i < this.rooms.length; i++) {
      for(int j = 0; j < this.rooms[i].length; j++) {
        this.rooms[i][j] = new IsaacRoom(i, j);
      }
    }
    for(int i = 0; i < rooms.length; i++) {
      this.rooms[rooms[i].getIntList("coordinates").get(0)][rooms[i].getIntList("coordinates").get(1)].setDoors(rooms[i].getIntList("doors").toArray());
      this.rooms[rooms[i].getIntList("coordinates").get(0)][rooms[i].getIntList("coordinates").get(1)].setDestructibleDoors(rooms[i].getIntList("destructibledoors").toArray());
      this.rooms[rooms[i].getIntList("coordinates").get(0)][rooms[i].getIntList("coordinates").get(1)].setEnemies(rooms[i].getIntList("enemies").toArray());
      this.rooms[rooms[i].getIntList("coordinates").get(0)][rooms[i].getIntList("coordinates").get(1)].setCollectibles(rooms[i].getIntList("collectibles").toArray());
      this.rooms[rooms[i].getIntList("coordinates").get(0)][rooms[i].getIntList("coordinates").get(1)].setType(rooms[i].getString("type"));
      this.rooms[rooms[i].getIntList("coordinates").get(0)][rooms[i].getIntList("coordinates").get(1)].setLayout(rooms[i].getInt("layout"));
    }
    minimap = new IsaacMinimap(rooms, mapWidth, mapHeight);
    currentRoomX = rooms[0].getIntList("coordinates").get(0);
    currentRoomY = rooms[0].getIntList("coordinates").get(1);
    minimap.setCurrentRoom(currentRoomX, currentRoomY);
    minimap.unlockMinimapRoom(currentRoomX, currentRoomY);
  }
  
  void init() {
    currentRoomX = roomData[0].getIntList("coordinates").get(0);
    currentRoomY = roomData[0].getIntList("coordinates").get(1);
    minimap.setCurrentRoom(currentRoomX, currentRoomY);
  }
  
  void display() {
    rooms[currentRoomX][currentRoomY].display();
  }
  
  void update() {
    rooms[currentRoomX][currentRoomY].update();
    minimap.update();
  }
  
  IsaacRoom getCurrentRoom() {
    return rooms[currentRoomX][currentRoomY];
  }
  
  class IsaacRoom {
  
    int x, y;
    float offSetX, offSetY;                                                                //to move the screen around (e.g. for screen shake)
    color clr = #554646;
    IsaacDoor[] doors;
    ArrayList<IsaacEnemy> enemyList = new ArrayList<IsaacEnemy>();
    ArrayList<IsaacBomb> bombList = new ArrayList<IsaacBomb>();
    ArrayList<IsaacCollectible> collectibleList = new ArrayList<IsaacCollectible>();
    ArrayList<IsaacObstacle> obstacleList = new ArrayList<IsaacObstacle>();
    ArrayList<IsaacChest> chestList = new ArrayList<IsaacChest>();
    PImage backgroundSprite;
    int type;                                                                              //0: normal room, 1: boss room, 2: store
    boolean timeStopped;                                                                   //whether enemies and projectiles in the room are timestopped
    
    public IsaacRoom(int x, int y) {
      this.x = x;
      this.y = y;
      //chestList.add(new IsaacChest(width*.2, height*.2, 0));
      backgroundSprite = backgrounds.get(0);
    }
    
    void setDoors(int[] d) {
      this.doors = new IsaacDoor[d.length];
      int ind = 0;
      for(int i : d) {
        doors[ind++] = new IsaacDoor(i);
      }
    }
    
    void setDestructibleDoors(int[] des) {
      for(int i : des) {
        for(IsaacDoor door : doors) {
          if(door.position == i) door.setDestructible();
        }
      }
    }
    
    void setEnemies(int[] e) {
      for(int i : e) {
        enemyList.add(new IsaacEnemy(i, random(height*.11, width-height*.1), random(height*.11, height*.9)));
        switch(i) {
          case -2:
            enemyList.add(new IsaacEnemy(-21, random(height*.11, width-height*.1), random(height*.11, width-height*.1)));
            break;
          case -3:
            enemyList.add(new IsaacEnemy(-31, random(height*.11, width-height*.1), random(height*.11, width-height*.1)));
            enemyList.add(new IsaacEnemy(-32, random(height*.11, width-height*.1), random(height*.11, width-height*.1)));
            enemyList.add(new IsaacEnemy(-33, random(height*.11, width-height*.1), random(height*.11, width-height*.1)));
            enemyList.add(new IsaacEnemy(-34, random(height*.11, width-height*.1), random(height*.11, width-height*.1)));
            enemyList.add(new IsaacEnemy(-35, random(height*.11, width-height*.1), random(height*.11, width-height*.1)));
            enemyList.add(new IsaacEnemy(-36, random(height*.11, width-height*.1), random(height*.11, width-height*.1)));
            break;
          case -5:
            enemyList.add(new IsaacEnemy(-51, 0, 0));
            enemyList.add(new IsaacEnemy(-52, 0, 0));
            enemyList.add(new IsaacEnemy(-530, 0, 0));
            enemyList.add(new IsaacEnemy(-531, 0, 0));
            enemyList.add(new IsaacEnemy(-532, 0, 0));
            enemyList.add(new IsaacEnemy(-533, 0, 0));
            enemyList.add(new IsaacEnemy(-540, 0, 0));
            enemyList.add(new IsaacEnemy(-541, 0, 0));
            enemyList.add(new IsaacEnemy(-542, 0, 0));
            enemyList.add(new IsaacEnemy(-543, 0, 0));
            break;
          default:
        }
      }
    }
    
    void setCollectibles(int[] c) {
      for(int i : c) {
        collectibleList.add(new IsaacCollectible(i));
      }
    }
    
    void setType(String type) {
      if(type.equals("normal")) {
        this.type = 0;
        backgroundSprite = backgrounds.get(0);
      } else if(type.equals("boss")) {
        this.type = 1;
        backgroundSprite = backgrounds.get(1);
      } else if(type.equals("store")){
        this.type = 2;
      } else {
        this.type = 0;
      }
    }
    
    void setLayout(int layout) {
      switch(layout) {
        case 0:
          obstacleList.add(new IsaacObstacle(width*.2, height*.25, width*.2, height*.15, 0));
          break;
        case 1:
          obstacleList.add(new IsaacObstacle(width*.2, height*.25, width*.2, height*.15, 1));
          obstacleList.add(new IsaacObstacle(width*.2, height*.6, width*.1, height*.1, 1));
          obstacleList.add(new IsaacObstacle(width*.5, height*.8, width*.1, height*.1, 1));
          obstacleList.add(new IsaacObstacle(width*.7, height*.6, width*.1, height*.1, 1));
          break;
        case 2:
          obstacleList.add(new IsaacObstacle(width*.2, height*.25, width*.2, height*.15, 1));
          break;
        default:
      }
    }
    
    void setTimeStopped(boolean timeStopped) {
      this.timeStopped = timeStopped;
    }
    
    void setOffSet(float offSetX, float offSetY) {
      this.offSetX = offSetX;
      this.offSetY = offSetY;
    }
    
    void display() {
      pushStyle();
      image(backgroundSprite, offSetX, offSetY, width, height);
      for(IsaacEnemy e : enemyList) {
        for(IsaacPuddle pu : e.enemyPuddles) {
          pu.display();
        }
      }
      for(IsaacObstacle o : obstacleList) {
        o.display();
      }
      for(IsaacDoor d : doors) {
        d.display();
      }
      for(IsaacChest ch : chestList) {
        ch.display();
      }
      for(IsaacEnemy e : enemyList) {
        e.display();
      }
      for(IsaacEnemy e : enemyList) {
        e.displayHpBar();
      }
      for(IsaacBomb bo : bombList) {
        bo.display();
      }
      for(IsaacCollectible c : collectibleList) {
        c.display();
      }
      for(IsaacEnemy e : enemyList) {
        for(IsaacProjectile p : e.enemyProjectiles) {
          p.display();
        }
      }
      for(IsaacObstacle o : obstacleList) {
        if(o.falling) o.display();
      }
      popStyle();
    }
    
    void update() {
      for(IsaacDoor d : doors) {
        if(type == 1) {
          for(IsaacEnemy e : enemyList) {
            if(!e.dead) {
              d.close();
              break;
            }
            if(!d.destructible && !d.locked) d.open();
            //todo:
            //for some reason sometimes doors dont open after all enemies are defeated
          }
          if(enemyList.isEmpty() && !d.destructible && !d.locked) d.open();
        }
        d.update();
      }
      for(int i = 0; i < bombList.size(); i++) {
        if(bombList.get(i).update()) {
          bombList.remove(i);
          i--;
        }
      }
      for(int i = 0; i < chestList.size(); i++) {
        if(chestList.get(i).update()) {
          //chestList.remove(i);
          //i--;
        }
      }
      for(int i = 0; i < enemyList.size(); i++) {
        enemyList.get(i).setTimeStopped(timeStopped);
        for(IsaacObstacle o : obstacleList) {
          if(!(o.falling || (enemyList.get(i).flying && o.traversible))) {
            if(enemyList.get(i).intersects(o) && !(enemyList.get(i).jumping) && !(enemyList.get(i).ignoresObstacles)) {
              enemyList.get(i).collision(o);
            }
          }
        }
        for(int j = 0; i >= 0 && j < is.player.playerProjectiles.size(); j++) {
          if(enemyList.get(i).intersects(is.player.playerProjectiles.get(j))) {
            enemyList.get(i).hit(is.player.playerProjectiles.get(j));
            is.player.playerProjectiles.remove(j);
            j--;
          }
        }
        for(int j = 0; i >= 0 && j < is.player.playerBeams.size(); j++) {
          if(enemyList.get(i).intersects(is.player.playerBeams.get(j))) {
            enemyList.get(i).hit(is.player.playerBeams.get(j));
          }
        }
        for(int k = 0; i >= 0 && k < bombList.size(); k++) {
          if(enemyList.get(i).intersects(bombList.get(k))) {
            enemyList.get(i).hit(bombList.get(k));
          }
        }
        if(i >= 0 && enemyList.get(i).update() && !enemyList.get(i).leavesCorpse) {
          enemyList.remove(i);
          i--;
        }
      }
      for(int i = 0; i >= 0 && i < obstacleList.size(); i++) {
        IsaacObstacle o = obstacleList.get(i);
        o.update();
        for(int j = 0; j >= 0 && j < is.player.playerProjectiles.size(); j++) {
          if(o.intersects(is.player.playerProjectiles.get(j))) {
            is.player.playerProjectiles.remove(j);
            j--;
          }
        }
        for(IsaacEnemy e : enemyList) {
          for(int k = 0; k >= 0 && k < e.enemyProjectiles.size(); k++) {
            if(o.intersects(e.enemyProjectiles.get(k))) {
              e.enemyProjectiles.remove(k);
              k--;
            }
          }
        }
        for(IsaacBomb b : bombList) {
          if(o.intersects(b) && o.destructible) {
            obstacleList.remove(o);
            i--;
          }
        }
      }
      for(IsaacCollectible c : collectibleList) {
        if(c.update()) {
          collectibleList.remove(c);
          break;
        }
      }
    }
    
    void damageAllEnemies(int damage) {
      for(int i = 0; i < enemyList.size(); i++) {
        enemyList.get(i).damage(damage);
        if(i >= 0 && enemyList.get(i).update() && !enemyList.get(i).leavesCorpse) {
          enemyList.remove(i);
          i--;
        }
      }
    }
    
    class IsaacDoor {
    
      float x, y;
      float w = height*.21;
      float h = height*.21;
      color clr = #FFFF00;
      int position;                                                             //0 = top, 1 = right, 2 = bottom, 3 = left,4 = middle
      boolean open;
      boolean destructible;                                                     //whether it can be opened with a bomb
      boolean locked;                                                           //whether it can be opened with a key
      boolean unlocking;                                                        //whether it is currently being unlocked
      float unlockTimer;                                                        //timer to check when door is unlocked after being opened with a key
                                                                                //so that player doesnt instantly enter a door when unlocking it
      
      public IsaacDoor(float x, float y) {
        this.x = x;
        this.y = y;
      }
      
      public IsaacDoor(int position) {
        this.position = position;
        switch(position) {
          case 0:                                                              //top
            this.x = width*.5;
            this.y = 0;
            this.w = height*.1;
            this.h = height*.21;
            this.open = true;
            break;
          case 1:                                                              //right
            this.x = width;
            this.y = height*.5;
            this.w = height*.21;
            this.h = height*.1;
            this.open = true;
            break; 
          case 2:                                                              //bottom
            this.x = width*.5;
            this.y = height;
            this.w = height*.1;
            this.h = height*.21;
            this.open = true;
            break;
          case 3:                                                              //left
            this.x = 0;
            this.y = height*.5;
            this.w = height*.21;
            this.h = height*.1;
            this.open = true;
            break;
          case 4:                                                              //middle
            this.x = width*.5;
            this.y = height*.5;
            this.w = height*.1;
            this.h = height*.1;
            break;
          default:
        }
      }
      
      void display() {
        pushStyle();
        if(open) {
          fill(clr);
        } else {
          fill(#FF0000);
        }
        rectMode(CENTER);
        rect(x, y, w, h);
        fill(#000000);
        text(type + " " + enemyList.isEmpty() + " " + open, x + w, y);
        popStyle();
      }
      
      void update() {
        for(IsaacBomb bo : bombList) {
          if(intersects(bo) && destructible) destroy();
        }
        if(intersects(is.player) && locked && !unlocking && is.player.keys > 0) unlock();
        if(unlocking && unlockTimer++ >= 100) open();
        if(intersects(is.player) && open) {
          switchRoom();
          is.player.invulnerable(FPS*.75);
          minimap.setCurrentRoom(currentRoomX, currentRoomY);
          minimap.unlockMinimapRoom(currentRoomX, currentRoomY);
          is.player.playerProjectiles.clear();
        }
      }
      
      boolean intersects(IsaacPlayer player) {                                //different calculation because of rectMode(CENTER) in display()
        return x - w*.5 < player.x + player.r && x + w*.5 > player.x - player.r && y - h*.5 < player.y + player.r && y + h*.5 > player.y - player.r;
      }
      
      boolean intersects(IsaacBomb bomb) {
        return bomb.exploding && (bomb.explosionTime == 1) &&  (x-w*.5 < bomb.x + bomb.explosionR && x + w*.5 > bomb.x - bomb.explosionR &&
               y - h*.5 < bomb.y + bomb.explosionR && y + h*.5 > bomb.y - bomb.explosionR);
      }
      
      void lock() {
        open = false;
        locked = true;
        switch(position) {
          case 0:
            for(IsaacDoor d : rooms[currentRoomX][currentRoomY-1].doors) {
              if(d.position == 2) {
                d.open = false;
                d.locked = true;
              }
            }
            break;
          case 1:
            for(IsaacDoor d : rooms[currentRoomX+1][currentRoomY].doors) {
              if(d.position == 3) {
                d.open = false;
                d.locked = true;
              }
            }
            break;
          case 2:
            for(IsaacDoor d : rooms[currentRoomX][currentRoomY+1].doors) {
              if(d.position == 0) {
                d.open = false;
                d.locked = true;
              }
            }
            break;
          case 3:
            for(IsaacDoor d : rooms[currentRoomX-1][currentRoomY].doors) {
              if(d.position == 1) {
                d.open = false;
                d.locked = true;
              }
            }
            break;
          default:
        }
      }
      
      void unlock() {
        is.player.removeKey();
        unlocking = true;
        switch(position) {
          case 0:
            for(IsaacDoor d : rooms[currentRoomX][currentRoomY-1].doors) {
              if(d.position == 2) d.open();
            }
            break;
          case 1:
            for(IsaacDoor d : rooms[currentRoomX+1][currentRoomY].doors) {
              if(d.position == 3) d.open();
            }
            break;
          case 2:
            for(IsaacDoor d : rooms[currentRoomX][currentRoomY+1].doors) {
              if(d.position == 0) d.open();
            }
            break;
          case 3:
            for(IsaacDoor d : rooms[currentRoomX-1][currentRoomY].doors) {
              if(d.position == 1) d.open();
            }
            break;
          default:
        }
      }
      
      void destroy() {
        open();
        locked = false;
        switch(position) {
          case 0:
            for(IsaacDoor d : rooms[currentRoomX][currentRoomY-1].doors) {
              if(d.position == 2) d.open();
            }
            break;
          case 1:
            for(IsaacDoor d : rooms[currentRoomX+1][currentRoomY].doors) {
              if(d.position == 3) d.open();
            }
            break;
          case 2:
            for(IsaacDoor d : rooms[currentRoomX][currentRoomY+1].doors) {
              if(d.position == 0) d.open();
            }
            break;
          case 3:
            for(IsaacDoor d : rooms[currentRoomX-1][currentRoomY].doors) {
              if(d.position == 1) d.open();
            }
            break;
          default:
        }
      }
      
      void setDestructible() {
        destructible = true;
        open = false;
      }
      
      int getPosition() {
        return position;
      }
      
      void open() {
        open = true;
      }
      
      void close() {
        open = false;
      }
      
      void switchRoom() {
        for(IsaacEnemy e : enemyList) {
          if(e.dead) {
            e.enemyProjectiles.clear();
            e.enemyPuddles.clear();
          }
        }
        switch(position) {
          case 0:
            currentRoomY--;
            is.player.setY(height - (h + is.player.getR()));
            break;
          case 1:
            currentRoomX++;
            is.player.setX(w + is.player.getR());
            break;
          case 2:
            currentRoomY++;
            is.player.setY(h + is.player.getR());
            break;
          case 3:
            currentRoomX--;
            is.player.setX(width - (w + is.player.getR()));
            break;
          case 4:
            is.setCurrentMap((is.currentMap+1)%is.maps.size());
            is.getCurrentMap().init();
            break;
          default:
        }
        if(is.getCurrentMap().getCurrentRoom().type == 0) {
          is.getCurrentMap().getCurrentRoom().obstacleList.add(new IsaacObstacle(width*.4, height*.4, width*.2, height*.2, 2));
        }
        if(is.player.passiveEffects.contains(10)) is.player.bombs = 5;
        if(is.getCurrentMap().getCurrentRoom().type == 1 &&
           !is.getCurrentMap().getCurrentRoom().enemyList.isEmpty()) {
          for(IsaacEnemy e : is.getCurrentMap().getCurrentRoom().enemyList) {
            if(!e.dead) is.state = is.playAnimation(500);
          }
        }
      }
    }
  }
}
