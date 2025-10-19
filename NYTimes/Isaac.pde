public class Isaac {

  ArrayList<IsaacMap> maps = new ArrayList<IsaacMap>();
  IsaacMap map;
  int currentMap;
  IsaacPlayer player;
  JSONArray isMap;
  JSONObject[] rooms;
  float borderWidth;
  int animationTimer;                                                          //timer for animations on screen
  GameState state;
  
  public Isaac(int id) {
    borderWidth = height*.1;
    try {
      isMap = loadJSONArray("/Maps/Map1.json");
      rooms = new JSONObject[isMap.size()];
      for(int i = 0; i < isMap.size(); i++) {
        rooms[i] = isMap.getJSONObject(i);
      }
      map = new IsaacMap(rooms);
      maps.add(map);
    } catch(Exception e) {
      println(e + "\n Can't find Isaac map 1.");
    }
    try {
      isMap = loadJSONArray("/Maps/Map2.json");
      rooms = new JSONObject[isMap.size()];
      for(int i = 0; i < isMap.size(); i++) {
        rooms[i] = isMap.getJSONObject(i);
      }
      map = new IsaacMap(rooms);
      maps.add(map);
    } catch(Exception e) {
      println(e + "\n Can't find Isaac map 2.");
    }
    currentMap = 0;
    player = new IsaacPlayer(id);
    state = GameState.PLAYING;
  }
  
  void init() {
    player.init();
    player.setFireRate(2);
    player.setSpeed(5);
  }
  
  void display() {
    //background(#554646);
    maps.get(currentMap).display();
    player.display();
    maps.get(currentMap).minimap.display();
    switch(state) {
      case ANIMATION:
        state = playAnimation(500);
        break;
      case DEFEAT:
        state = showDefeatScreen();
        break;
      default:
    }
  }
  
  void update() {
    switch(state) {
      case PLAYING:
        maps.get(currentMap).update();
        player.update();
        break;
      default:
    }
  }
  
  void pressKey(int k) {
    if(keyCode == ENTER) state = GameState.ANIMATION;
    if(state == GameState.PLAYING) player.pressKey(k);
  }
  
  void releaseKey(int k) {
    player.releaseKey(k);
  }
  
  int getCurrentMap() {
    return currentMap;
  }
  
  void setCurrentMap(int currentMap) {
    this.currentMap = currentMap;
  }
  
  GameState playAnimation(int len) {
    player.charging = false;
    player.charge = 0;
    switch(player.id) {
      case 0:
        background(#000000);
        image(bocchiMenu.get(0), (animationTimer <= len*.3) ? map(animationTimer, 0, len*.3, height*-.4, width*.1) : width*.1, height*.5, height*.4, height*.4);
        image(loadingScreen, (animationTimer >= len*.3) && (animationTimer <= len*.6) ? map(animationTimer, len*.3, len*.6, width+(height*.4), width*.9-height*.4) :
                             (animationTimer < len*.3) ? width + height*.4 : width*.9-height*.4, height*.5, height*.4, height*.4);
        break;
      case 1:
        image(ryouMenu.get(((animationTimer/14)%8)), width/4., height/4., width/2., height/2.);
        break;
      case 2:
        image(kitaMenu.get((animationTimer/14)%7), width/4., height/4., width/2., height/2.);
        break;
      case 3:
        image(nijikaMenu.get((animationTimer/12)%18), width/4., height/4., width/2., height/2.);
        break;
      default:
        pushStyle();
        textSize(animationTimer%99 + 1);
        text("no animation :(", width/2., height/2.);
        popStyle();
    }
    if(animationTimer++ <= len) return GameState.ANIMATION;
    animationTimer = 0;
    return GameState.PLAYING;
  }
  
  GameState showDefeatScreen() {
    pushStyle();
    fill(#FF0000);
    textSize(200);
    text("YOU DIED", width/2., height/2.);
    popStyle();
    return GameState.DEFEAT;
  }
}
