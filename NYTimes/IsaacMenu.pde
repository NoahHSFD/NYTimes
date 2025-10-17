public class IsaacMenu {
  
  ArrayList<Button> list = new ArrayList<Button>();
  float i;
  
  public IsaacMenu() {
    list.add(new Button(0, height*.5 - height*.1, 0, height*.2, ButtonID.ISAACBOCCHI));
    list.add(new Button(0, height*.5 - height*.1, 0, height*.2, ButtonID.ISAACRYOU));
    list.add(new Button(0, height*.5 - height*.1, 0, height*.2, ButtonID.ISAACKITA));
    list.add(new Button(0, height*.5 - height*.1, 0, height*.2, ButtonID.ISAACNIJIKA));
    i = 1;
    list.forEach(t ->  {
                        t.calculateW(list.size()+2);
                        t.calculateX(i++, list.size()+1);
                        t.setH(t.getW());
                        t.setY(height*.5 - t.getW()*.5);
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
