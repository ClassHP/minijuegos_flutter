import 'dart:math';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

import 'words.dart';

class WordleLogic {
  List<Block> blocks = [];
  final int width = 5;
  final int height = 6;
  String word = "";
  int x = 0;
  int y = 0;
  bool isEnd = false;
  bool isWin = false;
  final LocalStorage _storage = LocalStorage('wordle_data');
  String _strDate = '';

  Block get selected => blocks[y * width + x];
  Future get ready => _storage.ready;
  
  /*void printRandomWord() {
    print(words[Random().nextInt(words.length)]);
  }*/

  init(DateTime date) {
    x = y = 0;
    isEnd = isWin = false;
    var formatter = DateFormat('yyyyMMdd');
    _strDate = formatter.format(date);

    var data = _storage.getItem(_strDate);

    if(data != null) {
      isEnd = data['isEnd'];
      isWin = data['isWin'];
      word = data['word'];
      y = data['y'] ?? 0;
      var letters = data['letters'] as List<dynamic>;
      var colors = data['colors'] as List<dynamic>;
      blocks.clear();
      for (var i = 0; i < width * height; i++) {
        var block = Block();
        block.letter = letters[i];
        block.color = colors[i];
        blocks.add(block);
      }
    } else {
      var seed = int.parse(_strDate);
      var rand = Random(seed);
      word = words[rand.nextInt(words.length)];
      blocks.clear();
      for (var i = 0; i < width * height; i++) {
        blocks.add(Block());
      }
    }
  }

  bool onKeypress(String key) {
    if (isEnd) {
      return true;
    }
    if (key == '*') {
      return send();
    }
    if (key == '-') {
      delete();
      return true;
    }
    var block = blocks[y * width + x];
    block.letter = key;
    if (x < width - 1) {
      x++;
    }
    return true;
  }

  delete() {
    if (x > 0 && blocks[y * width + x].letter == '') {
      x--;
    }
    var block = blocks[y * width + x];
    block.letter = '';
  }

  bool send() {
    var word = '';
    for (int i = 0; i < width; i++) {
      word += blocks[y * width + i].letter;
    }
    if (word.length == width) {
      word = word.toLowerCase();
      var index = words.indexWhere((w) {
        w = _cleanWord(w);
        return word == w;
      });
      if (index >= 0) {
        var w = _cleanWord(this.word);
        for (int i = 0; i < width; i++) {
          var block = blocks[y * width + i];
          block.color = 1;
          var l = block.letter.toLowerCase();
          if (w[i] == l) {
            block.color = 2;
          } else if (w.indexOf(l) >= 0) {
            block.color = 3;
          }
        }
        if (word == w) {
          isEnd = true;
          isWin = true;
        }
        if (y < height - 1) {
          y++;
          x = 0;
        } else {
          isEnd = true;
        }
        _saveStorage();
      } else {
        return false;
      }
    }
    return true;
  }

  selectBlock(Block block) {
    if (!isEnd) {
      var index = blocks.indexOf(block);
      if (index ~/ width == y) {
        x = index - y * width;
      }
    }
  }

  _cleanWord(String w) {
    var specials = 'áéíóúü'.split('');
    var replace = 'aeiouu'.split('');
    for (var i = 0; i < specials.length; i++) {
      w = w.replaceAll(specials[i], replace[i]);
    }
    return w;
  }

  _saveStorage() {
    var value = {
      'isEnd': isEnd,
      'isWin': isWin,
      'word': word,
      'y': y,
      'letters': blocks.map((e) => e.letter).toList(),
      'colors': blocks.map((e) => e.color).toList(),
    };
    _storage.setItem(_strDate, value);
  }
}

class Block {
  int color = 0;
  String letter = '';
}
