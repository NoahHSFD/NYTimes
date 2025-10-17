import java.util.ArrayList;

public class Strands{
  
  StrandsTile[] strandsTiles;                                                //dimensions: 6x8
  int gameSize = 0;                                                          //amount of total letters
  JSONArray sGame1;
  ArrayList<Integer> selectedTiles = new ArrayList<Integer>();               //list of indeces currently selected tiles
  ArrayList<Character> selectedWord = new ArrayList<Character>();
  int lastSelTile = -1;                                                      //index of last currently selected tile
  JSONObject[] words;
  String selectedWordString = "";
  String displayWord = "";
  Button resetButton;
  
  public Strands() {
    resetButton = new Button(0, height*0.975, width*0.05, height*0.025, ButtonID.STRANDSRESET);
    try {
      sGame1 = loadJSONArray("/Strands/Strands_Game3.json");
    } catch(Exception e) {
      println(e + "\n Can't find Strands game.");
    }
    words = new JSONObject[sGame1.size()];
    for(int i = 0; i < sGame1.size(); i++) {
      words[i] = sGame1.getJSONObject(i);
      gameSize += words[i].getInt("length");
    }
  }
  
  void init() {
    strandsTiles = new StrandsTile[gameSize];
    for(int i = 0; i < gameSize; i++) {
      strandsTiles[i] = new StrandsTile(i, i%6, i/6, false);
    }
    int j;
    for(JSONObject w : words) {
      j = 0;
      for(int i : w.getIntList("ids")) {
        strandsTiles[i].setLetter(w.getString("word").toUpperCase().charAt(j));
        strandsTiles[i].setWord(w.getString("word").toUpperCase());
        strandsTiles[i].setSpangram(w.getBoolean("spangram"));
        j++;
      }
    }
  }
  
  void update() {
    for(StrandsTile t : strandsTiles) {
      t.update();
    }
    resetButton.update();
  }
  
  void display() {
    background(60);
    for(StrandsTile t : strandsTiles) {
      t.display();
    }
    if(mousePressed && !selectedTiles.isEmpty()) {
      if(selectedTiles.size() > 1) {
        for(int i = 1; i < selectedTiles.size(); i++) {
          line(getTileX(selectedTiles.get(i - 1)), getTileY(selectedTiles.get(i - 1)),
          getTileX(selectedTiles.get(i)), getTileY(selectedTiles.get(i)));
        }
      }
      line(getTileX(lastSelTile), getTileY(lastSelTile), mouseX, mouseY);
    }
    displayWord = "";
    for(Character c : selectedWord) {
      displayWord += c + " ";
    }
    if(displayWord.length() >= 2) displayWord = displayWord.substring(0, displayWord.length() - 1);
    text(displayWord, width*.5, height*.1);
    resetButton.display();
  }
  
  void addSelectedTile(int id, char letter) {
    this.selectedTiles.add(id);
    this.selectedWord.add(letter);
    this.lastSelTile = selectedTiles.get(selectedTiles.size()-1);
  }
  
  void removeSelectedTile(int index) {
    for(int i = selectedTiles.size() - 1; i > index; i--) {
        for(StrandsTile t : strandsTiles) {
          if(t.getId() == selectedTiles.get(i)) {
            t.unselect();
          }
        }
      this.selectedTiles.remove(i);
      this.selectedWord.remove(i);
      this.lastSelTile = selectedTiles.get(selectedTiles.size()-1);
    }
  }
  
  void clickChecks() {
    for(StrandsTile t : strandsTiles) {
      t.clickCheck();
    }
    resetButton.clickCheck();
  }
  
  void clicks() {
    resetButton.click();
  }
  
  void clickRelease() {
    Character[] selectedWordArray = new Character[selectedWord.size()];
    selectedWordArray = selectedWord.toArray(selectedWordArray);
    selectedWord.forEach( (c) -> {selectedWordString += c;});
    println(selectedWordString);
    for(JSONObject w : words) {
      if(w.getString("word").toUpperCase().equalsIgnoreCase(selectedWordString)) {
        println("yippee " + selectedWordString);
        for(int i : selectedTiles) {
          strandsTiles[i].solve();
        }
      }
    }
    for(StrandsTile t : strandsTiles) {
      t.clickRelease();
    }
    selectedTiles.clear();
    selectedWord.clear();
    selectedWordString = "";
  }
  
