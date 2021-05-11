import 'dart:math';

import 'package:flutter/material.dart';

class DFTPainter extends CustomPainter {
  final AnimationController animationController;
  const DFTPainter(this.animationController, this.fourierX, this.fourierY);
  final List<Map<String, dynamic>> fourierX, fourierY;

  static double time = 0;
  static final rand = Random();
  static var path = [];

  @override
  void paint(Canvas canvas, Size size) {
    draw(fourierX, fourierY, canvas);
  }

  Offset epicycles(Offset position, double rotation,
      List<Map<String, dynamic>> fourier, Canvas canvas) {
    double x = position.dx;
    double y = position.dy;

    Paint paint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < fourier.length; i++) {
      double prevX = x;
      double prevY = y;

      int freq = fourier[i]['freq'];
      double radius = fourier[i]['amp'];
      double phase = fourier[i]['phase'];

      x += radius * cos(freq * time + phase + rotation);
      y += radius * sin(freq * time + phase + rotation);

      ///Draws the circles
      paint
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..color = const Color(0x20FFFFFF);
      canvas.drawCircle(Offset(prevX, prevY), radius, paint);

      //Draw a line to the center of the next circle.
      paint..style = PaintingStyle.fill;
      canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
    }

    return Offset(x, y);
  }

  draw(fourierX, fourierY, Canvas canvas) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke;

    var vx = epicycles(Offset(550, 75), 0, fourierX, canvas);
    var vy = epicycles(Offset(100, 400), pi / 2, fourierY, canvas);
    var v = [vx.dx, vy.dy];

    //unshift
    path.insert(0, v);

    //Draw a line from the center of the most external ellipse (on the X axis) to the actual drawing point.
    canvas.drawLine(Offset(vx.dx, vx.dy), Offset(v[0], v[1]), paint);

    //Draw a line from the center of the most external ellipse (on the Y axis) to the actual drawing point.
    canvas.drawLine(Offset(vy.dx, vy.dy), Offset(v[0], v[1]), paint);

    // begin shape
    Path pathToDraw = Path()..moveTo(path.first[0], path.first[1]);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < path.length; i++) {
      pathToDraw.lineTo(path[i][0].toDouble(), path[i][1]);
    }

    canvas.drawPath(pathToDraw, paint);

    final dt = 2 * pi / fourierY.length;
    time += dt;

    if (time >= 2 * pi) {
      time = 0;
      path.clear();
      animationController.stop();
    } else {
      animationController.animateTo(time);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (animationController.isAnimating) return true;

    return false;
  }
}
