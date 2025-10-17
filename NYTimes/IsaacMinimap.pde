public class IsaacMinimap {
  
  float x, y;
  float w, h;
  int[][] rooms;
  int roomsAmount;
  IsaacMinimapTile[] minimapTiles;
  
  public IsaacMinimap(JSONObject[] rooms, float mapWidth, float mapHeight) {
    roomsAmount = 0;
    for(JSONObject r : rooms) {
      roomsAmount++;
    }
    minimapTiles = new IsaacMinimapTile[roomsAmount];
    for(int i = 0; i < roomsAmount; i++) {
      minimapTiles[i] = new IsaacMinimapTile(rooms[i].getIntList("coordinates").get(0), rooms[i].getIntList("coordinates").get(1), 
                                             mapWidth, mapHeight);
    }
  }
  
  void setCurrentRoom(int x, int y) {
    for(IsaacMinimapTile t : minimapTiles) {
      t.setCurrentRoom(false);
      if(t.getX() == x && t.getY() == y) {
        t.setCurrentRoom(true);
      }
    }
  }
  
  void unlockMinimapRoom(int x, int y) {
    for(IsaacMinimapTile t : minimapTiles) {
      if(t.getX() == x && t.getY() == y) {
        t.setUnlocked(true);
      }
    }
  }
  
  void display() {
    for(IsaacMinimapTile t : minimapTiles) {
      t.display();
    }
  }
  
  void update() {
    for(IsaacMinimapTile t : minimapTiles) {
      t.update();
    }
  }
  
  class IsaacMinimapTile {
    
    int x, y;
    float w, h;
    color clr = #FE00FF;
    boolean currentRoom = false;
    boolean unlocked = false;
    float mapWidth;
    
    public IsaacMinimapTile(int x, int y, float mapWidth, float mapHeight) {
      this.x = x;
      this.y = y;
      this.w = (width/3.0)/mapWidth;
      this.h = (height/3.0)/mapHeight;
      this.mapWidth = mapWidth;
    }
    
    void display() {
      if(unlocked) {
        pushStyle();
        fill(clr, 75);
        rect(mapX(x), mapY(y), w, h);
        popStyle();
      }
    }
    
    void update() {
      if(currentRoom) {
        clr = #FF0051;
      } else {
        clr = #FE00FF;
      }
    }
    
    void setCurrentRoom(boolean currentRoom) {
      this.currentRoom = currentRoom;
    }
    
    void setUnlocked(boolean unlocked) {
      this.unlocked = unlocked;
    }
    
    boolean getCurrentRoom() {
      return currentRoom;
    }
    
    int getX() {
      return x;
    }
    
    int getY() {
      return y;
    }
    
    float mapX(int x) {
      return width*(2.0/3.0) + (x*w) - (width*.015);
    }
    
    float mapY(int y) {
      return (y*h) + (height*.015);
    }
  }
}
