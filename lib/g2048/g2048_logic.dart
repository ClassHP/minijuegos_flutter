import 'dart:math';

class G2048Logic {
  final List<Cell> _cells = [];
  final int _xMax = 5;
  final int _yMax = 5;
  bool _isEnd = false;
  bool _isWin = false;
  int _score = 0;

  List<Cell> get cells => _cells;
  bool get isEnd => _isEnd;
  bool get isWin => _isWin;
  int get score => _score;

  G2048Logic() {
    //var test = [0, 4, 2, 32, 8, 16, 8, 2, 4, 1024, 1024, 16, 2, 4, 8, 2];
    for (int i = 0; i < _xMax * _yMax; i++) {
      _cells.add(Cell());
      //_cells[i].value = test[i];
    }
  }

  void init() {
    _isEnd = false;
    _isWin = false;
    _score = 0;
    for (var cell in _cells) {
      cell.value = 0;
      cell.isMerge = false;
    }
    var rand1 = Random().nextInt(_cells.length);
    var rand2 = Random().nextInt(_cells.length);
    while (rand1 == rand2) {
      rand2 = Random().nextInt(_cells.length);
    }
    _cells[rand1].value = 2;
    _cells[rand2].value = 2;
  }

  void _clean() {
    for (var cell in _cells) {
      cell.isMerge = false;
      cell.isNew = false;
    }
  }

  bool _move(int dx, int dy) {
    bool isNext = false;
    for (int y = 0; y < _yMax; y++) {
      for (int x = 0; x < _xMax; x++) {
        var index = _index(x, y);
        var nextIndex = _index(x + dx, y + dy);
        if (nextIndex >= 0) {
          if (_cells[index].value != 0 && _cells[nextIndex].value == 0) {
            _cells[nextIndex].value = _cells[index].value;
            _cells[nextIndex].isMerge = _cells[index].isMerge;
            _cells[index].value = 0;
            _cells[index].isMerge = false;
            isNext = true;
          }
        }
      }
    }
    return isNext;
  }

  List<List<Cell>> _mergeList(int dx, int dy) {
    List<List<Cell>> list = [];
    for (int y = 0; y < _yMax; y++) {
      for (int x = 0; x < _xMax; x++) {
        var index = _index(x, y);
        var nextIndex = _index(x + dx, y + dy);
        if (nextIndex >= 0 &&
            _cells[index].value == _cells[nextIndex].value &&
            _cells[index].value != 0) {
          list.add([_cells[index], _cells[nextIndex]]);
        }
      }
    }
    return list;
  }

  void merge(
    int dx,
    int dy, {
    void Function()? onMove,
    void Function()? onMerge,
    void Function()? onNext,
    void Function()? onLose,
    void Function()? onWin,
  }) {
    _clean();

    bool move = false;
    while (_move(dx, dy)) {
      move = true;
    }
    if (move && onMove != null) onMove();

    var list = _mergeList(dx, dy);
    for (var item in list) {
      if (!item[0].isMerge && !item[1].isMerge && item[0].value == item[1].value) {
        item[0].value = item[1].value * 2;
        item[0].isMerge = true;
        item[1].value = 0;
        _score += item[0].value;
      }
    }
    while (list.isNotEmpty && _move(dx, dy)) {}
    if (list.isNotEmpty && onMerge != null) onMerge();

    if (list.isNotEmpty || move) {
      if (_next() && onNext != null) onNext();
    }

    if (_cells.any((element) => element.value == 2048)) {
      _isEnd = true;
      _isWin = true;
      if (onWin != null) onWin();
      return;
    }

    if (_cells.where((element) => element.value == 0).isEmpty &&
        _mergeList(1, 0).isEmpty &&
        _mergeList(0, 1).isEmpty) {
      _isEnd = true;
      if (onLose != null) onLose();
      return;
    }
  }

  bool _next() {
    var ceros = _cells.where((element) => element.value == 0).toList();
    if (ceros.isNotEmpty) {
      var rand = Random().nextInt(ceros.length);
      ceros[rand].value = 2;
      ceros[rand].isNew = true;
      return true;
    }
    return false;
  }

  int _index(int x, int y) {
    if (x < 0 || x >= _xMax || y < 0 || y >= _yMax) {
      return -1;
    }
    return y * _yMax + x;
  }
}

class Cell {
  //late int x, y;
  int value = 0;
  bool isMerge = false;
  bool isNew = false;
}
