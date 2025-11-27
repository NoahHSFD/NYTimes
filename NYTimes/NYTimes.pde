import java.util.*;
import processing.sound.*;

final int FPS = 120;
Button homeButton;
Menu men;
Wordle wor;
Strands st;
Crossword cr;
Connections co;
Screenshot sc;
Audio au;
IsaacMenu isM;
Isaac is;
ButtonID game;
Slider volume;
PFont font;
PImage bocchiIcon, bocchiIconLeft, bocchiIconRight, bocchiIconBack,
       ryouIcon, ryouIconLeft, ryouIconRight, ryouIconBack,
       kitaIcon, kitaIconLeft, kitaIconRight, kitaIconBack,
       nijikaIcon, nijikaIconLeft, nijikaIconRight, nijikaIconBack,
       loadingScreen,
       jhon, gums, 
       gumsToothHealthy, gumsToothBrittle, gumsToothBloody, gumsToothRotting, gumsToothInfested,
       gumsToothHealthyFalling, gumsToothBrittleFalling,gumsToothBloodyFalling,
       gumsToothRottingFalling, gumsToothInfestedFalling;
ArrayList<PImage> bocchiMenu = new ArrayList<PImage>();
ArrayList<PImage> ryouMenu = new ArrayList<PImage>();
ArrayList<PImage> kitaMenu = new ArrayList<PImage>();
ArrayList<PImage> nijikaMenu = new ArrayList<PImage>();
ArrayList<PImage> backgrounds = new ArrayList<PImage>();
SoundFile bgm, hitSound;
ArrayList<SoundFile> bgms = new ArrayList<SoundFile>();
NYTimes nyt;

enum ButtonID {
  MENU,
  WORDLE,
  STRANDS,
  CROSSWORD,
  CONNECTIONS,
  STRANDSRESET,
  WORDLERESET,
  CROSSWORDRESET,
  CONNECTIONSRESET,
  CONNECTIONSSHUFFLE,
  SCREENSHOT,
  SCREENSHOTRESET,
  AUDIO,
  AUDIORESET,
  AUDIOPAUSE,
  EXIT,
  ISAACMENU,
  ISAAC,
  ISAACBOCCHI,
  ISAACRYOU,
  ISAACKITA,
  ISAACNIJIKA
}

enum ConnectionsTier {
  UNSELECTED,
  YELLOW,
  GREEN,
  BLUE,
  PURPLE
}

enum GameState {
  PAUSED,
  PLAYING,
  DEFEAT,
  ANIMATION
}

void setup() {
  background(60);
  frameRate(FPS);
  font = loadFont("SegoeUIEmoji-48.vlw");
  textFont(font, 20);
  textAlign(CENTER, CENTER);
  MultiChannel.usePortAudio();
  
  nyt = this;
  loadingScreen = loadImage("/Images/Wait_Im_Loading_Wide2.png");

  game = ButtonID.MENU;
  homeButton = new Button(0, 0, width*.05, height*.025, ButtonID.MENU);
  volume = new Slider(width*.975, 0, width*.025, height*.1);
  men = new Menu();
  wor = new Wordle();
  wor.init();
  st = new Strands();
  st.init();
  cr = new Crossword();
  cr.init();
  co = new Connections();
  co.init();
  sc = new Screenshot();
  sc.init();
  au = new Audio();
  au.init();
  isM = new IsaacMenu();
  
  size(1200, 1000, P2D);
  noSmooth();
  image(loadingScreen, 0, 0, width, height);
}

void draw() {
  if(frameCount == 1) {
    try {
      loadImages();
      loadAudioFiles();
      bgm = bgms.get(4);
      bgm.loop();
      if(volume.getMuted()) bgm.amp(0.0);
      Sound.status();
    } catch(Exception e) {
      println(e + "\n Error loading audio or image files.");
    }
  }
  switch(game) {
    case MENU:
      men.update();
      men.display();
      break;
    case WORDLE:
      wor.update();
      wor.display();
      break;
    case STRANDS:
      st.update();
      st.display();
      break;
    case CROSSWORD:
      cr.update();
      cr.display();
      break;
    case CONNECTIONS:
      co.update();
      co.display();
      break;
    case SCREENSHOT:
      sc.update();
      sc.display();
      break;
    case AUDIO:
      au.update();
      au.display();
      break;
    case ISAACMENU:
      isM.update();
      isM.display();
      break;
    case ISAAC:
      is.update();
      is.display();
      break;
    default:
  }
  homeButton.update();
  homeButton.display();
  if(!volume.getMuted()) {
    try {
      bgm.amp(volume.setVolume());
      hitSound.amp(2.*volume.setVolume());
    } catch(Exception e) {
      println(e + "\n Can't set BGM volume.");
    }
  }
  volume.update();
  volume.display();
  text(round(frameRate), width*.9, height*.1);
}

