import 'dart:ui';

import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final bool _visible;

  const Loading({Key? key, required visible }) : _visible = visible, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.5))),
              ),
            ),
          ),
          const CircularProgressIndicator()
        ],
      ),
    );
  }
}
