import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:minijuegos_flutter/tools.dart';
import 'package:minijuegos_flutter/widgets/download_android_bar.dart';
import 'package:minijuegos_flutter/widgets/fitted_text.dart';
import 'package:minijuegos_flutter/wordle/keyboard.dart';
import 'package:minijuegos_flutter/wordle/wordle_logic.dart';
import 'package:share_plus/share_plus.dart';

class Wordle extends StatefulWidget {
  const Wordle({Key? key}) : super(key: key);

  @override
  createState() => _WordleState();
}

class _WordleState extends State<Wordle> {
  final WordleLogic _logic = WordleLogic();
  DateTime _dateSelected = DateTime.now();
  String _nextAt = '';
  DateTime _today = DateTime.now();
  late Timer _timer;

  _WordleState() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), _timerCallback);
  }

  _timerCallback(Timer _) {
    //_logic.printRandomWord();
    var now = DateTime.now();
    var tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    var dateDif = tomorrow.difference(now);
    setState(() {
      _nextAt = dateDif.toString().split('.')[0];
      if (_logic.isEnd && _today.day != now.day) {
        _today = _dateSelected = now;
        _logic.init(_dateSelected);
      }
    });
  }

  _onTap(String key) {
    setState(() {
      if (!_logic.onKeypress(key)) {
        Fluttertoast.showToast(
            msg: "Palabra no encontrada.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
            webPosition: "center center");
      }
    });
  }

  Color _setColor(String key) {
    if (key == '*') {
      return Colors.blue;
    }
    if (key == '-') {
      return Colors.orange;
    }
    for (var block in _logic.blocks) {
      if (block.letter == key && block.color == 1) {
        return Colors.black45;
      }
    }
    return Colors.blueGrey;
  }

  _onTapBlock(Block block) {
    setState(() {
      _logic.selectBlock(block);
    });
  }

  void _showCalendar() {
    showDatePicker(
      context: context,
      initialDate: _dateSelected,
      firstDate: DateTime.now().add(const Duration(days: -365)),
      lastDate: DateTime.now(),
    ).then((date) {
      _dateSelected = date ?? DateTime.now();
      setState(() {
        _logic.init(_dateSelected);
      });
    });
  }

  _share() {
    Share.share('¡Te reto a descubrir la palabra del día! https://minijuegosf.web.app/#/wordle');
  }

  @override
  void initState() {
    super.initState();
    _logic.ready.then((value) {
      setState(() {
        _logic.init(_dateSelected);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var endWidget = Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          if (!Tools.isWeb) ...[
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Compartir'),
              onPressed: _share,
            ),
            const SizedBox(height: 20),
          ],
          Text(
            'Siguiente palabra en: $_nextAt',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wordle (es)'),
        actions: [
          IconButton(
            onPressed: _showCalendar,
            icon: const Icon(Icons.calendar_month),
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
            Expanded(
              child: AspectRatio(
                aspectRatio: _logic.width / _logic.height,
                child: _Board(_logic, _onTapBlock),
              ),
            ),
            const SizedBox(height: 10),
            if (!_logic.isEnd) Keyboard(_onTap, _setColor),
            if (_logic.isEnd) endWidget,
          ],
        ),
      ),
      bottomNavigationBar: const DownloadAndroidBar(),
    );
  }
}

class _Board extends StatelessWidget {
  final WordleLogic _logic;
  final void Function(Block) onTapBlock;

  const _Board(this._logic, this.onTapBlock, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: _logic.width,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      childAspectRatio: 1,
      physics: const NeverScrollableScrollPhysics(),
      children: _logic.blocks.map<Widget>((cell) {
        return InkWell(
          onTap: !_logic.isEnd
              ? () {
                  onTapBlock(cell);
                }
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: _Block(logic: _logic, cell: cell),
        );
      }).toList(),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({
    Key? key,
    required WordleLogic logic,
    required Block cell,
  })  : _logic = logic,
        _cell = cell,
        super(key: key);

  final List<Color> _colors = const [
    Colors.transparent,
    Colors.blueGrey,
    Colors.green,
    Colors.orange
  ];
  final WordleLogic _logic;
  final Block _cell;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _colors[_cell.color],
        //color: _logic.blocks.indexOf(cell) % 2 == 0 ? Colors.blueGrey.shade100 : Colors.blueGrey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: _logic.selected == _cell && !_logic.isEnd ? Colors.lightBlue : Colors.blueGrey,
          width: 3,
        ),
      ),
      child: _cell.letter != ''
          ? FittedText(
              _cell.letter,
              color: _cell.color != 0 ? Colors.white : Theme.of(context).textTheme.headline5!.color,
              fontWeight: FontWeight.bold,
            )
          : null,
    );
  }
}