  float mapX(int x) {
    return (width*.25 + (x * width*.1));
  }
  
  float mapY(int y) {
    return (height*.15 + (y * height*.1));
  }
  
  float getTileX(int index) {
    return mapX((index)%6);
  }
  
  float getTileY(int index) {
    return mapY((index)/6);
  }
  
  class StrandsTile {
    
    int x, y;
    float w = width*.05;
    char letter;
    int id;
    boolean spangram;
    String word;
    boolean solved = false;
    boolean selected = false;
    color clr = #FFFFFF;
    int status = 0;                                    //0 = not hovered, 1 = hovered, 2 = clicked
    int lastSelTile;                                   //last tile that is currently selected
    
    public StrandsTile(int id, int x, int y, boolean spangram) {
      this.id = id;
      this.x = x;
      this.y = y;
      this.spangram = spangram;
    }
    
    void display() {
      pushStyle();
      fill(clr);
      circle(mapX(x), mapY(y), w);
      fill(#000000);
      text(letter, mapX(x), mapY(y));
      popStyle();
    }
    
    void update() {
      if(this.solved) {
        if(this.spangram) {
          this.clr = #EBF000;
        } else {
          this.clr = #00D333;
        }
      }
      if(mousePressed) {
        clickCheck();
      }
    }
    
    void solve() {
      if(this.spangram) {
        this.clr = #EBF000;
      } else {
        this.clr = #00D333;
      }
      this.solved = true;
    }
    
    void hoverCheck() {
      if(w/2 >= sqrt(pow((mouseX - mapX(this.x)), 2) + pow((mouseY - mapY(this.y)), 2))) {
        switch(status) {
          case 2:
            break;
          case 0:
            this.status = 1;
            break;
          default:
        }
      } else if(this.status != 0) {
        this.status = 0;
        if(this.selected) {
        } else if(this.solved) {
        } else {
          this.clr = #FFFFFF;
        }
      }
    }
  
    void clickCheck() {
      hoverCheck();
      if(this.status != 0 && mousePressed) {
        this.status = 2;
          if(!st.selectedTiles.contains(this.id)) { 
            if(st.lastSelTile == -1) {
              this.select();
              st.addSelectedTile(this.id, this.letter);
            } else {
              switch((st.lastSelTile+1)%6) {
                case 0: 
                  if(this.id == st.lastSelTile - 7
                  || this.id == st.lastSelTile - 6 || this.id == st.lastSelTile - 1
                  || this.id == st.lastSelTile + 5 || this.id == st.lastSelTile + 6) {
                    this.select();
                    st.addSelectedTile(this.id, this.letter);
                  }
                break;
                case 1: 
                  if(this.id == st.lastSelTile - 6
                  || this.id == st.lastSelTile - 5 || this.id == st.lastSelTile + 1
                  || this.id == st.lastSelTile + 6 || this.id == st.lastSelTile + 7) {
                    this.select();
                    st.addSelectedTile(this.id, this.letter);
                  }
                break;
                default:
                  if(this.id == st.lastSelTile - 7 || this.id == st.lastSelTile - 6
                  || this.id == st.lastSelTile - 5 || this.id == st.lastSelTile - 1 || this.id == st.lastSelTile + 1
                  || this.id == st.lastSelTile + 5 || this.id == st.lastSelTile + 6 || this.id == st.lastSelTile + 7) {
                    this.select();
                    st.addSelectedTile(this.id, this.letter);
                  }
              }
          }
        } else if (st.lastSelTile != this.id) {
          st.removeSelectedTile(st.selectedTiles.indexOf(this.id));
        }
          
      }
    }
    
    void clickRelease() {
      this.status = 0;
      this.unselect();
      st.lastSelTile = -1;
    }
    
    int getId() {
      return this.id;
    }
    
    char getLetter() {
      return this.letter;
    }
    
    void setLetter(char letter) {
      this.letter = letter;
    }
    
    void setWord(String word) {
      this.word = word;
    }
    
    void setSpangram(boolean spangram) {
      this.spangram = spangram;
    }
    
    void unselect() {
      this.selected = false;
      this.clr = #FFFFFF;
    }
    
    void select() {
      this.selected = true;
      this.clr = #000000;
    }
    
    float mapX(int x) {
      return (width*.25 + (x * width*.1));
    }
    
    float mapY(int y) {
      return (height*.15 + (y * height*.1));
    }
  }
}
