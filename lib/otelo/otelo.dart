import 'package:flutter/material.dart';
import 'package:minijuegos_flutter/loading.dart';
import 'package:minijuegos_flutter/otelo/otelo_logic.dart';

class Otelo extends StatefulWidget {
  const Otelo({Key? key}) : super(key: key);

  @override
  createState() => _OteloState();
}

class _OteloState extends State<Otelo> {
  final List<Color> _playerColors = [Colors.black, Colors.white];
  final OteloLogic _logic = OteloLogic();

  _OteloState() {
    _logic.updateLayout.listen((_) {
      setState(() {});
    });
  }

  void _play(PlayerType type) {
    _logic.init(type, 0).then((_) {
      setState(() {});
    });
    setState(() {});
  }

  void _stop() {
    setState(() {
      _logic.stop();
    });
  }

  void _setChip(Box box) {
    _logic.setChip(box).then((_) {
      setState(() {});
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var playButtons = Visibility(
      visible: _logic.end,
      child: Wrap(
        //mainAxisAlignment: MainAxisAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 10,
        children: <Widget>[
          _ButtonPlay(
            icon1: Icons.person,
            icon2: Icons.important_devices,
            onPressed: () => _play(PlayerType.ia),
          ),
          _ButtonPlay(
            icon1: Icons.person,
            icon2: Icons.person,
            onPressed: () => _play(PlayerType.person),
          ),
          _ButtonPlay(
            icon1: Icons.person,
            icon2: Icons.public_sharp,
            onPressed: () => _play(PlayerType.online),
          ),
        ],
      ),
    );
    var endButton = Visibility(
      visible: !_logic.end,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FloatingActionButton.extended(
            heroTag: UniqueKey(),
            onPressed: () => _stop(),
            backgroundColor: Theme.of(context).colorScheme.error,
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text('Finalizar'),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Otelo"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Score(logic: _logic, playerColors: _playerColors),
            Expanded(
              child: _Board(
                  logic: _logic,
                  playerColors: _playerColors,
                  setChip: _setChip),
            ),
            const SizedBox(height: 20),
            playButtons,
            endButton,
          ],
        ),
      ),
    );
  }
}

class _Board extends StatelessWidget {
  final OteloLogic _logic;
  final List<Color> _playerColors;
  final void Function(Box) setChip;

  const _Board(
      {Key? key,
      required OteloLogic logic,
      required List<Color> playerColors,
      required this.setChip})
      : _logic = logic,
        _playerColors = playerColors,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          GridView.count(
            crossAxisCount: 8,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 1,
            children: _logic.boxes.map<Widget>((box) {
              var visible = box.player != null &&
                      _logic.players[box.player ?? 0].type ==
                          PlayerType.person ||
                  box.selected;
              return InkWell(
                onTap: () {
                  if (box.player != null &&
                      _logic.players[box.player ?? 0].type ==
                          PlayerType.person) {
                    setChip(box);
                  }
                },
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Ink(
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  AnimatedFractionallySizedBox(
                    alignment: Alignment.center,
                    duration: visible
                        ? const Duration(seconds: 1)
                        : const Duration(milliseconds: 100),
                    widthFactor: box.selected ? 0.9 : 0.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: box.selected
                            ? _playerColors[box.player ?? 0]
                            : _playerColors[box.player ?? 0]
                                .withOpacity(visible ? 0.5 : 0),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ]),
              );
            }).toList(),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Loading(visible: _logic.loading),
          ),
        ],
      ),
    );
  }
}

class _Score extends StatelessWidget {
  final OteloLogic _logic;
  final List<Color> _playerColors;

  const _Score({
    Key? key,
    required OteloLogic logic,
    required List<Color> playerColors,
  })  : _logic = logic,
        _playerColors = playerColors,
        super(key: key);

  Icon _getIconPlayer(Player player) {
    var color =
        player == _logic.players[0] ? _playerColors[1] : _playerColors[0];
    if (player.type == PlayerType.ia) {
      return Icon(Icons.important_devices, color: color);
    }
    if (player.type == PlayerType.online) {
      return Icon(Icons.public_sharp, color: color);
    }
    return Icon(Icons.person, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Row(
        children: _logic.players.map<Widget>((player) {
          return Expanded(
            child: Container(
              color: _playerColors[player.player],
              alignment: Alignment.center,
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _getIconPlayer(player),
                  const SizedBox(width: 20),
                  Text(
                    "${player.score}",
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: player.player == 0
                            ? _playerColors[1]
                            : _playerColors[0]),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ButtonPlay extends StatelessWidget {
  final IconData icon1;
  final IconData icon2;
  final void Function()? onPressed;

  const _ButtonPlay({
    Key? key,
    required this.icon1,
    required this.icon2,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: UniqueKey(),
      onPressed: onPressed,
      backgroundColor: onPressed != null
          ? Theme.of(context).colorScheme.primary
          : Colors.grey,
      label: Row(
        children: [
          Icon(icon1),
          const SizedBox(width: 5),
          const Text('VS'),
          const SizedBox(width: 5),
          Icon(icon2)
        ],
      ),
    );
  }
}
