import 'dart:ui';

import 'package:flutter/material.dart';

class UserDrawing extends CustomPainter {
  UserDrawing(
    this.points,
    this.xEpicylePosition,
    this.yEpicylePosition,
  );

  List<List<Offset>> points = [];
  final int xEpicylePosition, yEpicylePosition;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white;

    points.forEach((points) {
      final path = Path()
        ..moveTo(
          points[0].dx + xEpicylePosition,
          points[0].dy + yEpicylePosition,
        );
      points.forEach((element) {
        path.lineTo(
            element.dx + xEpicylePosition, element.dy + yEpicylePosition);
      });
      canvas.drawPath(path, paint);
    });
  }

  @override
  bool shouldRepaint(covariant UserDrawing oldDelegate) {
    if (points != oldDelegate.points)
      return true;
    else
      return false;
  }
}
