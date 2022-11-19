import 'dart:math';

class BuscaminasLogic {
  final List<Block> _blocks = [];
  int _mines = 0, _width = 0, _height = 0;
  bool _isEnd = false;
  bool _isWin = false;
  final Random _rand = Random();

  List<Block> get blocks => _blocks;
  int get width => _width;
  int get height => _height;
  int get mines => _mines;
  int get flags => _blocks.where((b) => b.flag).length;
  bool get isEnd => _isEnd;
  bool get isWin => _isWin;

  BuscaminasLogic();

  init(int width, int height, int mines) {
    _isEnd = false;
    _isWin = false;
    _width = width;
    _height = height;
    _mines = mines;
    _blocks.clear();
    for(int i = 0; i < _width * _height; i++) {
      _blocks.add(Block(_x(i), _y(i), 0));
    }
    while(mines > 0) {
      int x = _rand.nextInt(_width);
      int y = _rand.nextInt(_height);
      int i = _index(x, y)!;
      if(_blocks[i].count != -1) {
        _blocks[i].count = -1;
        mines--;
      }
    }
    for(var block in _blocks) {
      if(block.count != -1) {
        block.count = _around(block).where((b) => b.count == -1).length;
      }
    }
  }

  void selectBlock(Block block) {
    if(_isEnd || block.flag) return;
    if (block.count == -1 && _blocks.where((b) => b.show).isEmpty) {
      do {
        var index = _blocks.indexOf(block);
        init(_width, _height, _mines);
        block = _blocks[index];
      } while(block.count == -1);
    }    
    block.show = true;
    if(block.count == 0) {
      List<Block> fifo = [block];
      while(fifo.isNotEmpty) {
        var first = fifo.removeAt(0);
        var around = _around(first);
        for(var b in around) {
          if(b.count == 0 && !b.show) {
            fifo.add(b);
          }
          b.show = true;
        }
      }
    } else if (block.count == -1) {
      _isEnd = true;
      _blocks.where((b) => b.count == -1).forEach((b) { b.show = true; });
    }
    if(!_isEnd && _blocks.where((b) => !b.show).length == _mines) {
      _isEnd = true;
      _isWin = true;
    }
  }

  List<Block> _around(Block block) {
    List<Block> list = [];
    for(int x = -1; x < 2; x++) {
      for(int y = -1; y < 2; y++) {
        var i = _index(block.x + x, block.y + y);
        if(i != null) {
          list.add(_blocks[i]);
        }
      }
    }
    return list;
  }

  int _x(int index) {
    return index - _y(index) * _width;
  }

  int _y(int index) {
    return (index / _width).floor();
  }

  int? _index(int x, int y) {
    if (x < 0 || x >= _width || y < 0 || y >= _height) {
      return null;
    }
    return y * _width + x;
  }
}

class Block {
  int x, y;
  int count = 0;
  bool selected = false;
  bool show = false;
  bool flag = false;

  Block(this.x, this.y, this.count);
}