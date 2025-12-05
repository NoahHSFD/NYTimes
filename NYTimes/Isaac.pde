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
    try {
      isMap = loadJSONArray("/Maps/Map3.json");
      rooms = new JSONObject[isMap.size()];
      for(int i = 0; i < isMap.size(); i++) {
        rooms[i] = isMap.getJSONObject(i);
      }
      map = new IsaacMap(rooms);
      maps.add(map);
    } catch(Exception e) {
      println(e + "\n Can't find Isaac map 3.");
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
        state = playAnimation(600);
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
        player.calcDXDY();
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
  
  IsaacMap getCurrentMap() {
    return maps.get(currentMap);
  }
  
  void setCurrentMap(int currentMap) {
    this.currentMap = currentMap;
  }
  
  GameState playAnimation(int len) {
    player.charging = false;
    player.charge = 0;
    pushStyle();
    PImage plIcon = bocchiMenu.get(0);
    PImage boIcon = gums;
    String plName = "BOBBY";
    String boName = "GUMS";
    switch(player.id) {
      case 0:
        plName = "BOBBY";
        plIcon = bocchiMenu.get(0);
        break;
      case 1:
        plName = "RYOU";
        plIcon = ryouMenu.get(0);
        break;
      case 2:
        plName = "KITA";
        plIcon = kitaMenu.get(0);
        break;
      case 3:
        plName = "NIJIKA";
        plIcon = nijikaMenu.get(0);
        break;
      default:
    }
    for(IsaacEnemy e : getCurrentMap().getCurrentRoom().enemyList) {
      switch(e.type) {
        case 10:
          boName = "MONSTRO";
          boIcon = ryouIconBack;
          break;
        case 20:
          boName = "GEMINI";
          boIcon = nijikaIconRight;
          break;
        case 30:
          boName = "GUMS";
          boIcon = gums;
          break;
        case 40:
          boName = "JHON";
          boIcon = jhon;
          break;
        case 50:
          boName = "PRONOUNS";
          boIcon = loadingScreen;
          break;
        default:
      }
    }
    background(#000000);
    fill(#675252);
    noStroke();
    ellipse(((animationTimer <= len*.3) ? map(animationTimer, 0, len*.3, height*-3, width*.1) : width*.1) + height*.2, height*.85, height*.45, height*.15);
    image(plIcon, (animationTimer <= len*.3) ? map(animationTimer, 0, len*.3, height*-3, width*.1) : width*.1, height*.5, height*.4, height*.4);
    ellipse(((animationTimer <= len*.3) ? map(animationTimer, 0, len*.3, width+height*3, width*.9-height*.4) :
                                          width*.9-height*.4) + height*.2, height*.75, height*.45, height*.15);
    image(boIcon, (animationTimer <= len*.3) ? map(animationTimer, 0, len*.3, width+height*3, width*.9-height*.4) :
                                                      width*.9-height*.4, height*.6, height*.4, height*.2);
    textSize(height*.1);
    fill(#FFFFFF);
    text(plName, (animationTimer <= len*.4) ? map(animationTimer, len*.2, len*.4, height*-2, width*.1+height*.2) : width*.1+height*.2, height*.25);
    text("VS", width*.5, (animationTimer >= len*.4) && (animationTimer <= len*.5) ? map(animationTimer, len*.4, len*.5, height*-1, height*.25) :
                                                                                    (animationTimer < len*.4) ? height*-1 : height*.25);
    text(boName, (animationTimer >= len*.4) && (animationTimer <= len*.6) ? map(animationTimer, len*.4, len*.6, width+height*2, width*.9-height*.2) :
                                                                          (animationTimer < len*.4) ? width+height*2 : width*.9-height*.2, height*.25);
    popStyle();
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
