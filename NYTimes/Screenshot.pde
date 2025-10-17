public class Screenshot {
  
  Button resetButton;
  ScreenshotTile ssTile;
  
  public Screenshot() {
    resetButton = new Button(0, height*0.975, width*0.05, height*0.025, ButtonID.SCREENSHOTRESET);
    ssTile = new ScreenshotTile();
  }
  
  void init() {
    ssTile.init();
  }
  
  void update() {
    ssTile.update();
    resetButton.update();
  }
  
  void display() {
    background(60);
    ssTile.display();
    resetButton.display();
  }
  
  void clicks() {
    if(ssTile.click() >= 0) {
      ssTile.threshold();
    }
    resetButton.click();
  }
  
  void clickChecks() {
    ssTile.clickCheck();
    resetButton.clickCheck();
  }
  
  class ScreenshotTile {
    
    PImage img;
    int status = 0;
    int id = 0;
    int x, y;
    int w, h;
      
    public ScreenshotTile() {
      try {
        img = loadImage("/Images/Wait_Im_Loading_Wide2.png");
      } catch(Exception e) {
        println(e + "\n Can't find Screenshot.");
      }
      this.w = img.width;
      this.h = img.height;
      this.x = width/2 - this.w/2;
      this.y = height/2 - this.h/2;
    }
    
    void init() {
      try {
        img = loadImage("/Images/Wait_Im_Loading_Wide2.png");
      } catch(Exception e) {
        println(e + "\n Can't find Screenshot.");
      }
      img.resize(this.w, this.h);
    }
    
    void update() {
      hoverCheck();
    }
    
    void display() {
      background(60);
      pushStyle();
      image(img, x, y);
      popStyle();
    }
    
    int click() {
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
    }
    
    void blur() {
      img.filter(BLUR, 8);
    }
    
    void threshold() {
      img.filter(THRESHOLD);
    }
  }
}
