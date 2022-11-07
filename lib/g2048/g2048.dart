import 'dart:async';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minijuegos_flutter/g2048/g2048_logic.dart';
import 'package:minijuegos_flutter/g2048/g2048_score.dart';

class G2048 extends StatefulWidget {
  const G2048({Key? key}) : super(key: key);

  @override
  createState() => _G2048State();
}

class _G2048State extends State<G2048> {
  final G2048Logic _logic = G2048Logic();
  final G2048Score _g2048Score = G2048Score();
  int _seconds = 0;
  bool _isStart = false;

  _G2048State() {
    _logic.init();
    Timer.periodic(const Duration(milliseconds: 1000), _timerCallback);
  }

  String _time() =>
      '${'${_seconds ~/ 60}'.padLeft(2, '0')}:${'${_seconds - (_seconds ~/ 60) * 60}'.padLeft(2, '0')}';

  String _score() => _logic.score.toString().padLeft(5, '0');

  _init() {
    setState(() {
      _logic.init();
      _seconds = 0;
      _isStart = false;
    });
  }

  _timerCallback(Timer _) {
    if (!_logic.isEnd && _isStart) {
      setState(() {
        _seconds++;
      });
    }
  }

  _onPanBoard(double dx, double dy) async {
    if (_logic.isEnd) return;
    if (!_isStart) _isStart = true;
    int idx = dx > 0 ? 1 : (dx < 0 ? -1 : 0);
    int idy = dy > 0 ? 1 : (dy < 0 ? -1 : 0);

    setState(() {
      _logic.merge(idx, idy, onMove: () => setState(() {}),);
    });

    if(_logic.isEnd) {
      if(_logic.isWin) {
        await _showWin();
      } else {
        await _showLose();
      }
    }
  }

  Future<void> _showWin() {
    return _g2048Score.showWin(context, _logic.score, _seconds);
  }

  Future<void> _showLose() {
    return _g2048Score.showLose(context, _logic.score, _seconds);
  }

  Future<void> _showScore() {
    return _g2048Score.showScore(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2048"),
        actions: [
          IconButton(
            onPressed: _init,
            icon: Icon(_logic.isEnd ? Icons.play_arrow : Icons.refresh),
          ),
          IconButton(
            onPressed: _showScore,
            icon: const Icon(Icons.timeline),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Text(
                    _score(),
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(width: 5),
                      Text(
                        _time(),
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                /*const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _logic.isEnd
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: _init,
                  child: Icon(_logic.isEnd ? Icons.play_arrow : Icons.refresh),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: const EdgeInsets.all(14),
                  ),
                  onPressed: _showScore,
                  child: const Icon(Icons.timeline),
                )*/
              ],
            ),
            const SizedBox(height: 20),
            Flexible(
              child: AspectRatio(
                aspectRatio: 1,
                child: _BoardGesture(
                  onPan: _onPanBoard,
                  child: _Board(logic: _logic),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Arrastra horizontal o verticalmente para sumar los números hasta llegar al 2048.'),
          ],
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
  final List<Color> _colors = [
    Colors.purple[50]!,
    Colors.purple[100]!,
    Colors.purple[200]!,
    Colors.purple[400]!,
    Colors.purple[500]!,
    Colors.purple[600]!,
    Colors.purple[700]!,
    Colors.purple[800]!,
    Colors.purple[900]!,
    Colors.amber,
    Colors.amber[600]!,
    Colors.amber[700]!,
    Colors.teal[300]!,
    Colors.teal[400]!,
    Colors.teal,
  ];
  final G2048Logic _logic;

  _Board({
    Key? key,
    required G2048Logic logic,
  })  : _logic = logic,
        super(key: key);

  double _logBase(num x, num base) => log(x) / log(base);
  double _log2(num x) => _logBase(x, 2);

  Color _color(int val) {
    if (val == 0) {
      return Colors.grey;
    }
    var index = _log2(val).toInt();
    if (index >= 0 && index < _colors.length) {
      return _colors[index];
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      childAspectRatio: 1,
      physics: const NeverScrollableScrollPhysics(),
      children: _logic.cells.map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: AnimatedFractionallySizedBox(
            //visible: cell.value != 0,
            widthFactor: cell.value != 0 ? 1.0 : 0.0,
            heightFactor: cell.value != 0 ? 1.0 : 0.0,
            duration: Duration(milliseconds: cell.isNew ? 500 : 100),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _color(cell.value),
                borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
              child: cell.value != 0
                  ? FittedText(text: cell.value.toString())
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class FittedText extends StatelessWidget {
  final String _text;

  const FittedText({
    Key? key,
    required String text,
  })  : _text = text,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Text(
        _text,
        style: const TextStyle(fontSize: 500),
      ),
    );
  }
}

class _BoardGesture extends StatelessWidget {
  final Widget _child;
  final Function(double, double) _onPan;

  const _BoardGesture({
    Key? key,
    required Function(double dx, double dy) onPan,
    required Widget child,
  })  : _onPan = onPan,
        _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    double? initialX;
    double? distanceX;
    double? initialY;
    double? distanceY;
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        initialX = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if(initialX != null) {
          distanceX = details.globalPosition.dx - initialX!;
        }
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        initialX = null;
        if (distanceX != null && distanceX != 0) {
          _onPan(distanceX!, 0);
        }
      },
      onVerticalDragStart: (DragStartDetails details) {
        initialY = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if(initialY != null) {
          distanceY = details.globalPosition.dy - initialY!;
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        initialY = null;
        if (distanceY != null && distanceY != 0) {
          _onPan(0, distanceY!);
        }
      },
      dragStartBehavior: DragStartBehavior.start,
      behavior: HitTestBehavior.translucent,
      child: _child,
    );
  }
}
