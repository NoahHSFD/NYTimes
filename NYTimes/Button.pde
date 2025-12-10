public class Button {
  
  float x, y;
  float w, h;
  color clr = #00FF17;
  int status = 0;                                //0 = not hovered, 1 = hovered, 2 = clicked
  ButtonID id;
  int timer;                                     //timer for sprite animation
  
  public Button(float x, float y, float w, float h, ButtonID id) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.id = id;
  }
  
  public Button(float x, float w, ButtonID id) {
    this.x = x;
    this.w = w;
    this.id = id;
  }
  
  void display() {
    pushStyle();
    fill(clr);
    rect(x, y, w, h);
    switch(id) {
      case ISAACBOCCHI:
        if(status == 1) {
          image(bocchiMenu.get(((timer++/5)%8) + 1), x, y, w, h);
        } else {
          timer = 0;
          image(bocchiMenu.get(1), x, y, w, h);
        }
        break;
      case ISAACRYOU:
        if(status == 1) {
          image(ryouMenu.get(((timer++/14)%8) + 1), x, y, w, h);
        } else {
          timer = 0;
          image(ryouMenu.get(1), x, y, w, h);
        }
        break;
      case ISAACKITA:
        if(status == 1) {
          image(kitaMenu.get(((timer++/14)%7) + 1), x, y, w, h);
        } else {
          timer = 0;
          image(kitaMenu.get(1), x, y, w, h);
        }
        break;
      case ISAACNIJIKA:
        if(status == 1) {
          image(nijikaMenu.get(((timer++/12)%18) + 1), x, y, w, h);
        } else {
          timer = 0;
          image(nijikaMenu.get(1), x, y, w, h);
        }
        break;
      default:
        fill(#FFFFFF);
        text(id.toString(), x + w*.5, y + h*.5);
    }
    popStyle();
  }
  
  void update() {
    hoverCheck();
    switch(status) {
      case 1:
        this.clr = #868686;
        break;
      case 2:
        this.clr = #FFFFFF;
        break;
      default:
        this.clr = #000000;
    }
  }
  
  void hoverCheck() {
    if(mouseX >= this.x && mouseX <= this.x + this.w
    && mouseY >= this.y && mouseY <= this.y + this.h) {
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
  
  void click() {
    if(this.status == 2){
      switch(id) {
        case STRANDSRESET:
          st.init();
          break;
        case WORDLERESET:
          wor.init();
          break;
        case CROSSWORDRESET:
          cr.init();
          break;
        case CONNECTIONSRESET:
          co.init();
          break;
        case CONNECTIONSSHUFFLE:
          co.shuffleWords();
          break;
        case SCREENSHOTRESET:
          sc.init();
          break;
        case AUDIORESET:
          au.init();
          break;
        case EXIT:
          exit();
          break;
        case ISAACBOCCHI:
          is = new Isaac(0);
          is.init();
          game = ButtonID.ISAAC;
          break;
        case ISAACRYOU:
          is = new Isaac(1);
          is.init();
          game = ButtonID.ISAAC;
          break;
        case ISAACKITA:
          is = new Isaac(2);
          is.init();
          game = ButtonID.ISAAC;
          break;
        case ISAACNIJIKA:
          is = new Isaac(3);
          is.init();
          game = ButtonID.ISAAC;
          break;
        case MENU:
          if(bgm != bgms.get(4)) setBgm(4);
          if(game == ButtonID.ISAAC && is.getCurrentMap().getCurrentRoom().type == 3) {
            try {
              is.getCurrentMap().getCurrentRoom().quizSong.stop();
              is.getCurrentMap().getCurrentRoom().quizSong.removeFromCache();
            } catch(Exception e) {
              println(e + "\nCouldn't stop quiz room music after exiting to menu.");
            }
          }
        default:
          game = this.id;
      }
    }
  }
  
  float getW() {
    return w;
  }
  
  void setH(float h) {
    this.h = h;
  }
  
  void setY(float y) {
    this.y = y;
  }
  
  void calculateY(float ind, float len) {
    this.y = ind*height/len - this.h*.5;
  }
  
  void calculateH(float len) {
    this.h = height/len;
  }
  
  void calculateX(float ind, float hei) {
    this.x = ind*width/hei - this.w*.5;
  }
  
  void calculateW(float hei) {
    this.w = width/hei;
  }
}