void mousePressed() {
  homeButton.clickCheck();
  volume.clickCheck();
  switch(game) {
    case MENU:
      men.clickChecks();
      break;
    case WORDLE:
      wor.clickChecks();
      break;
    case STRANDS:
      st.clickChecks();
      break;
    case CROSSWORD:
      cr.clickChecks();
      break;
    case CONNECTIONS:
      co.clickChecks();
      break;
    case SCREENSHOT:
      sc.clickChecks();
      break;
    case AUDIO:
      au.clickChecks();
      break;
    case ISAACMENU:
      isM.clickChecks();
      break;
    default:
  }
}

void mouseReleased() {
  homeButton.click();
  homeButton.clickCheck();
  if(volume.mute()) {
    try {
      bgm.amp(0.0);
    } catch(Exception e) {
      println(e + "\nCan't mute BGM.");
    }
  }
  volume.clickCheck();
  switch(game) {
    case MENU:
      men.clicks();
      men.clickChecks();
      break;
    case WORDLE:
      wor.clicks();
      wor.clickChecks();
      break;
    case STRANDS:
      st.clicks();
      st.clickChecks();
      st.clickRelease();
      break;
    case CROSSWORD:
      cr.clicks();
      cr.clickChecks();
      break;
    case CONNECTIONS:
      co.clicks();
      co.clickChecks();
      break;
    case SCREENSHOT:
      sc.clicks();
      sc.clickChecks();
      break;
    case AUDIO:
      au.clicks();
      au.clickChecks();
      break;
    case ISAACMENU:
      isM.clicks();
      isM.clickChecks();
      break;
    default:
  }
}

void keyPressed() {
  if(key == ESC) {
    key = 0;
    if(game == ButtonID.ISAAC) is.player.resetMovement();
    game = ButtonID.MENU;
    if(bgm != bgms.get(4)) setBgm(4);
  }
  switch(game) {
    case WORDLE:
  //if(key == CODED) {
      if(keyCode == ENTER) {
        wor.submit();
      } else if(keyCode == BACKSPACE) {
        wor.delete();
      } else if(keyCode == LEFT) {
        wor.left();
      } else if(keyCode == RIGHT || keyCode == ' ') {
        wor.right();
      } else if(isLetter(key)) {
        wor.pressKey(key);
      }
      break;
    case CROSSWORD:
  //if(key == CODED) {
      if(keyCode == ENTER) {
        cr.submit();
      } else if(keyCode == BACKSPACE) {
        cr.delete();
      } else if(keyCode == DOWN) {
        cr.down();
      } else if(keyCode == RIGHT) {
        cr.right();
      } else if(keyCode == UP) {
        cr.up();
      } else if(keyCode == LEFT) {
        cr.left();
      } else if(isLetter(key)) {
        cr.pressKey(key);
      }
      break;
    case CONNECTIONS:
  //if(key == CODED) {
      if(keyCode == ENTER) {
        co.submitSolution();
      }
      break;
    case ISAAC:
      is.pressKey(keyCode);
      break;
    default:
  //}
  }
}

void keyReleased() {
  switch(game) {
    case ISAAC:
      is.releaseKey(keyCode);
      break;
    default:
  }
}

void setBgm(int id) {
  try {
    this.bgm.stop();
    this.bgm.removeFromCache();
    this.bgm = bgms.get(id);
    this.bgm.loop();
    if(volume.getMuted()) this.bgm.amp(0.0);
  } catch(Exception e) {
    println(e + "\n Can't change BGM.");
  }
}

boolean isLetter(char ch) {
  if(ch == 'q' || ch == 'w' ||ch == 'e' || ch == 'r' || ch == 't' || 
    ch == 'z' || ch == 'u' || ch == 'i' || ch == 'o' || ch == 'p' || 
    ch == 'a' || ch == 's' || ch == 'd' || ch == 'f' || ch == 'g' || 
    ch == 'h' || ch == 'j' || ch == 'k' || ch == 'l' || ch == 'y' || 
    ch == 'x' || ch == 'c' || ch == 'v' || ch == 'b' || ch == 'n' || 
    ch == 'm') {
      return true;
    }
  return false;
}

void loadAudioFiles() {
  bgms.add(new SoundFile(this, "/Audio/Music/Korogaru_Iwa,_Kimi_ni_Asa_ga_Furu.mp3"));
  bgms.get(0).removeFromCache();
  bgms.add(new SoundFile(this, "/Audio/Music/Kara_Kara.mp3"));
  bgms.get(1).removeFromCache();
  bgms.add(new SoundFile(this, "/Audio/Music/Distortion!!.mp3"));
  bgms.get(2).removeFromCache();
  bgms.add(new SoundFile(this, "/Audio/Music/Nani_ga_Warui.mp3"));
  bgms.get(3).removeFromCache();
  bgms.add(new SoundFile(this, "/Audio/Music/Seishun_Complex.mp3"));
  bgms.get(4).removeFromCache();
  bgms.add(new SoundFile(this, "/Audio/Music/Seiza_ni_Naretara.mp3"));
  bgms.get(5).removeFromCache();
  hitSound = new SoundFile(this, "/Audio/player_hit.mp3");
}

