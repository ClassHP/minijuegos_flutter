import 'dart:math';
import 'package:localstorage/localstorage.dart';
import 'package:minijuegos_flutter/buscapalabras/dictionary.dart';

class BuscapalabrasLogic {
  bool isEnd = false;
  bool isWin = false;
  bool _isValid = false;
  int score = 0;
  String longWord = '';
  final List<List<Block>> _columns = [];
  final List<Block> _selected = [];
  final LocalStorage _storage = LocalStorage('buscapalabras_data');
  final random = Random();
  final Dictionary _dictionary = Dictionary();
  late Future ready;

  List<List<Block>> get columns => _columns;
  List<Block> get selected => _selected;
  bool get isValid => _isValid;
  int get multiplier => _selected.length > 7
      ? 4
      : _selected.length > 6
          ? 3
          : _selected.length > 5
              ? 2
              : 1;
  int get addScore =>
      _selected.isNotEmpty ? _selected.map((e) => e.addScore).reduce((a, b) => a + b) : 0;

  BuscapalabrasLogic() {
    ready = Future.wait([_storage.ready, _dictionary.ready]);
  }

  init(bool loadSaved) {
    _columns.clear();
    _selected.clear();
    isEnd = false;
    isWin = false;
    _isValid = false;
    score = 0;
    longWord = '';
    if (!loadSaved || !_initSaved()) {
      do {
        var letters = _getLetters240();
        for (int i = 0; i < 10; i++) {
          List<Block> col = [];
          _columns.add(col);
          for (var j = 0; j < 24; j++) {
            //var letter = _getRandLetter();
            var letter = letters.removeAt(0);
            var addScore = _getAddScore(letter);
            col.add(Block(letter, addScore));
          }
        }
      } while (_isEndEval());
      _saveStorage();
    }
  }

  select(Block block) {
    block.selected = true;
    _selected.add(block);
    _isValid = _isValidWord();
  }

  deselect(Block block) {
    var index = _selected.indexOf(block);
    _selected.getRange(index, _selected.length).forEach((element) {
      element.selected = false;
    });
    _selected.removeRange(index, _selected.length);
    _isValid = _isValidWord();
  }

  bool send() {
    if (_isValid) {
      _isValid = false;
      score += addScore * multiplier;
      for (var col in _columns) {
        col.removeWhere((block) => block.selected);
      }
      _columns.removeWhere((element) => element.isEmpty);
      var wordSelected = _selected.map((e) => e.letter).join();
      longWord = longWord.length < wordSelected.length ? wordSelected : longWord;
      _selected.clear();
      isEnd = _isEndEval();
      _saveStorage();
      return true;
    }
    return false;
  }

  bool _isEndEval() {
    if (_columns.any((element) => element.isEmpty)) {
      return true;
    }
    for (var col in _columns) {
      if (_isWordExistRec('', col)) {
        return false;
      }
    }
    return true;
  }

  bool _isWordExistRec(String word, List<Block> col) {
    if (col.isNotEmpty && word.length < 23) {
      var block = col.removeLast();
      word += block.letter;
      if (word.length >= 2) {
        if (!_dictionary.startsWith(word)) {
          col.add(block);
          return false;
        }
        if (_dictionary.exists(word)) {
          col.add(block);
          return true;
        }
      }
      for (var col2 in _columns) {
        if (col2.isNotEmpty && _isWordExistRec(word, col2)) {
          col.add(block);
          return true;
        }
      }
      col.add(block);
    }
    return false;
  }

  bool _isValidWord() {
    if (_selected.length > 1) {
      var wordSelected = _selected.map((e) => e.letter).join();
      return _dictionary.exists(wordSelected);
    }
    return false;
  }

  bool _initSaved() {
    var data = _storage.getItem('saved');
    if (data == null) {
      return false;
    }
    score = data['score'];
    longWord = data['longWord'] ?? '';
    var columns = data['columns'];
    for (var column in columns) {
      List<Block> col = [];
      _columns.add(col);
      for (var letter in column.split('')) {
        var addScore = _getAddScore(letter);
        col.add(Block(letter, addScore));
      }
    }
    return true;
  }

  _saveStorage() {
    if (!isEnd) {
      var value = {
        'score': score,
        'longWord': longWord,
        'columns': _columns.map((e) => e.map((f) => f.letter).join()).toList(),
      };
      _storage.setItem('saved', value);
    } else {
      _storage.deleteItem('saved');
    }
  }

  List<String> _getLetters240() {
    const lett = {
      "A": 30,
      "E": 23,
      "O": 23,
      "I": 20,
      "R": 20,
      "N": 15,
      "S": 15,
      "C": 12,
      "T": 12,
      "L": 10,
      "D": 9,
      "M": 8,
      "B": 7,
      "U": 7,
      "P": 6,
      "G": 4,
      "F": 3,
      "H": 3,
      "J": 3,
      "V": 3,
      "K": 1,
      "Ñ": 1,
      "Q": 1,
      "W": 1,
      "X": 1,
      "Y": 1,
      "Z": 1
    };
    var allLett = '';
    for (var l in lett.entries) {
      allLett += ''.padLeft(l.value, l.key);
    }
    var arr = allLett.split('');
    arr.shuffle(random);
    return arr;
  }

  _getAddScore(String letter) {
    const abcScore = {
      "A": 1,
      "E": 1,
      "O": 1,
      "I": 2,
      "R": 2,
      "N": 3,
      "S": 3,
      "C": 3,
      "T": 3,
      "L": 3,
      "D": 4,
      "M": 4,
      "B": 5,
      "U": 5,
      "P": 6,
      "G": 7,
      "F": 8,
      "H": 8,
      "J": 8,
      "V": 8,
      "K": 9,
      "Ñ": 9,
      "Q": 9,
      "W": 9,
      "X": 9,
      "Y": 9,
      "Z": 9
    };
    return abcScore[letter];
  }
}

class Block {
  String letter = '';
  int addScore = 1;
  bool selected = false;

  Block(this.letter, this.addScore);
}
