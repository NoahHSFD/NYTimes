public class Wordle {
  
  int wordLength;
  int lives;
  int remainingLives;
  String word = "";
  char[] letters;
  int selectedTile = 0;
  float wordleY;                                                                  //dynamic width for answer tiles
  float keyY = height/9;                                                          //fixed width for keyboard tiles
  WordleTile[][] wordleTiles;
  WordleKeyboardTile[] wordleKeyboard;
  HashMap<Character, Integer> letterCounts = new HashMap<Character, Integer>();
  Button resetButton;
  BufferedReader reader;
  ArrayList<String> wordList = new ArrayList<String>();
  String line = "";
  
  public Wordle() {
    try {
      reader = createReader("/Wordle/Wordle_Words.txt");
    } catch(Exception e) {
      println(e + "\n Can't find Wordle game.");
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
    this.word = wordList.get(int(random(wordList.size()))).toUpperCase();
    this.wordLength = word.length();
    this.lives = word.length();
  }
  
  void init() {
    resetButton = new Button(0, height*0.975, width*0.05, height*0.025, ButtonID.WORDLERESET);
    wordleTiles = new WordleTile[wordLength][lives];
    remainingLives = lives;
    if(wordLength > lives*1.5) {
      wordleY = width/wordLength;
    } else {
      wordleY = height/(1.5*lives);
    }
    selectedTile = 0;
    for (int i = 0; i < wordLength; i++) {
      for (int j = 0; j < lives; j++) {
        wordleTiles[i][j] = new WordleTile((width*.5) + (i-(wordLength*.5))*wordleY + wordleY*.05, (height/3) + (j-(lives*.5))*wordleY + wordleY*.05, wordleY*.9, word.charAt(i), i, word);
      }
    }
    wordleTiles[0][0].select();
    letters = word.toCharArray();
    countLetters();
    wordleKeyboard = new WordleKeyboardTile[28];
    for (int i = 0; i < 10; i ++) {
      wordleKeyboard[i] = new WordleKeyboardTile((width*.5) + (i-5)*(keyY*.8) + keyY*.06, 2*height/3, keyY*.7, keyY*.9, i, 'a');
    }
    for (int i = 0; i < 9; i++) {
      wordleKeyboard[10+i] = new WordleKeyboardTile((width*.5) + (i-4.5)*(keyY*.8) + keyY*.06, 2*height/3 + keyY, keyY*.7, keyY*.9, 10+i, 'a');
    }
    for (int i = 0; i < 7; i++) {
      wordleKeyboard[20+i] = new WordleKeyboardTile((width*.5) + (i-3.5)*(keyY*.8) + keyY*.06, 2*height/3 + 2*keyY, keyY*.7, keyY*.9, 20+i, 'a');
    }
    wordleKeyboard[19] = new WordleKeyboardTile((width*.5) - 5*(keyY*.8) + keyY*.06, 2*height/3 + 2*keyY, keyY*1.1, keyY*.9, 19, 'a');
    wordleKeyboard[27] = new WordleKeyboardTile((width*.5) + 3.5*(keyY*.8) + keyY*.06, 2*height/3 + 2*keyY, keyY*1.1, keyY*.9, 27, 'a');
    wordleKeyboard[0].setLetter('Q');
    wordleKeyboard[1].setLetter('W');
    wordleKeyboard[2].setLetter('E');
    wordleKeyboard[3].setLetter('R');
    wordleKeyboard[4].setLetter('T');
    wordleKeyboard[5].setLetter('Z');
    wordleKeyboard[6].setLetter('U');
    wordleKeyboard[7].setLetter('I');
    wordleKeyboard[8].setLetter('O');
    wordleKeyboard[9].setLetter('P');
    wordleKeyboard[10].setLetter('A');
    wordleKeyboard[11].setLetter('S');
    wordleKeyboard[12].setLetter('D');
    wordleKeyboard[13].setLetter('F');
    wordleKeyboard[14].setLetter('G');
    wordleKeyboard[15].setLetter('H');
    wordleKeyboard[16].setLetter('J');
    wordleKeyboard[17].setLetter('K');
    wordleKeyboard[18].setLetter('L');
    wordleKeyboard[19].setLetter('d');
    wordleKeyboard[20].setLetter('Y');
    wordleKeyboard[21].setLetter('X');
    wordleKeyboard[22].setLetter('C');
    wordleKeyboard[23].setLetter('V');
    wordleKeyboard[24].setLetter('B');
    wordleKeyboard[25].setLetter('N');
    wordleKeyboard[26].setLetter('M');
    wordleKeyboard[27].setLetter('e');
  }
  
  void display() {
    background(60);
    for (int i = 0; i < wordLength; i++) {
      for (int j = 0; j < lives; j++) {
        wordleTiles[i][j].display();
      }
    }
    for(WordleKeyboardTile i : wordleKeyboard) {
      i.display();
    }
    resetButton.display();
  }
  
  void update() {
    for (int i = 0; i < wordLength; i++) {
      for (int j = 0; j < lives; j++) {
        wordleTiles[i][j].update();
      }
    }
    for(WordleKeyboardTile i : wordleKeyboard) {
      i.update();
    }
    resetButton.update();
  }
  
  void submit() {
    for(WordleTile[] i : wordleTiles) {
      if(i[lives-remainingLives].getCurrentLetter() == '-') {
        return;
      }
    }
    for(WordleTile[] i : wordleTiles) {
      i[lives-remainingLives].unselect();
    }
    for(WordleTile[] i : wordleTiles) {
      i[lives-remainingLives].compareGreen();
      if(i[lives-remainingLives].getGuessStatus() == 1) {
        letterCounts.computeIfPresent(i[lives-remainingLives].getSolution(), (k, v) -> v - 1);
      }
    }
    for(WordleTile[] i : wordleTiles) {
      if(i[lives-remainingLives].getGuessStatus() != 1 && i[lives-remainingLives].compareToWord() && letterCounts.get(i[lives-remainingLives].getCurrentLetter()) > 0) {
        i[lives-remainingLives].compareYellow();
        letterCounts.computeIfPresent(i[lives-remainingLives].getCurrentLetter(), (k, v) -> v - 1);
      }
    }
    if(remainingLives > 1) {
      remainingLives--;
      selectedTile = 0;
      wordleTiles[0][lives-remainingLives].select();
    }
    countLetters();
  }
  
  void clickChecks() {
    for(WordleKeyboardTile i : wordleKeyboard) {
      i.clickCheck();
    }
    for(WordleTile[] i : wordleTiles) {
      i[lives-remainingLives].clickCheck();
    }
    resetButton.clickCheck();
  }
  
  void clicks() {
    for(WordleKeyboardTile i : wordleKeyboard) {
      if(i.click() != 'a') {                                         //returns lower case 'a' if no tile is clicked
        if(i.click() == 'e') {
          submit();
        } else if (i.click() == 'd'){
          delete();
        } else {
          wordleTiles[selectedTile][lives-remainingLives].setCurrentLetter(i.click());
          if(selectedTile < wordLength - 1) {
            wordleTiles[selectedTile][lives-remainingLives].unselect();
            wordleTiles[selectedTile + 1][lives-remainingLives].select();
            selectedTile++;
          }
          break;
        }
      }
    }
    for(int i = 0; i < wordLength; i++) {
      if(wordleTiles[i][lives-remainingLives].click() >= 0) {
        selectedTile = wordleTiles[i][lives-remainingLives].getId();
        for(int j = 0; j < wordLength; j++) {
          wordleTiles[j][lives-remainingLives].unselect();
        }
        wordleTiles[i][lives-remainingLives].select();
        break;
      }
    }
    resetButton.click();
  }
  
  void countLetters() {
    letterCounts.clear();
    for(char letter : letters) {
      letterCounts.computeIfPresent(letter, (k, v) -> v + 1);
      letterCounts.putIfAbsent(letter, 1);
    }
  }
  
  void pressKey(char ch) {
    wordleTiles[selectedTile][lives-remainingLives].setCurrentLetter(Character.toUpperCase(ch));
    if(selectedTile < wordLength - 1) {
      wordleTiles[selectedTile][lives-remainingLives].unselect();
      wordleTiles[selectedTile + 1][lives-remainingLives].select();
      selectedTile++;
    }
  }
  
  void delete() {
    if(selectedTile > 0 && wordleTiles[selectedTile][lives-remainingLives].getCurrentLetter() == '-'
    && wordleTiles[selectedTile - 1][lives-remainingLives].getCurrentLetter() != '-') {
      wordleTiles[selectedTile - 1][lives-remainingLives].setCurrentLetter('-');
      wordleTiles[selectedTile][lives-remainingLives].unselect();
      selectedTile--;
      wordleTiles[selectedTile][lives-remainingLives].select();
    } else {
      wordleTiles[selectedTile][lives-remainingLives].setCurrentLetter('-');
    }
  }
  
  void left() {
    if(selectedTile > 0) {
      wordleTiles[selectedTile][lives-remainingLives].unselect();
      selectedTile--;
      wordleTiles[selectedTile][lives-remainingLives].select();
    }
  }
  
  void right() {
    if(selectedTile < wordLength - 1) {
      wordleTiles[selectedTile][lives-remainingLives].unselect();
      selectedTile++;
      wordleTiles[selectedTile][lives-remainingLives].select();
    }
  }

  class WordleTile {
    
    float x, y;
    float w;
    color clr = #FFFFFF;
    char solution;                                                 //letter of the wordle solution
    char currentLetter = '-';                                      //displayed letter
    int id;
    int status = 0;                                                //0 = not hovered, 1 = hovered, 2 = clicked
    boolean selected = false;                                      //whether the tile is currently selected
    int guessStatus = 0;                                           //0 = nothing, 1 = green, 2 = yellow, 3 = grey
    String word = "";
    char[] letters;
    
    public WordleTile(float x, float y, float w, char solution, int id, String word) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.solution = solution;
      this.id = id;
      this.word = word;
      this.letters = word.toCharArray();
    }
    
    void display() {
      pushStyle();
      fill(clr);
      square(x, y, w);
      fill(#120B0B);
      text(currentLetter, x + w*.5, y + w*.5);
      popStyle();
    }
    
    void update() {
      hoverCheck();
    }
    
    void hoverCheck() {
      if(mouseX >= this.x && mouseX <= this.x + this.w
      && mouseY >= this.y && mouseY <= this.y + this.w) {
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
    
    int click() {
      if(this.status == 2){
        return this.id;
      }
      return -1;
    }
    
    int getId() {
      return this.id;
    }
    
    int getGuessStatus() {
      return this.guessStatus;
    }
    
    char getCurrentLetter() {
      return this.currentLetter;
    }
    
    char getSolution() {
      return this.solution;
    }
    
    void setCurrentLetter(char currentLetter) {
      this.currentLetter = currentLetter;
    }
    
    void select() {
      this.selected = true;
      this.clr = #B9B9B9;
    }
    
    void unselect() {
      this.selected = false;
      this.clr = #FFFFFF;
    }
    
    void compareGreen() {
      if(currentLetter == solution) {
        this.guessStatus = 1;
        this.clr = #0FC600;
      } else {
        this.guessStatus = 3;
        this.clr = #595A59;
      }
    }
    
    void compareYellow() {
      for(char ch : letters) {
        if(currentLetter == ch) {
          this.guessStatus = 2;
          this.clr = #EDF200;
        }
      }
    }
    
    boolean compareToWord() {
      for(char ch : letters) {
        if(ch == this.currentLetter) {
          return true;
        }
      }
      return false;
    }
  }

  class WordleKeyboardTile {
    
    float x, y;
    float w, h;
    color clr = #F0F0F0;
    int id;
    char letter;
    int status = 0;                                            //0 = not hovered, 1 = hovered, 2 = clicked
    int used = 0;                                              //0 = not used, 1 = green, 2 = yellow, 3 = grey
    
    public WordleKeyboardTile(float x, float y, float w, float h, int id, char letter) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.id = id;
      this.letter = letter;
    }
    
    void display() {
      pushStyle();
      fill(clr);
      rect(x, y, w, h, 7);
      fill(#904646);
      text(letter, x + w*.5, y + h*.5);
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
    
    char click() {
      if(this.status == 2){
        return this.letter;
      }
      return 'a';
    }
    
    void setLetter(char letter) {
      this.letter = letter;
    }
  }
}
