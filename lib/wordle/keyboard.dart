import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:minijuegos_flutter/widgets/fitted_text.dart';

class Keyboard extends StatefulWidget {
  final List<_Key> _keys = [];
  final void Function(String) onTap;
  final Color Function(String) setColor;

  Keyboard(this.onTap, this.setColor, {Key? key}) : super(key: key) {
    var keys = 'QWERTYUIOPASDFGHJKLÑ-ZXCVBNM*';
    for (var i = 0; i < keys.length; i++) {
      _keys.add(_Key(keys[i]));
    }
  }

  @override
  createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxHeight: 180,
      child: AspectRatio(
        aspectRatio: 10 / 4,
        child: StaggeredGrid.count(
          axisDirection: AxisDirection.down,
          crossAxisCount: 40,
          mainAxisSpacing: 5,
          crossAxisSpacing: 2,
          /*childAspectRatio: 8 / 10,
          physics: const NeverScrollableScrollPhysics(),*/
          children: widget._keys.map<StaggeredGridTile>((cell) {
            return StaggeredGridTile.count(
              crossAxisCellCount: cell.key == '*' || cell.key == '-' ? 6 : 4,
              mainAxisCellCount: 5,
              child: InkWell(
                onTap: () {
                  widget.onTap(cell.key);
                },
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Ink(
                  //alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: widget.setColor(cell.key),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    /*border: Border.all(
                      color: Colors.blueGrey,
                      width: 3,
                    ),*/
                  ),
                  child: cell.key == '*'
                      ? const Icon(Icons.send)
                      : cell.key == '-'
                          ? const Icon(Icons.arrow_back)
                          : FittedText(
                              cell.key,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Key {
  String key = '';
  Color color = Colors.grey;

  _Key(this.key);
}
