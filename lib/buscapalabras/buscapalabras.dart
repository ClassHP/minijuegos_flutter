import 'package:flutter/material.dart';
import 'package:minijuegos_flutter/buscapalabras/buscapalabras_logic.dart';
import 'package:minijuegos_flutter/widgets/download_android_bar.dart';
import 'package:minijuegos_flutter/widgets/fitted_text.dart';
import 'package:minijuegos_flutter/widgets/info_box.dart';

class Buscapalabras extends StatefulWidget {
  const Buscapalabras({Key? key}) : super(key: key);

  @override
  createState() => _BuscapalabrasState();
}

class _BuscapalabrasState extends State<Buscapalabras> {
  final BuscapalabrasLogic _logic = BuscapalabrasLogic();

  _score() => _logic.score.toString().padLeft(4, '0');

  _onTapBlock(Block block) {
    setState(() {
      _logic.select(block);
    });
  }

  _onTapSelected(Block block) {
    setState(() {
      _logic.deselect(block);
    });
  }

  _onSend() {
    setState(() {
      _logic.send();
    });
  }

  _init() {
    setState(() {
      _logic.init(false);
    });
  }

  String _strAddScore() {
    return (_logic.addScore > 0 ? '+${_logic.addScore}' : '') +
        (_logic.multiplier > 1 ? 'x${_logic.multiplier}' : '');
  }

  @override
  void initState() {
    super.initState();
    _logic.ready.then((value) {
      setState(() {
        _logic.init(false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Busca palabras'),
        actions: [
          IconButton(
            onPressed: _init,
            icon: Icon(_logic.isEnd ? Icons.play_arrow : Icons.refresh),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.timeline),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _Board(_logic, _onTapBlock),
            const SizedBox(height: 10),
            _BoardSelected(_logic, _onTapSelected),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoBox(text: _score(), icon1: Icons.timeline),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: Text('Enviar ${_strAddScore()}'),
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      minimumSize: const Size(100, 43)),
                  onPressed: _logic.isValid ? _onSend : null,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const DownloadAndroidBar(),
    );
  }
}

class _Board extends StatelessWidget {
  final BuscapalabrasLogic _logic;
  final void Function(Block) _onTapBlock;

  const _Board(this._logic, this._onTapBlock, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        children: _logic.columns.map<Widget>((col) {
          var cells = col.where((e) => !e.selected);
          return Flexible(
            child: Column(
              //mainAxisSize: MainAxisSize.min,
              children: cells.map<Widget>((block) {
                if (cells.last == block) {
                  return _Block(block, _onTapBlock);
                }
                return SizedBox(
                  height: 18,
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    //minHeight: 0,
                    maxHeight: double.infinity,
                    child: _Block(block, null),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BoardSelected extends StatelessWidget {
  final BuscapalabrasLogic _logic;
  final void Function(Block) _onTapBlock;

  const _BoardSelected(this._logic, this._onTapBlock, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: _logic.selected.map<Widget>((block) {
          return Flexible(
            child: LimitedBox(
              maxHeight: 50,
              maxWidth: 50,
              child: _Block(block, _onTapBlock),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  final Block _block;
  final void Function(Block)? _onTapBlock;
  final List<Color> _colors = [
    Colors.transparent,
    Colors.grey.shade200,
    Colors.brown.shade200,
    Colors.deepOrange.shade200,
    Colors.amber.shade200,
    Colors.green.shade200,
    Colors.cyan.shade200,
    Colors.blue.shade200,
    Colors.purple.shade200,
    Colors.pink.shade200,
  ];

  _Block(this._block, this._onTapBlock, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget box = Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.blueGrey,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        elevation: 10,
        shadowColor: Colors.black,
        child: InkWell(
          onTap: _onTapBlock != null ? () => _onTapBlock!(_block) : null,
          splashColor: Colors.greenAccent,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: FittedText(
                  _block.letter,
                  color: Theme.of(context).textTheme.headline5!.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Positioned(
                bottom: 1,
                right: 2,
                child: Text(
                  _block.addScore.toString(),
                  style: TextStyle(
                    color: _colors[_block.addScore],
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        color: Colors.black87,
                        offset: Offset(-0.5, -0.5),
                        blurRadius: 2,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: box,
      ),
    );
  }
}
