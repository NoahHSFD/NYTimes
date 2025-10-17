public class Audio {
  
  Button resetButton;
  AudioFile audioFile;
  
  public Audio() {
    resetButton = new Button(0, height*0.975, width*0.05, height*0.025, ButtonID.AUDIORESET);
    audioFile = new AudioFile();
  }
  
  void init() {
    audioFile.init();
  }
  
  void update() {
    audioFile.update();
    resetButton.update();
  }
  
  void display() {
    background(60);
    audioFile.display();
    resetButton.display();
  }
  
  void clicks() {
    if(audioFile.click() >= 0) {
      audioFile.playAudio();
      Sound.status();
    }
    resetButton.click();
  }
  
  void clickChecks() {
    audioFile.clickCheck();
    resetButton.clickCheck();
  }
  
   class AudioFile {
  
    SoundFile aud;
    int status = 0;
    int id = 0;
    float x, y;
    float w, h;
    Slider audioVolume;
    
    public AudioFile(float x, float y, float w, float h) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      audioVolume = new Slider(x + w, y);
    }
      
    public AudioFile() {
      this.w = width/2;
      this.h = height/2;
      this.x = width/2 - this.w/2;
      this.y = height/2 - this.h/2;
      audioVolume = new Slider(x + w, y);
    }
    
    void init() {
      try {
        aud = new SoundFile(NYTimes.this, "/Audio/bobby.mp3");
      } catch(Exception e) {
        println(e + "Can't find audio file.");
      }
    }
    
    void update() {
      hoverCheck();
      audioVolume.update();
      if(!audioVolume.getMuted()) aud.amp(audioVolume.setVolume());
    }
    
    void display() {
      background(60);
      pushStyle();
      fill(#FFFFFF);
      if(aud.isPlaying()) fill(#27F016);
      rect(x, y, w, h);
      audioVolume.display();
      popStyle();
    }
    
    int click() {
      if(audioVolume.mute()) aud.amp(0.0);
      if(this.status == 2){
        return this.id;
      }
      return -1;
    }
    
    void clickCheck() {
      if(this.status != 0 && mousePressed) {
        this.status = 2;
      } else {
        this.status = 1;
      }
      audioVolume.clickCheck();
    }
    
    void hoverCheck() {
      if(mouseX >= x && mouseX <= x + this.w
      && mouseY >= y && mouseY <= y + this.w) {
        switch(status) {
          case 2:
            break;
          case 0:
            this.status = 1;
            break;
          default:
        }
      } else {
        this.status = 0;
      }
      audioVolume.hoverCheck();
    }
    
    void playAudio() {
      aud.removeFromCache();
      aud.play();
    }
  }
}
