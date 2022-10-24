import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'colorbox_play.dart';

class ColorboxMenu extends StatefulWidget {
  const ColorboxMenu({super.key});

  @override
  State<ColorboxMenu> createState() => _ColorboxMenuState();
}

class _ColorboxMenuState extends State<ColorboxMenu> {
  Timer? _timer;
  final List<ColorBox> _colorBoxs = [];
  final int _maxColumn = 4;
  final int _maxRow = 6;
  final int _speed = 300;

  void _addColorBox() {
    setState(() {
      _colorBoxs.add(ColorBox());
    });
  }

  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: _speed), (timer) {
      if (_colorBoxs.length < _maxRow * _maxColumn) {
        _addColorBox();
      } else {
        //_colorBoxs.removeAt(Random().nextInt(_colorBoxs.length));
        _colorBoxs.clear();
      }
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _play() {
    GoRouter.of(context).go('/colorbox/play');
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ColorBox")),
      body: Stack(
        children: [
          Container(
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
                    child: Ink(
                      decoration: BoxDecoration(
                        color: colorBox.color,
                        borderRadius: BorderRadius.all(
                          Radius.circular(colorBox.selected ? 24 : 8),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background.withOpacity(0.5))),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton.extended(
                  heroTag: UniqueKey(),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Comenzar'),
                  onPressed: () => _play(),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 20),
                FloatingActionButton.extended(
                  heroTag: UniqueKey(),
                  icon: const Icon(Icons.timeline),
                  label: const Text('Puntuaciones'),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  onPressed: () => GoRouter.of(context).go('/colorbox/score'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
