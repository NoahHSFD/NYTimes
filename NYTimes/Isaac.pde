public class Isaac {

  ArrayList<IsaacMap> maps = new ArrayList<IsaacMap>();
  IsaacMap map;
  int currentMap;
  IsaacPlayer player;
  JSONArray isMap;
  JSONObject[] rooms;
  float borderWidth;
  float curseChance;                                                           //chance for a floor to be cursed
  int curse;                                                                   //which curse is applied to the floor
  int animationTimer;                                                          //timer for animations on screen
  GameState state;
  IsaacPause isP;
  ArrayList<Slider> isaacVolumeSliders = new ArrayList<Slider>();              //0: master, 1: bgm, 2: player sounds, 3: enemy sounds, 4: sfx
  PImage curseOverlay;
  
  public Isaac(int id) {
    this.borderWidth = height*.1;
    isP = new IsaacPause();
    isaacVolumeSliders.add(new Slider(width*.2, height*.4, width*.1, height*.3, "ismaster"));
    isaacVolumeSliders.add(new Slider(width*.325, height*.4, width*.1, height*.3, "isbgm"));
    isaacVolumeSliders.add(new Slider(width*.45, height*.4, width*.1, height*.3, "isplayer"));
    isaacVolumeSliders.add(new Slider(width*.575, height*.4, width*.1, height*.3, "isenemy"));
    isaacVolumeSliders.add(new Slider(width*.7, height*.4, width*.1, height*.3, "issfx"));
    this.curseOverlay = overlays.get(0);
    try {
      isMap = loadJSONArray("/Maps/Map1.json");
      rooms = new JSONObject[isMap.size()];
      for(int i = 0; i < isMap.size(); i++) {
        rooms[i] = isMap.getJSONObject(i);
      }
      map = new IsaacMap(rooms);
      maps.add(map);
    } catch(Exception e) {
      println(e + "\nCan't find Isaac map 1.");
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
      println(e + "\nCan't find Isaac map 2.");
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
      println(e + "\nCan't find Isaac map 3.");
    }
    this.curseChance = (1./2.);
    this.curse = -1;
    this.currentMap = 0;
    this.player = new IsaacPlayer(id);
    this.state = GameState.PLAYING;
  }
  
  void init() {
    if(random(0., 1.) <= curseChance) {
      curse = int(random(0, 6));
      //0: anvil falls when entering a new room
      //1: overlay
    }
    player.init();
  }
  
  void display() {
    //background(#554646);
    maps.get(currentMap).display();
    player.display();
    for(IsaacObstacle o : maps.get(currentMap).getCurrentRoom().obstacleList) {
      if(o.falling) o.display();
    }
    for(IsaacEnemy e : maps.get(currentMap).getCurrentRoom().enemyList) {
      if(e.jumping) e.display();
    }
    maps.get(currentMap).minimap.display();
    if(curse == 1) image(curseOverlay, 0, 0, width, height);
    switch(state) {
      case ANIMATION:
        state = playAnimation(600);
        break;
      case DEFEAT:
        state = showDefeatScreen();
        break;
      case CREDITS:
        state = rollCredits();
        break;
      case PAUSED:
        state = pause();
        break;
      default:
    }
    text(curse, width*.95, height*.95);
  }
  
  void update() {
    switch(state) {
      case PLAYING:
        player.calcDXDY();
        maps.get(currentMap).update();
        player.update();
        break;
      case PAUSED:
        isP.update();
        break;
      default:
    }
    if(!isaacVolumeSliders.get(0).getMuted()) {
      try {
        if(!isaacVolumeSliders.get(1).getMuted()) {
          try {
            bgm.amp(isaacVolumeSliders.get(0).setVolume()*isaacVolumeSliders.get(1).setVolume());
          } catch(Exception e) {
            println(e + "\nCan't set BGM volume.");
          }
        } else {
          try {
            bgm.amp(0.0);
          } catch(Exception e) {
            println(e + "\nCan't mute BGM volume.");
          }
        }
        if(!isaacVolumeSliders.get(2).getMuted()) {
          try {
            for(SoundFile f : playerSounds) {
              f.amp(isaacVolumeSliders.get(0).setVolume()*isaacVolumeSliders.get(2).setVolume());
            }
          } catch(Exception e) {
            println(e + "\nCan't set player sound volume.");
          }
        } else {
          try {
            for(SoundFile f : playerSounds) {
              f.amp(0.0);
            }
          } catch(Exception e) {
            println(e + "\nCan't mute player sound volume.");
          }
        }
        if(!isaacVolumeSliders.get(3).getMuted()) {
          try {
            for(SoundFile f : enemySounds) {
              f.amp(isaacVolumeSliders.get(0).setVolume()*2.*isaacVolumeSliders.get(3).setVolume());
            }
          } catch(Exception e) {
            println(e + "\nCan't set enemy sound volume.");
          }
        } else {
          try {
            for(SoundFile f : enemySounds) {
              f.amp(0.0);
            }
          } catch(Exception e) {
            println(e + "\nCan't mute enemy sound volume.");
          }
        }
        if(!isaacVolumeSliders.get(4).getMuted()) {
          try {
            for(SoundFile f : sfx) {
              f.amp(isaacVolumeSliders.get(0).setVolume()*isaacVolumeSliders.get(4).setVolume());
            }
          } catch(Exception e) {
            println(e + "\nCan't set SFX volume.");
          }
        } else {
          try {
            for(SoundFile f : sfx) {
              f.amp(0.0);
            }
          } catch(Exception e) {
            println(e + "\nCan't mute SFX volume.");
          }
        }
        try {
          for(SoundFile f : quizMusic) {
            f.amp(isaacVolumeSliders.get(0).setVolume()*isaacVolumeSliders.get(1).setVolume());
          }
        } catch(Exception e) {
          println(e + "\nCan't set quiz music volume.");
        }
      } catch(Exception e) {
        println(e + "\nCan't set volume.");
      }
    } else {
      try {
        bgm.amp(0.0);
        for(SoundFile f : playerSounds) {
          f.amp(0.0);
        }
        for(SoundFile f : enemySounds) {
          f.amp(0.0);
        }
        for(SoundFile f : sfx) {
          f.amp(0.0);
        }
      } catch(Exception e) {
        println(e + "\nCan't mute volume.");
      }
    }
    for(Slider s : isaacVolumeSliders) {
      s.update();
      s.display();
    }
  }
  
  void pressKey(int k) {
    //if(keyCode == ENTER) state = GameState.ANIMATION;
    switch(state) {
      case PLAYING:
        player.pressKey(k);
        if(k == -1) {
          player.resetMovement();
          state = GameState.PAUSED;
        }
        break;
      case PAUSED:
        isP.pressKey(k);
        break;
      default:
    }
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
  
  GameState pause() {
    isP.display();
    return GameState.PAUSED;
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
        case -1:
          boName = "MONSTRO";
          boIcon = ryouIconBack;
          break;
        case -2:
          boName = "GEMINI";
          boIcon = nijikaIconRight;
          break;
        case -3:
          boName = "GUMS";
          boIcon = gums;
          break;
        case -4:
          boName = "JHON";
          boIcon = jhon;
          break;
        case -5:
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
  
  GameState rollCredits() {
    return GameState.CREDITS;
  }
  
  void clickChecks() {
    switch(state) {
      case PAUSED:
        isP.clickChecks();
        break;
      default:
    }
  }
  
  void clicks() {
    switch(state) {
      case PAUSED:
        isP.clicks();
        break;
      default:
    }
  }
}
