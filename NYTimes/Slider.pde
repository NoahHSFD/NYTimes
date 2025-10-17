public class Slider {
  
  float x, y;
  float w, h;
  color clr = #FFFFFF;
  int status = 0;                                //0 = not hovered, 1 = hovered, 2 = clicked
  float slider;
  boolean muted = false;
  
  public Slider(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.slider = y + h*.9;
  }
  
  public Slider(float x, float y) {
    this.x = x;
    this.y = y;
    this.w = width*.025;
    this.h = height*.1;
    this.slider = y + h*.9;
  }
  
  void display() {
    pushStyle();
    fill(clr);
    rect(x, y, w, h);
    if(muted) fill(#6F6F6F);
    square(x, y+h, w);
    fill(#000000);
    line(x, slider, x+w, slider);
    popStyle();
  }
  
  void update() {
    hoverCheck();
    if(hovered() && mousePressed) {
      slider = mouseY;
    }
  }
  
  void hoverCheck() {
    if(mouseX >= this.x && mouseX <= this.x + this.w
    && mouseY >= this.y + this.h && mouseY <= this.y + this.h + this.w) {
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
  
  void clickCheck() {
    if(this.status != 0 && mousePressed) {
      this.status = 2;
    } else {
      this.status = 1;
    }
  }
  
  boolean mute() {
    if(this.status == 2){
      if(muted) {
        muted = false;
      } else {
        muted = true;
      }
      return true;
    }
    return false;
  }
  
  boolean hovered() {
    if(mouseX >= this.x && mouseX <= this.x + this.w
    && mouseY >= this.y && mouseY <= this.y + this.h) {
      return true;
    }
    return false;
  }
  
  float setVolume() {
    return map(slider, y + h, y, 0.0, 1.0);
  }
  
  boolean getMuted() {
    return this.muted;
  }
}
