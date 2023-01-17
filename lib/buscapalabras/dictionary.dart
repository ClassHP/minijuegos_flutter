import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class Dictionary {
  late Future<void> _ready;
  Future<void> get ready => _ready;
  static final Map<String, Set<String>> _mapDic = {};
  int _wordCount = 0;

  Dictionary() {
    _ready = _loadFileWords();
  }

  Future<void> _loadFileWords() async {
    if (_mapDic.isEmpty) {
      var file = await _loadAsset('assets/files/buscapalabras.txt');
      var words = file.split('\r\n');
      for (var word in words) {
        _addMapDic(word);
      }
    }
    //print(_wordCount);
  }

  bool exists(String word) {
    return _mapDic[word[0]]!.contains(word);
  }

  bool startsWith(String word) {
    return _mapDic[word[0]]!.any((element) => element.startsWith(word));
  }

  void _addMapDic(String word) {
    if (word.length >= 2) {
      if (_mapDic[word[0]] == null) {
        _mapDic[word[0]] = {};
      }
      _mapDic[word[0]]!.add(word);
      _wordCount++;
    }
  }

  Future<String> _loadAsset(String key) async {
    return await rootBundle.loadString(key);
  }
}
