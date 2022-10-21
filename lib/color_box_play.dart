import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ColorBoxPlayPage extends StatefulWidget {
  const ColorBoxPlayPage({super.key});

  @override
  State<ColorBoxPlayPage> createState() => _ColorBoxPlayPageState();
}

class _ColorBoxPlayPageState extends State<ColorBoxPlayPage> {
  int _score = 0;
  int _speed = 0;
  Color? _currentColor;
  int _countSelected = 0;
  Timer? _timer;
  final List<ColorBox> _colorBoxs = [];
  final int _maxColumn = 4;
  final int _maxRow = 6;
  final int _speedStart = 1000;
  final int _speedAdd = 30;
  final int _speedMax = 100;

  void _addColorBox() {
    setState(() {
      _colorBoxs.add(ColorBox());
    });
  }

  void _removeSelectedColorBox() {
    _countSelected = 0;
    _currentColor = null;
    setState(() {
      _colorBoxs.removeWhere((element) => element.selected);
      _score += 3;
    });
  }

  void _selectColorBox(ColorBox colorBox) {
    if (_currentColor == null || colorBox.color == _currentColor) {
      if (!colorBox.selected) {
        _countSelected++;
        _currentColor = colorBox.color;
        setState(() {
          colorBox.selected = true;
        });
      }
      if (_countSelected == 3) {
        _removeSelectedColorBox();
        _stop();
        _speed = _speed < _speedMax ? _speedMax : _speed - _speedAdd;
        _start();
      }
    }
  }

  void _play() {
    if (_timer == null) {
      _addColorBox();
      _speed = _speedStart;
      _start();
    }
  }

  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: _speed), (timer) {
      _addColorBox();
      if (_isEnd()) {
        _end();
      }
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _end() {
    _stop();
    var score = _score;
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('¡Final de la partida!'),
        content: Text('Tu puntuanión fue de: $score'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    ).then((value) => GoRouter.of(context).pop());
  }

  bool _isEnd() {
    return _colorBoxs.length >= _maxColumn * _maxRow;
  }

  @override
  void initState() {
    super.initState();
    _play();
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ColorBox"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {},
            child: Text("Puntuación: $_score"),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: AspectRatio(
          aspectRatio: _maxColumn / _maxRow,
          child: GridView.count(
            crossAxisCount: _maxColumn,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(8),
            childAspectRatio: 1,
            children: _colorBoxs.map<Widget>((colorBox) {
              return Container(
                margin: EdgeInsets.all(colorBox.selected ? 12 : 8),
                child: InkWell(
                  onTapDown: (details) {
                    _selectColorBox(colorBox);
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      color: colorBox.color,
                      borderRadius: BorderRadius.all(
                        Radius.circular(colorBox.selected ? 24 : 8),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class ColorBox {
  static final _rng = Random();
  static final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow
  ];

  Color color = Colors.black;
  int colorId = 0;
  bool selected = false;

  ColorBox() {
    colorId = _rng.nextInt(_colors.length);
    color = _colors[colorId];
  }

  void toggle() {
    selected = !selected;
  }
}
