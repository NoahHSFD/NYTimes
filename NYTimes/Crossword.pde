public class Crossword{
  
  CrosswordTile[] crosswordTiles;
  CrosswordHint[] crosswordHints;
  int gameSize = 0;                                                                //amount of total letters
  JSONArray hintArray;
  JSONObject[] hints;
  ArrayList<String> wordList = new ArrayList<String>();
  float tileWidth; 
  float hintY = height*.05;                                                        //height of the hint-box
  int selectedTile = 0;
  BufferedReader reader;
  String line = "";
  Button resetButton;
  boolean vertical = false;                                                        //direction of the currently selected tiles
  HashMap<Integer, Integer> verticalHashmap = new HashMap<Integer, Integer>();     //hashmaps to look up tile-word relations
  HashMap<Integer, Integer> horizontalHashmap = new HashMap<Integer, Integer>();
  
  public Crossword() {
    resetButton = new Button(0, height*0.975, width*0.05, height*0.025, ButtonID.CROSSWORDRESET);
    try {
      reader = createReader("/Crossword/Crossword_Game2.txt");
      hintArray = loadJSONArray("/Crossword/Crossword_Hints2.json");
    } catch(Exception e) {
      println(e + "\n Can't find Crossword game.");
    }
    hints = new JSONObject[hintArray.size()];
    for(int i = 0; i < hintArray.size(); i++) {
      hints[i] = hintArray.getJSONObject(i);
    }
    while(line != null) {
      try {
        line = reader.readLine();
        if(line != null) {
          wordList.add(line);
        }
      } catch (IOException e) {
        e.printStackTrace();
        line = null;
      }
    }
    for(int i = 0; i < wordList.size(); i++) {
      gameSize += wordList.get(i).length();
    }
  }
  
  void init() {
    crosswordTiles = new CrosswordTile[gameSize];
    vertical = false;
    if(wordList.size() < wordList.get(0).length()) {
      tileWidth = ((width-200) - (height*0.5))/wordList.get(0).length();
    } else {
      tileWidth = (height*0.5)/wordList.size();
    }
    for(int i = 0; i < gameSize; i++) {
      crosswordTiles[i] = new CrosswordTile(i, i%wordList.get(0).length(), i/wordList.get(0).length(), tileWidth);
    }
    int j = 0;
    for(String w : wordList) {
      for(int i = 0; i < w.length(); i++) {
        crosswordTiles[j].setLetter(w.toUpperCase().charAt(i));
        crosswordTiles[j].setWord(w.toUpperCase());
        j++;
      }
    }
    crosswordTiles[hints[0].getInt("id")].select();
    selectedTile = hints[0].getInt("id");
    crosswordHints = new CrosswordHint[hints.length];
    int hor = 0;
    int ver = 0;
    hintY = (height*.5)/(hints.length*.5);
    for(JSONObject h : hints) {
      if(!h.getBoolean("vertical")) {
        crosswordHints[ver + hor] = new CrosswordHint(width*.5, height*.25 + hor*hintY, width*.2, hintY, h.getString("hint"), h.getInt("id"), h.getBoolean("vertical"), ++hor);
      } else {
        crosswordHints[ver + hor] = new CrosswordHint(width*.75, height*.25 + ver*hintY, width*.2, hintY, h.getString("hint"), h.getInt("id"), h.getBoolean("vertical"), ++ver);
      }
    }
    for(JSONObject h : hints) {
      if(!h.getBoolean("vertical")) {
        for(int i = h.getInt("id"); i < h.getInt("id") + h.getInt("length"); i++) {
          crosswordTiles[i].setHintHor(h.getInt("id"));
        }
      } else {
        for(int i = h.getInt("id"); i < h.getInt("id") + (h.getInt("length")*wordList.get(0).length()); i += wordList.get(0).length()) {
          crosswordTiles[i].setHintVer(h.getInt("id"));
        }
      }
    }
    highlightWord(selectedTile);
  }
  
  void update() {
    for(CrosswordTile t : crosswordTiles) {
      t.update();
    }
    for(CrosswordHint h : crosswordHints) {
      h.update();
    }
    resetButton.update();
  }
  
  void display() {
    background(60);
    for(CrosswordTile t : crosswordTiles) {
      t.display();
    }
    for(CrosswordHint h : crosswordHints) {
      h.display();
    }
    resetButton.display();
  }
  
  void changeDirection() {
    if(vertical) {
      vertical = false;
      highlightWord(selectedTile);
    } else {
      vertical = true;
      highlightWord(selectedTile);
    }
  }
  
  void pressKey(char ch) {
    crosswordTiles[selectedTile].setCurrentLetter(Character.toUpperCase(ch));
    if(!vertical) {
      if(selectedTile%wordList.get(0).length() < wordList.get(0).length() - 1) {
        if(crosswordTiles[selectedTile + 1].getLetter() != '-') {
          crosswordTiles[selectedTile].unselect();
          crosswordTiles[selectedTile + 1].select();
          selectedTile++;
        }
      }
    } else {
      if(selectedTile/wordList.get(0).length() < wordList.size() - 1) {
        if(crosswordTiles[selectedTile + wordList.get(0).length()].getLetter() != '-') {
          crosswordTiles[selectedTile].unselect();
          crosswordTiles[selectedTile + wordList.get(0).length()].select();
          selectedTile += wordList.get(0).length();
        }
      }
    }
    highlightWord(selectedTile);
  }
  
  void submit() {
    println("comparing...");
    for(CrosswordTile t : crosswordTiles) {
      if(!t.compareSolution()) return;
    }
    println("yippee");
  }
  
  void delete() {
    if(!vertical) {
      if(selectedTile%wordList.get(0).length() > 0 && crosswordTiles[selectedTile].getCurrentLetter() == '-'
      && crosswordTiles[selectedTile - 1].getLetter() != '-') {
        crosswordTiles[selectedTile].unselect();
        selectedTile--;
        crosswordTiles[selectedTile].select();
      } else {
        crosswordTiles[selectedTile].setCurrentLetter('-');
      }
    } else {
      if(selectedTile/wordList.get(0).length() > 0 && crosswordTiles[selectedTile].getCurrentLetter() == '-'
      && crosswordTiles[selectedTile - wordList.get(0).length()].getLetter() != '-') {
        crosswordTiles[selectedTile].unselect();
        selectedTile -= wordList.get(0).length();
        crosswordTiles[selectedTile].select();
      } else {
        crosswordTiles[selectedTile].setCurrentLetter('-');
      }
    }
    highlightWord(selectedTile);
  }
  
  void down() {
    if(!vertical) {
      changeDirection();
    } else {
      if(selectedTile/wordList.get(0).length() < wordList.size() - 1) {
        if(crosswordTiles[selectedTile + wordList.get(0).length()].getLetter() != '-') {
          crosswordTiles[selectedTile].unselect();
          crosswordTiles[selectedTile + wordList.get(0).length()].select();
          selectedTile += wordList.get(0).length();
        }
      }
      highlightWord(selectedTile);
    }
  }
  
  void up() {
    if(!vertical) {
      changeDirection();
    } else if(selectedTile/wordList.get(0).length() > 0) {
      if(crosswordTiles[selectedTile - wordList.get(0).length()].getLetter() != '-') {
        crosswordTiles[selectedTile].unselect();
        crosswordTiles[selectedTile - wordList.get(0).length()].select();
        selectedTile -= wordList.get(0).length();
      }
      highlightWord(selectedTile);
    }
  }
  
  void right() {
    if(vertical) {
      changeDirection();
    } else if(selectedTile%wordList.get(0).length() < wordList.get(0).length() - 1) {
      if(crosswordTiles[selectedTile + 1].getLetter() != '-') {
        crosswordTiles[selectedTile].unselect();
        crosswordTiles[selectedTile + 1].select();
        selectedTile++;
      }
      highlightWord(selectedTile);
    }
  }  
  
  void left() {
    if(vertical) {
      changeDirection();
    } else if(selectedTile%wordList.get(0).length() > 0) {
      if(crosswordTiles[selectedTile - 1].getLetter() != '-') {
        crosswordTiles[selectedTile].unselect();
        crosswordTiles[selectedTile - 1].select();
        selectedTile--;
      }
      highlightWord(selectedTile);
    }
  } 
  
  void clickChecks() {
    for(CrosswordTile t : crosswordTiles) {
      t.clickCheck();
    }
    for(CrosswordHint h : crosswordHints) {
      h.clickCheck();
    }
    resetButton.clickCheck();
  }
  
  void clicks() {
    for(int i = 0; i < gameSize; i++) {
      if(crosswordTiles[i].click() >= 0 && crosswordTiles[i].getLetter() != '-') {
        if(crosswordTiles[i].getSelected()) {
          changeDirection();
        } else {
          crosswordTiles[selectedTile].unselect();
          crosswordTiles[i].select();
          selectedTile = crosswordTiles[i].getId();
          highlightWord(i);
        }
        break;
      }
    }
    for(CrosswordHint h : crosswordHints) {
      if(h.click() >= 0) {
        crosswordTiles[selectedTile].unselect();
        crosswordTiles[h.getId()].select();
        selectedTile = h.getId();
        vertical = h.getVertical();
        highlightWord(h.getId());
      }
    }
    resetButton.click();
  }
  
  void highlightWord(int index) {
    for(CrosswordTile t : crosswordTiles) {
      if(t.getLetter() != '-') t.unhighlight();
    }
    if(vertical) {
      for(int i = index; i <= gameSize - 1; i += wordList.get(0).length()) {
        if(crosswordTiles[i].getLetter() == '-') break;
        crosswordTiles[i].highlight();
      }
      for(int i = index; i >= 0; i -= wordList.get(0).length()) {
        if(crosswordTiles[i].getLetter() == '-') break;
        crosswordTiles[i].highlight();
      }
    } else {
      for(int i = index; i/wordList.get(0).length() == index/wordList.get(0).length(); i++) {
        if(crosswordTiles[i].getLetter() == '-') break;
        crosswordTiles[i].highlight();
      }
      for(int i = index; i/wordList.get(0).length() == index/wordList.get(0).length(); i--) {
        if(i<0) break;
        if(crosswordTiles[i].getLetter() == '-') break;
        crosswordTiles[i].highlight();
      }
    }
    for(CrosswordHint h : crosswordHints) {
      h.unselect();
      if(h.getId() == crosswordTiles[index].getHintHor() && h.getVertical() == this.vertical && !this.vertical) {
        h.select();
      } else if (h.getId() == crosswordTiles[index].getHintVer() && h.getVertical() == this.vertical && this.vertical) {
        h.select();
      }
    }
  }

  class CrosswordTile {
    
    int x, y;
    float w;
    char letter;
    char currentLetter = '-';
    int id;
    String word;                                          //string of the entire row from left to right
    int[] hint = {-1, -1};                                //ids of the hints connected to the tile, int[0] = horizontal, int[1] = vertical
    boolean highlighted = false;
    boolean selected = false;
    color clr = #FFFFFF;
    int status = 0;                                       //0 = not hovered, 1 = hovered, 2 = clicked
    
    public CrosswordTile(int id, int x, int y, float w) {
      this.id = id;
      this.x = x;
      this.y = y;
      this.w = w;
    }
    
    void update() {
      hoverCheck();
    }
    
    void display() {
      if(letter == '-') {
        pushStyle();
        fill(#000000);
        square(mapX(x), mapY(y), w);
        popStyle();
      } else {
        pushStyle();
        fill(clr);
        square(mapX(x), mapY(y), w);
        fill(#000000);
        text(currentLetter, mapX(x) + w*.5, mapY(y) + w*.5);
        popStyle();
      }
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
    
    void select() {
      this.selected = true;
      this.clr = #B9B9B9;
    }
    
    void unselect() {
      this.selected = false;
      if(!highlighted) {
        this.clr = #FFFFFF;
      }
    }
    
    void highlight() {
      if(!selected) {
        this.highlighted = true;
        this.clr = #E8F024;
      }
    }
    
    void unhighlight() {
      if(!selected) {
        this.highlighted = false;
        this.clr = #FFFFFF;
      }
    }
    
    void hoverCheck() {
      if(mouseX >= mapX(x) && mouseX <= mapX(x) + this.w
      && mouseY >= mapY(y) && mouseY <= mapY(y) + this.w) {
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
    
    boolean compareSolution() {
      if(currentLetter == letter) {
        return true;
      } else {
        return false;
      }
    }
    
    void setLetter(char letter) {
      this.letter = letter;
    }
    
    char getLetter() {
      return this.letter;
    }
    
    void setCurrentLetter(char letter) {
      this.currentLetter = letter;
    }
    
    char getCurrentLetter() {
      return this.currentLetter;
    }
    
    int getId() {
      return this.id;
    }
    
    void setWord(String word) {
      this.word = word;
    }
    
    boolean getSelected() {
      return this.selected;
    }
    
    void setHintHor(int id) {
      this.hint[0] = id;
    }
    
    int getHintHor() {
      return hint[0];
    }
    
    void setHintVer(int id) {
      this.hint[1] = id;
    }
    
    int getHintVer() {
      return hint[1];
    }
    
    float mapX(int x) {
      return (width*.25) + (x-(word.length()*.5))*w;
    }
    
    float mapY(int y) {
      return (height*.5) + (y-(cr.wordList.size()*.5))*w;
    }
  }

  class CrosswordHint {
    
    float x, y;
    float w, h;
    String hint = "";
    int id;
    boolean vertical;
    color clr = #FFFFFF;
    int status = 0;
    boolean selected = false;
    int horVerId;                                                              //id of the hint in its respective direction
                                                                               //i.e. whether it's the 1st, 2nd,... vertical or horizontal hint
    
    public CrosswordHint(float x, float y, float w, float h, String hint, int id, boolean vertical, int horVerId) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.hint = hint;
      this.id = id;
      this.vertical = vertical;
      this.horVerId = horVerId;
    }
    
    void display() {
      pushStyle();
      fill(clr);
      rect(x, y, w, h);
      fill(#000000);
      textAlign(LEFT, TOP);
      text(horVerId + " " + hint, x, y);
      popStyle();
    }
    
    void update() {
      hoverCheck();
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
    
    void select() {
      this.selected = true;
      this.clr = #E8F024;
    }
    
    void unselect() {
      this.selected = false;
      this.clr = #FFFFFF;
    }
    
    int click() {
      if(this.status == 2){
        return id;
      }
      return -1;
    }
    
    int getId() {
      return id;
    }
    
    boolean getVertical() {
      return vertical;
    }
  }
}