void loadImages() {
  bocchiIcon = loadImage("/Images/Sprites/Bocchi_Head2.png");
  bocchiIconLeft = loadImage("/Images/Sprites/Bocchi_Head_Left2.png");
  bocchiIconRight = loadImage("/Images/Sprites/Bocchi_Head_Right2.png");
  bocchiIconBack = loadImage("/Images/Sprites/Bocchi_Head_Back2.png");
  ryouIcon = loadImage("/Images/Sprites/Ryou_Head.png");
  ryouIconLeft = loadImage("/Images/Sprites/Ryou_Head_Left.png");
  ryouIconRight = loadImage("/Images/Sprites/Ryou_Head_Right.png");
  ryouIconBack = loadImage("/Images/Sprites/Ryou_Head_Back.png");
  kitaIcon = loadImage("/Images/Sprites/Kita_Head.png");
  kitaIconLeft = loadImage("/Images/Sprites/Kita_Head_Left.png");
  kitaIconRight = loadImage("/Images/Sprites/Kita_Head_Right.png");
  kitaIconBack = loadImage("/Images/Sprites/Kita_Head_Back.png");
  nijikaIcon = loadImage("/Images/Sprites/Nijika_Head.png");
  nijikaIconLeft = loadImage("/Images/Sprites/Nijika_Head_Left.png");
  nijikaIconRight = loadImage("/Images/Sprites/Nijika_Head_Right.png");
  nijikaIconBack = loadImage("/Images/Sprites/Nijika_Head_Back.png");
  bocchiMenu.add(loadImage("/Images/Sprites/Bocchi_Menu_Thumbnail.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/2Bocchi_Menu.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/2Bocchi_Menu2.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/2Bocchi_Menu3.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/2Bocchi_Menu4.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/2Bocchi_Menu5.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/2Bocchi_Menu4.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/2Bocchi_Menu3.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/2Bocchi_Menu2.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/Bocchi_Menu.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/Bocchi_Menu2.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/Bocchi_Menu3.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/Bocchi_Menu4.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/Bocchi_Menu5.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/Bocchi_Menu4.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/Bocchi_Menu3.png"));
  bocchiMenu.add(loadImage("/Images/Sprites/Bocchi_Menu2.png"));
  ryouMenu.add(loadImage("/Images/Sprites/Ryou_Icon.png"));
  ryouMenu.add(loadImage("/Images/Sprites/3Ryou_Menu.png"));
  ryouMenu.add(loadImage("/Images/Sprites/3Ryou_Menu2.png"));
  ryouMenu.add(loadImage("/Images/Sprites/3Ryou_Menu3.png"));
  ryouMenu.add(loadImage("/Images/Sprites/3Ryou_Menu4.png"));
  ryouMenu.add(loadImage("/Images/Sprites/3Ryou_Menu5.png"));
  ryouMenu.add(loadImage("/Images/Sprites/3Ryou_Menu4.png"));
  ryouMenu.add(loadImage("/Images/Sprites/3Ryou_Menu3.png"));
  ryouMenu.add(loadImage("/Images/Sprites/3Ryou_Menu2.png"));
  kitaMenu.add(loadImage("/Images/Sprites/Kita_Icon.png"));
  kitaMenu.add(loadImage("/Images/Sprites/2Kita_Menu.png"));
  kitaMenu.add(loadImage("/Images/Sprites/2Kita_Menu2.png"));
  kitaMenu.add(loadImage("/Images/Sprites/2Kita_Menu3.png"));
  kitaMenu.add(loadImage("/Images/Sprites/2Kita_Menu4.png"));
  kitaMenu.add(loadImage("/Images/Sprites/2Kita_Menu5.png"));
  kitaMenu.add(loadImage("/Images/Sprites/2Kita_Menu6.png"));
  kitaMenu.add(loadImage("/Images/Sprites/2Kita_Menu7.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Icon.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu2.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu3.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu4.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu5.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu5.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu5.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu5.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu5.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu5.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu4.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu3.png"));
  nijikaMenu.add(loadImage("/Images/Sprites/Nijika_Menu2.png"));
  backgrounds.add(loadImage("/Images/Sprites/Background1.png"));
  backgrounds.add(loadImage("/Images/Sprites/Background2.png"));
  jhon = loadImage("/Images/Sprites/jhon.png");
  gums = loadImage("/Images/Sprites/gums.png");
  gumsToothHealthy = loadImage("/Images/Sprites/gums_tooth_healthy.png");
  gumsToothHealthyFalling = loadImage("/Images/Sprites/gums_tooth_healthy_falling.png");
  gumsToothBrittle = loadImage("/Images/Sprites/gums_tooth_brittle.png");
  gumsToothBrittleFalling = loadImage("/Images/Sprites/gums_tooth_brittle_falling.png");
  gumsToothBloody = loadImage("/Images/Sprites/gums_tooth_bloody.png");
  gumsToothBloodyFalling = loadImage("/Images/Sprites/gums_tooth_bloody_falling.png");
  gumsToothRotting = loadImage("/Images/Sprites/gums_tooth_rotting.png");
  gumsToothRottingFalling = loadImage("/Images/Sprites/gums_tooth_rotting_falling.png");
  gumsToothInfested = loadImage("/Images/Sprites/gums_tooth_infested.png");
  gumsToothInfestedFalling = loadImage("/Images/Sprites/gums_tooth_infested_falling.png");
}
