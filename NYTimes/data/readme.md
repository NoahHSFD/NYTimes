# NYTimes Games at home

Mom, can we get NYTimes Games?
We have NYTimes Games at home, honey.

## Templates for game files

### Wordle

Create txt file ***.txt with each word in a new line.
Load in your txt file in Wordle constructor inside the Wordle class.
Random word from list will be selected
Example:
```
killua
bobby
ryo
nijika
kita
shirase
araragi
keijo
...
```
### Strands

Create JSON Array ***.json with dimensions 6x8 (IDs 0-47 have to be filled).
Load in your JSON Array in Strands constructor inside the Strands class.
Example:
```
[
  {
    "word":"yorimoi",
    "length":7,
    "ids":[6, 0, 1, 2, 3, 4, 5],
    "spangram":false
  },
  {
    "word":"heroaca",
    "length":7,
    "ids":[7, 8, 9, 10, 11, 17, 16],
    "spangram":false
  },
  {
    "word":"abbrevs",
    "length":7,
    "ids":[20, 19, 18, 12, 13, 14, 15],
    "spangram":true
  },...
]
```
### Crossword

Create txt file ***.txt with letters for words and '-' for empty spaces.
Load in your txt file in Crossword constructor inside the Crossword class.
Example:
```
SATOU--
H-RAM--
ISEKAID
ONE-T-E
-A--ORE
-FEAR-P
RUN-A--
```
### 