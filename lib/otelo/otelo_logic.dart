import 'dart:math';

class OteloLogic {
  final List<Box> _boxes = [];
  final _GameType _type = _GameType.otelo;
  final List<Player> _players = [Player(player: 0), Player(player: 1)];
  late Player _turn;
  bool _end = true;

  List<Box> get boxes => _boxes;
  bool get end => _end;
  List<Player> get players => _players;

  OteloLogic() {
    for (int i = 0; i < 64; i++) {
      _boxes.add(Box(x: _x(i), y: _y(i)));
    }
  }

  void init(PlayerType type, int turn) {
    _end = false;
    _turn = _players[turn];
    _players[1].type = type;
    _players[0].score = _type == _GameType.otelo ? 2 : 0;
    _players[1].score = _type == _GameType.otelo ? 2 : 0;
    for (var box in _boxes) {
      box.player = null;
      box.selected = false;
      if (_type == _GameType.otelo &&
          (box.x == 3 || box.x == 4) &&
          (box.y == 3 || box.y == 4)) {
        box.player = box.x == box.y ? 1 : 0;
        box.selected = true;
      }
    }
    _setTurn(turn);
  }

  Future<void> setChip(Box box) async {
    if (!_end && !box.selected && box.player != null) {
      box.selected = true;
      _players[box.player ?? 0].score++;
      var items = _getItemsFlip(box);
      for (var item in items) {
        _players[item?.player ?? 0].score--;
        item?.player = _turn.player;
        _players[item?.player ?? 0].score++;
      }
      if (!_setTurn(_turn == _players[0] ? 1 : 0)) {
        _end = !_setTurn(_turn == _players[0] ? 1 : 0);
      }
      await Future.delayed(const Duration(milliseconds: 500), () async {
        await _playIa();
      });
    }
  }

  void stop() {
    _end = true;
  }

  int _x(int index) {
    return index - _y(index) * 8;
  }

  int _y(int index) {
    return (index / 8).floor();
  }

  int? _index(int x, int y) {
    if (x < 0 || x > 7 || y < 0 || y > 7) {
      return null;
    }
    return y * 8 + x;
  }

  Box? _boxIndex(int x, int y) {
    int? index = _index(x, y);
    if (index != null) {
      return _boxes[index];
    }
    return null;
  }

  bool _setTurn(int turn) {
    bool pass = true;
    _turn = _players[turn];
    _end = true;
    for (var box in _boxes) {
      if (!box.selected) {
        _end = false;
        box.player = null;
        if ((box.x == 3 || box.x == 4) && (box.y == 3 || box.y == 4)) {
          box.player = _turn.player;
          pass = false;
        }
        if (_getItemsFlip(box).isNotEmpty) {
          box.player = _turn.player;
          pass = false;
        }
      }
    }
    return !pass;
  }

  List<Box?> _getItemsFlip(Box box) {
    List<Box?> itemsFlip = [];
    for (int lx = -1; lx < 2; lx++) {
      for (int ly = -1; ly < 2; ly++) {
        if (lx != 0 || ly != 0) {
          var lbox = _boxIndex(box.x + lx, box.y + ly);
          if (lbox?.selected == true && lbox?.player != _turn.player) {
            List<Box?> items = [lbox];
            for (int li = 1; li < 8; li++) {
              lbox = _boxIndex(box.x + lx * li, box.y + ly * li);
              if (lbox?.selected == true) {
                if (lbox?.player == _turn.player) {
                  itemsFlip.addAll(items);
                  break;
                } else {
                  items.add(lbox);
                }
              } else {
                break;
              }
            }
          }
        }
      }
    }
    return itemsFlip;
  }

  int _getPriority(Box box) {
    const priorities = [
      [9, 0, 7, 8, 8, 7, 0, 9],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [7, 1, 6, 6, 6, 6, 1, 8],
      [8, 1, 6, 5, 5, 6, 1, 8],
      [8, 1, 6, 5, 5, 6, 1, 8],
      [7, 1, 6, 6, 6, 6, 1, 7],
      [0, 0, 1, 1, 1, 1, 0, 0],
      [9, 0, 7, 8, 8, 7, 0, 9],
    ];
    return priorities[box.x][box.y];
  }

  Future<void> _playIa() async {
    while (_turn.type == PlayerType.ia) {
      var boxes =
          _boxes.where((box) => !box.selected && box.player != null).toList();
      boxes.sort((a, b) => _getPriority(b) - _getPriority(a));
      var first = boxes.first;
      boxes = boxes
          .where((box) => _getPriority(box) == _getPriority(first))
          .toList();
      if (boxes.length > 1) {
        List<MapEntry<Box, int>> max = boxes
            .map<MapEntry<Box, int>>(
                (e) => MapEntry(e, _getItemsFlip(e).length))
            .toList();
        max.sort((a, b) => b.value - a.value);
        boxes = max
            .where((box) => box.value == max.first.value)
            .map((e) => e.key)
            .toList();
      }
      var box = boxes[Random().nextInt(boxes.length)];
      await setChip(box);
    }
  }
}

enum PlayerType { person, ia, online }

enum _GameType { otelo, reversi }

class Box {
  int? player;
  bool selected = false;
  int x, y;

  Box({required this.x, required this.y});
}

class Player {
  int player;
  bool turn = false;
  int score = 0;
  PlayerType type = PlayerType.person;

  Player({required this.player});
}
