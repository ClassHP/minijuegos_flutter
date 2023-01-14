import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class Dictionary {
  late Future ready;
  static final Map<String, Set<String>> _mapDic = {};

  Dictionary() {
    ready = loadData();
  }

  Future<void> loadData() async {
    if (_mapDic.isNotEmpty) {
      return;
    }
    var aff = await _loadAsset('assets/files/dictionary-es.aff');
    var dic = await _loadAsset('assets/files/dictionary-es.dic');
    Map<String, List<_Rule>> mapAff = {};
    Map<String, List<String>> mapDic = {};

    var affLines = aff.split('\n');
    for (var line in affLines) {
      if (line.startsWith('SFX') || line.startsWith('PFX')) {
        var lineSplit = line.split(' ');
        if (lineSplit.length == 5) {
          if (mapAff[lineSplit[1]] == null) {
            mapAff[lineSplit[1]] = [];
          }
          var rule = _Rule();
          mapAff[lineSplit[1]]?.add(rule);
          var addSplit = lineSplit[3].split('/');
          rule.add = addSplit[0] == '0' ? '' : addSplit[0];
          rule.continuation = addSplit.length == 2 ? addSplit[1].split('') : [];
          if (lineSplit[0] == 'SFX') {
            rule.match = RegExp('${lineSplit[4]}\$');
            rule.remove = RegExp('${lineSplit[2] == '0' ? '' : lineSplit[2]}\$');
          }
          if (lineSplit[0] == 'PFX') {
            rule.match = RegExp('^${lineSplit[4]}');
            rule.remove = RegExp('^${lineSplit[2] == '0' ? '' : lineSplit[2]}');
          }
        }
      }
    }

    var dicLines = dic.split('\n');
    dicLines.removeAt(0);
    for (var line in dicLines) {
      var lineSplit = line.split('/');
      mapDic[lineSplit[0]] = lineSplit.length == 2 ? lineSplit[1].split('') : [];
      _addMapDic(lineSplit[0]);
    }

    for (var wordIndex in mapDic.keys.toList()) {
      var rules = mapDic[wordIndex]!;
      for (var ruleIndex in rules) {
        var rule = mapAff[ruleIndex];
        if (rule != null) {
          for (var entry in rule) {
            if (entry.match.hasMatch(wordIndex)) {
              var nextWord = wordIndex.replaceFirst(entry.remove, entry.add);
              mapDic[nextWord] = mapDic[nextWord] ?? [];
              _addMapDic(nextWord);
              for (var contRuleIndex in entry.continuation) {
                var rule2 = mapAff[contRuleIndex];
                if (rule2 != null) {
                  for (var entry2 in rule2) {
                    if (entry2.match.hasMatch(nextWord)) {
                      var w = nextWord.replaceFirst(entry2.remove, entry2.add);
                      mapDic[w] = mapDic[w] ?? [];
                      _addMapDic(w);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  bool exists(String word) {
    word = word.toLowerCase();
    return _mapDic[word[0]]!.contains(word);
  }

  bool startsWith(String word) {
    word = word.toLowerCase();
    return _mapDic[word[0]]!.any((element) => element.startsWith(word));
  }

  void _addMapDic(String word) {
    //_mapDic[word] = true;
    if (word.length >= 2) {
      if (_mapDic[word[0]] == null) {
        _mapDic[word[0]] = {};
      }
      _mapDic[word[0]]!.add(_cleanWord(word.toLowerCase()));
    }
  }

  Future<String> _loadAsset(String key) async {
    return await rootBundle.loadString(key);
  }

  String _cleanWord(String w) {
    var specials = 'áéíóúü'.split('');
    var replace = 'aeiouu'.split('');
    for (var i = 0; i < specials.length; i++) {
      w = w.replaceAll(specials[i], replace[i]);
    }
    return w;
  }
}

class _Rule {
  late String add;
  late RegExp remove;
  late RegExp match;
  late List<String> continuation;
}
