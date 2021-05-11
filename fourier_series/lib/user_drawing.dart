import 'package:flutter/material.dart';

class UserDrawing extends CustomPainter {
  List<Offset> points = [];

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant UserDrawing oldDelegate) {
    if (points != oldDelegate.points)
      return true;
    else
      return false;
  }
}
