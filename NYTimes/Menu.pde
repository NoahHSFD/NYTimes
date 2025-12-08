public class Menu {
  
  ArrayList<Button> list = new ArrayList<Button>();
  float i;
  
  public Menu() {
    list.add(new Button(width*.5-width/6, width/3, ButtonID.WORDLE));
    list.add(new Button(width*.5-width/6, width/3, ButtonID.STRANDS));
    list.add(new Button(width*.5-width/6, width/3, ButtonID.CROSSWORD));
    list.add(new Button(width*.5-width/6, width/3, ButtonID.CONNECTIONS));
    list.add(new Button(width*.5-width/6, width/3, ButtonID.SCREENSHOT));
    //list.add(new Button(width*.5-width/6, width/3, ButtonID.AUDIO));
    //list.add(new Button(width*.5-width/6, width/3, ButtonID.AUDIOPAUSE));
    list.add(new Button(width*.5-width/6, width/3, ButtonID.ISAACMENU));
    list.add(new Button(width*.5-width/6, width/3, ButtonID.EXIT));
    i = 1;
    list.forEach(t ->  {
                        t.calculateH(list.size()+4);
                        t.calculateY(i++, list.size()+1);
                       }
    );
  }
  
  void display() {
    background(60);
    for(Button t : list) {
      t.display();
    }
  }
  
  void update() {
    for(Button t : list) {
      t.update();
    }
  }
  
  void clickChecks() {
    for(Button t : list) {
      t.clickCheck();
    }
  }
  
  void clicks() {
    for(Button t : list) {
      t.click();
    }
  }
}
