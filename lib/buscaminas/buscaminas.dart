import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minijuegos_flutter/buscaminas/buscaminas_logic.dart';
import 'package:minijuegos_flutter/buscaminas/buscaminas_service.dart';
import 'package:minijuegos_flutter/widgets/fitted_text.dart';
import 'package:minijuegos_flutter/widgets/info_box.dart';

class Buscaminas extends StatefulWidget {
  const Buscaminas({Key? key}) : super(key: key);

  @override
  createState() => _BuscaminasState();
}

class _BuscaminasState extends State<Buscaminas> {
  final BuscaminasLogic _logic = BuscaminasLogic();
  final BuscaminasService _service = BuscaminasService();
  int _seconds = 0;
  bool _isStart = false;
  String _dificultad = 'Medio';

  _BuscaminasState() {
    _logic.init(8, 12, 20);
    Timer.periodic(const Duration(milliseconds: 1000), _timerCallback);
  }

  String _time() =>
      '${'${_seconds ~/ 60}'.padLeft(2, '0')}:${'${_seconds - (_seconds ~/ 60) * 60}'.padLeft(2, '0')}';

  String _flags() => (_logic.mines - _logic.flags).toString().padLeft(2, '0');

  _init() {
    setState(() {
      if (_dificultad == 'Fácil') {
        _logic.init(6, 8, 10);
      }
      if (_dificultad == 'Medio') {
        _logic.init(8, 12, 20);
      }
      if (_dificultad == 'Difícil') {
        _logic.init(10, 15, 40);
      }
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

  _onPressedBlock(Block block, bool isLong) {
    if (_logic.isEnd) return;
    _isStart = true;
    setState(() {
      if (!isLong) {
        _logic.selectBlock(block);
        if (_logic.isWin) {
          _showWin();
        }
      } else if (block.flag || _logic.flags < _logic.mines) {
        block.flag = !block.flag;
      }
    });
  }

  _showScore() {
    _service.showScore(context);
  }

  Future<void> _showWin() {
    return _service.showWin(context, _logic.mines, _seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscaminas'),
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
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PopupMenuButton<String>(
                  onSelected: (String item) {
                    setState(() {
                      _dificultad = item;
                    });
                    _init();
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Fácil',
                      child: Text('Fácil'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Medio',
                      child: Text('Medio'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Difícil',
                      child: Text('Difícil'),
                    ),
                  ],
                  child:
                      InfoBox(text: _dificultad, icon2: Icons.arrow_drop_down),
                ),
                const SizedBox(width: 20),
                InfoBox(text: _flags(), icon1: Icons.flag),
                const SizedBox(width: 20),
                InfoBox(
                    text: _time(),
                    color: Colors.deepPurpleAccent,
                    icon1: Icons.access_time),
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: AspectRatio(
                aspectRatio: _logic.width / _logic.height,
                child: _Board(
                  logic: _logic,
                  onPressed: _onPressedBlock,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
  final List<Color> _colors = [
    Colors.red,
    Colors.transparent,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.deepOrange,
    Colors.cyan,
    Colors.pink,
    Colors.blueGrey,
    Colors.red,
  ];
  final BuscaminasLogic _logic;
  final void Function(Block, bool) onPressed;

  _Board({Key? key, required BuscaminasLogic logic, required this.onPressed})
      : _logic = logic,
        super(key: key);

  Color _color(Block block) {
    return _colors[block.count + 1];
  }

  @override
  Widget build(BuildContext context) {
    const mineWidget = SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Icon(
          Icons.dangerous_rounded,
          color: Colors.red,
        ),
      ),
    );
    const flagWidget = SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Icon(
          Icons.flag,
          color: Colors.purple,
        ),
      ),
    );

    return GridView.count(
      crossAxisCount: _logic.width,
      mainAxisSpacing: 0.3,
      crossAxisSpacing: 0.3,
      childAspectRatio: 1,
      physics: const NeverScrollableScrollPhysics(),
      children: _logic.blocks.map<Widget>((cell) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                //color: _logic.blocks.indexOf(cell) % 2 == 0 ? Colors.blueGrey.shade100 : Colors.blueGrey.shade200,
                //borderRadius: const BorderRadius.all(Radius.circular(2)),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(2),
                child: cell.count > 0 && cell.show
                    ? FittedText(
                        cell.count.toString(),
                        color: _color(cell),
                        fontWeight: FontWeight.bold,
                      )
                    : cell.count == -1
                        ? mineWidget
                        : null,
              ),
            ),
            AnimatedFractionallySizedBox(
              widthFactor: !cell.show ? 1.0 : 0.0,
              heightFactor: !cell.show ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: () {
                  onPressed(cell, false);
                },
                onLongPress: () {
                  onPressed(cell, true);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    //color: Colors.lightBlue[200],
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Color.fromARGB(255, 129, 212, 250),
                        Colors.lightBlue,
                      ],
                    ),
                  ),
                  child: cell.flag ? flagWidget : null,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
