public class IsaacPause {
  
  
  public IsaacPause() {
  }
  
  void display() {
    pushStyle();
    fill(#000000);
    rect(width*.2, height*.2, width*.6, height*.6);
    textAlign(CENTER, CENTER);
    textSize(50);
    fill(#FFFFFF);
    text("PAUSE", width*.5, height*.3);
    popStyle();
    for(Slider s : is.isaacVolumeSliders) {
      s.display();
    }
  }
  
  void update() {
    for(Slider s : is.isaacVolumeSliders) {
      s.update();
    }
  }
  
  void clickChecks() {
    for(Slider s : is.isaacVolumeSliders) {
      s.clickCheck();
    }
  }
  
  void clicks() {
    for(Slider s : is.isaacVolumeSliders) {
      s.mute();
    }
  }
  
  void pressKey(int k) {
    switch(k) {
      case -1:
        is.state = GameState.PLAYING;
        break;
      default:
    }
  }
}
