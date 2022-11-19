import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {
  const InfoBox({
    Key? key,
    required String text,
    Color? color,
    IconData? icon1,
    IconData? icon2,
  })  : _text = text,
        _icon1 = icon1,
        _icon2 = icon2,
        _color = color,
        super(key: key);

  final String _text;
  final IconData? _icon1;
  final IconData? _icon2;
  final Color? _color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _color ?? Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        children: [
          if (_icon1 != null) ...[
            Icon(_icon1, color: Colors.white),
          ],
          const SizedBox(width: 5),
          Text(
            _text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          const SizedBox(width: 5),
          if (_icon2 != null) ...[
            Icon(_icon2, color: Colors.white),
          ],
        ],
      ),
    );
  }
}