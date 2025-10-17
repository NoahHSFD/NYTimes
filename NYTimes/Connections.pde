public class Connections {
  
  Button resetButton, shuffleButton;
  JSONArray coGame;
  JSONObject[] categories;
  int gameSize;
  float tileWidth, tileHeight;
  ConnectionsTile[] connectionsTiles;
  ArrayList<Integer> shuffleArray = new ArrayList<Integer>();
  int shuffleIndex;
  int selectedTilesIndex;
  HashMap<ConnectionsTier, Integer> selectedTiles = new HashMap<ConnectionsTier, Integer>();
  HashMap<ConnectionsTier, ArrayList<Integer>> test = new HashMap<ConnectionsTier, ArrayList<Integer>>();
  
  public Connections() {
    resetButton = new Button(0, height*0.975, width*0.05, height*0.025, ButtonID.CONNECTIONSRESET);
    shuffleButton = new Button(width*.95, height*0.975, width*0.05, height*0.025, ButtonID.CONNECTIONSSHUFFLE);
    try {
      coGame = loadJSONArray("/Connections/Connections_Game1.json");
    } catch(Exception e) {
      println(e + "\n Can't find Connections game.");
    }
    categories = new JSONObject[coGame.size()];
    for(int i = 0; i < coGame.size(); i++) {
      categories[i] = coGame.getJSONObject(i);
      gameSize += categories[i].getStringList("words").size();
    }
    connectionsTiles = new ConnectionsTile[gameSize];
  }
  
  void init() {
    selectedTiles.put(ConnectionsTier.YELLOW, 0);
    selectedTiles.put(ConnectionsTier.GREEN, 0);
    selectedTiles.put(ConnectionsTier.BLUE, 0);
    selectedTiles.put(ConnectionsTier.PURPLE, 0);
    selectedTilesIndex = 0;
    if(categories.length < categories[0].getStringList("words").size()) {
      tileWidth = ((width*0.75))/categories[0].getStringList("words").size();
      tileHeight = tileWidth*.5;
    } else {
      tileHeight = (height*.5)/categories.length;
      tileWidth = 2*tileHeight;
    }
    for(int i = 0; i < gameSize; i++) {
      connectionsTiles[i] = new ConnectionsTile(i, i%categories[0].getStringList("words").size(), i/categories[0].getStringList("words").size(),
                                               tileWidth, tileHeight);
    }
    for(int i = 0; i < categories.length; i++) {
      for(int j = 0; j < categories[i].getStringList("words").size(); j++) {
        connectionsTiles[(i*categories[i].getStringList("words").size()) + j].setWord(categories[i].getStringList("words").get(j));
        connectionsTiles[(i*categories[i].getStringList("words").size()) + j].setTier(categories[i].getString("tier"));
      }
    }
    shuffleArray.clear();
    shuffleIndex = 0;
    for(ConnectionsTile t : connectionsTiles) {
      shuffleArray.add(shuffleIndex++);
    }
    Collections.shuffle(shuffleArray, new Random(16));
    for(int i = 0; i < connectionsTiles.length; i++) {
      connectionsTiles[i].swap(shuffleArray.get(i));
    }
  }
  
  void update() {
    for(ConnectionsTile t : connectionsTiles) {
      t.update();
    }
    resetButton.update();
    shuffleButton.update();
  }
  
  void display() {
    background(60);
    for(ConnectionsTile t : connectionsTiles) {
      t.display();
    }
    resetButton.display();
    shuffleButton.display();
  }
  
  void clicks() {
    for(int i = 0; i < gameSize; i++) {
      if(connectionsTiles[i].click() >= 0) {
        if(connectionsTiles[i].getSelected()) {
          selectedTiles.computeIfPresent(connectionsTiles[i].getSelectedTier(), (k, v) -> v - 1);
          connectionsTiles[i].unselect();
          selectedTilesIndex--;
        } else {
          if(selectedTiles.get(ConnectionsTier.YELLOW) < 4) {
            connectionsTiles[i].select(ConnectionsTier.YELLOW);
            selectedTiles.computeIfPresent(ConnectionsTier.YELLOW, (k, v) -> v + 1);
            selectedTilesIndex++;
          } else if(selectedTiles.get(ConnectionsTier.GREEN) < 4) {
            connectionsTiles[i].select(ConnectionsTier.GREEN);
            selectedTiles.computeIfPresent(ConnectionsTier.GREEN, (k, v) -> v + 1);
            selectedTilesIndex++;
          } else if(selectedTiles.get(ConnectionsTier.BLUE) < 4) {
            connectionsTiles[i].select(ConnectionsTier.BLUE);
            selectedTiles.computeIfPresent(ConnectionsTier.BLUE, (k, v) -> v + 1);
            selectedTilesIndex++;
          } else if(selectedTiles.get(ConnectionsTier.PURPLE) < 4) {
            connectionsTiles[i].select(ConnectionsTier.PURPLE);
            selectedTiles.computeIfPresent(ConnectionsTier.PURPLE, (k, v) -> v + 1);
            selectedTilesIndex++;
          }
        }
        break;
      }
    }
    resetButton.click();
    shuffleButton.click();
  }
  
  void clickChecks() {
    for(ConnectionsTile t : connectionsTiles) {
      t.clickCheck();
    }
    resetButton.clickCheck();
    shuffleButton.clickCheck();
  }
  
  void submitAllTierSensitive() {
    for(ConnectionsTile t : connectionsTiles) {
      if(!t.selectedTier.name().equals(t.tier)) {
        println("incorrect");
        return;
      }
    }
    println("correct");
  }
  
  void submitAll() {
    for(int i = 0; i < categories.length; i++) {
      for(int j = 1; j < categories[0].getStringList("words").size(); j++) {
        if(!(connectionsTiles[i*categories[0].getStringList("words").size()].getSelectedTier()
           == connectionsTiles[(i*categories[0].getStringList("words").size())+j].getSelectedTier())
        || connectionsTiles[i*categories[0].getStringList("words").size()].getSelectedTier() == ConnectionsTier.UNSELECTED) {
          println("incorrect");
          return;
        }
      }
    }
    println("correct");
  }
  
  void submitTierSensitive() {
    if(selectedTiles.get(ConnectionsTier.YELLOW)==categories[0].getStringList("words").size()) {
      for(ConnectionsTile t : connectionsTiles) {
        if(t.getSelectedTier() == ConnectionsTier.YELLOW && !t.getTier().equals("YELLOW")) {
          println("incorrect yellow");
          return;
        }
      }
    } else if(selectedTiles.get(ConnectionsTier.GREEN)==categories[0].getStringList("words").size()) {
      for(ConnectionsTile t : connectionsTiles) {
        if(t.getSelectedTier() == ConnectionsTier.GREEN && !t.getTier().equals("GREEN")) {
          println("incorrect green");
          return;
        }
      }
    } else if(selectedTiles.get(ConnectionsTier.BLUE)==categories[0].getStringList("words").size()) {
      for(ConnectionsTile t : connectionsTiles) {
        if(t.getSelectedTier() == ConnectionsTier.BLUE && !t.getTier().equals("BLUE")) {
          println("incorrect blue");
          return;
        }
      }
    } else if(selectedTiles.get(ConnectionsTier.PURPLE)==categories[0].getStringList("words").size()) {
      for(ConnectionsTile t : connectionsTiles) {
        if(t.getSelectedTier() == ConnectionsTier.PURPLE && !t.getTier().equals("PURPLE")) {
          println("incorrect purple");
          return;
        }
      }
    } else {
      println("not enough tiles selected");
      return;
    }
    println("correct");
  }
  
  void submit() {
    if(selectedTiles.get(ConnectionsTier.YELLOW)==categories[0].getStringList("words").size()) {
      
    } else if(selectedTiles.get(ConnectionsTier.GREEN)==categories[0].getStringList("words").size()) {
      for(ConnectionsTile t : connectionsTiles) {
        if(t.getSelectedTier() == ConnectionsTier.GREEN && !t.getTier().equals("GREEN")) {
          println("incorrect green");
          return;
        }
      }
    } else if(selectedTiles.get(ConnectionsTier.BLUE)==categories[0].getStringList("words").size()) {
      for(ConnectionsTile t : connectionsTiles) {
        if(t.getSelectedTier() == ConnectionsTier.BLUE && !t.getTier().equals("BLUE")) {
          println("incorrect blue");
          return;
        }
      }
    } else if(selectedTiles.get(ConnectionsTier.PURPLE)==categories[0].getStringList("words").size()) {
      for(ConnectionsTile t : connectionsTiles) {
        if(t.getSelectedTier() == ConnectionsTier.PURPLE && !t.getTier().equals("PURPLE")) {
          println("incorrect purple");
          return;
        }
      }
    } else {
      println("not enough tiles selected");
      return;
    }
    println("correct");
  }
  
  void shuffleWords() {
    shuffleArray.clear();
    shuffleIndex = 0;
    for(ConnectionsTile t : connectionsTiles) {
      shuffleArray.add(shuffleIndex++);
    }
    Collections.shuffle(shuffleArray);
    for(int i = 0; i < connectionsTiles.length; i++) {
      connectionsTiles[i].swap(shuffleArray.get(i));
    }
  }
  
  public class ConnectionsTile {
    
    int x, y;
    float w, h;
    int id;
    String word = "";
    String category;
    boolean selected = false;
    boolean solved = false;
    ConnectionsTier selectedTier = ConnectionsTier.UNSELECTED;
    String tier;
    int status;
    color clr = #FFFFFF;
    
    public ConnectionsTile(int id, int x, int y, float w, float h) {
      this.id = id;
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
    }
    
    void swap(int id) {
      this.x = id%co.categories[0].getStringList("words").size();
      this.y = id/co.categories[0].getStringList("words").size();
    }
    
    void update() {
      hoverCheck();
    }
    
    void display() {
      pushStyle();
      fill(clr);
      rect(mapX(x), mapY(y), w*.9, h*.9);
      fill(#000000);
      textAlign(CENTER);
      text(word, mapX(x) + w*.45, mapY(y) + h*.55);
      popStyle();
    }
    
    void clickCheck() {
      if(this.status != 0 && mousePressed) {
        this.status = 2;
      } else {
        this.status = 1;
      }
    }
    
    int click() {
      if(this.status == 2){
        return this.id;
      }
      return -1;
    }
    
    int getId() {
      return id;
    }
    
    void setTier(String tier) {
      this.tier = tier;
    }
    
    String getTier() {
      return tier;
    }
    
    void select(ConnectionsTier tier) {
      this.selected = true;
      this.selectedTier = tier;
      switch(tier) {
        case YELLOW: 
          this.clr = #EBF000;
          break;
        case GREEN:
          this.clr = #0FC600;
          break;
        case BLUE:
          this.clr = #1F08FC;
          break;
        case PURPLE:
          this.clr = #9A08FC;
          break;
        default:
          this.clr = #B9B9B9;
      }
    }
    
    void unselect() {
      this.selected = false;
      this.selectedTier = ConnectionsTier.UNSELECTED;
      this.clr = #FFFFFF;
    }
    
    ConnectionsTier getSelectedTier() {
      return selectedTier;
    }
    
    boolean getSelected() {
      return this.selected;
    }
    
    void solve() {
      this.clr = #00D333;
      this.solved = true;
    }
    
    void setWord(String word) {
      this.word = word;
    }
    
    String getWord() {
      return word;
    }
    
    void hoverCheck() {
      if(mouseX >= mapX(x) && mouseX <= mapX(x) + this.w*.9
      && mouseY >= mapY(y) && mouseY <= mapY(y) + this.h*.9) {
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
    
    float mapX(int x) {
      return width*.5 + (x-(co.categories[0].getStringList("words").size()*.5))*w + w*.05;
    }
    
    float mapY(int y) {
      return height*.5 + (y-(co.coGame.size()*.5))*h + h*.05;
    }
  }
}
