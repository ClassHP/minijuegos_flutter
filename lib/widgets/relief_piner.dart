import 'package:flutter/material.dart';

class ReliefPainter extends CustomPainter {
  final double _kInternalOpacity = 0.4;
  final double _kInternalStrokeWidth = 10;
  final double _kInternalBlur = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final shadowPaintBlack = Paint()
      ..color = Colors.black.withOpacity(_kInternalOpacity)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, _kInternalBlur)
      ..strokeWidth = _kInternalStrokeWidth;

    final shadowPaintWhite = Paint()
      ..color = Colors.black.withOpacity(_kInternalOpacity * 0.9)
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, _kInternalBlur)
      ..strokeWidth = _kInternalStrokeWidth * 0.5;

    /*Internal Border */
    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, size.height),
      shadowPaintWhite,
    ); //left
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, size.height),
      shadowPaintBlack,
    ); //Right
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      shadowPaintBlack,
    ); //Bottom
    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, 0),
      shadowPaintWhite,
    ); //Top{
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
