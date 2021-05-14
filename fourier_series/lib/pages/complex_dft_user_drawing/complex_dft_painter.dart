import 'dart:math';

import 'package:flutter/material.dart';

enum AnimationStyle { once, loop, loopOver }

class ComplexDFTPainter extends CustomPainter {
  final AnimationController animationController;
  ComplexDFTPainter(
    this.animationController,
    this.data,
    this.style,
    this.strokeWidth,
  );

  final Map<String, dynamic> data;
  final AnimationStyle style;
  final double strokeWidth;

  double firstEllipseRadius = 0;

  final colors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.red,
    Colors.white,
    Colors.orange,
  ];

  static double time = 0;
  static List<Offset> path = [];
  static int currentDrawingIndex = 0;

  static List<List<Offset>> oldPaths = [];

  static void clean() {
    time = 0;
    path = [];
    currentDrawingIndex = 0;
    oldPaths = [];
  }

  @override
  void paint(Canvas canvas, Size size) {
    //Stores the path of the current drawing and moves to the next
    if (path.length == data['drawing'][currentDrawingIndex].length) {
      //Só adiciona esse path se ele ainda não tiver sido adicionado anteriormente.
      if (oldPaths.length <= currentDrawingIndex) {
        oldPaths.add([...path]);
      }
      path.clear();

      if (currentDrawingIndex + 1 < data['drawing'].length)
        currentDrawingIndex++;
      else
        currentDrawingIndex = 0;
    }

    drawOldPaths(canvas);

    draw(data['fourier'] as List<Map<String, dynamic>>, canvas);
  }

  void drawOldPaths(Canvas canvas) {
    if (oldPaths.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final List<Path> paths = [];

    for (int i = 0; i < oldPaths.length; i++) {
      paths.add(Path());

      paths[i].moveTo(oldPaths[i].first.dx, oldPaths[i].first.dy);

      oldPaths[i].forEach((Offset point) {
        paths[i].lineTo(point.dx, point.dy);
      });
    }

    for (int i = 0; i < paths.length; i++) {
      paint.color = colors[i % colors.length];
      canvas.drawPath(paths[i], paint);
    }
  }

  List<double> epicycles(List<Map<String, dynamic>> fourier, Canvas canvas) {
    //TODO: define as the center of the window
    double x = 400, y = 300;

    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < fourier.length; i++) {
      double prevX = x;
      double prevY = y;

      int freq = fourier[i]['freq'];
      double radius = fourier[i]['amp'];
      double phase = fourier[i]['phase'];

      x += radius * cos(freq * time + phase);
      y += radius * sin(freq * time + phase);

      ///Draws the circles
      paint..strokeWidth = 2;
      canvas.drawCircle(Offset(prevX, prevY), radius, paint);

      //Draw a line to the center of the next circle.
      canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
    }

    return [x, y];
  }

  draw(List<Map<String, dynamic>> fourier, canvas) {
    var v = epicycles(fourier, canvas);

    //
    //Verifica se este é o loop de retorno ao ponto de origem.
    //Se for, não deve desenhar uma linha ao ponto de origem.
    if (path.length == 0 || path.length % fourier.length != 0)
      path.insert(0, Offset(v[0], v[1]));

    // begin shape
    Path pathToDraw = Path()..moveTo(path.first.dx, path.first.dy);

    Paint paint = Paint()
      ..color = const Color(0xFFFBC02D)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < path.length; i++) {
      pathToDraw.lineTo(path[i].dx.toDouble(), path[i].dy);
    }

    canvas.drawPath(pathToDraw, paint);

    //old
    //final dt = 2 * pi / fourier.length;
    //
    //add the total from all fourier to be animated, should be something like:
    //final dt = 2 * pi / listOfFourier.length;
    final dt = 2 * pi / fourier.length;

    time += dt;

    animationController.animateTo(time);
  }

  @override
  bool shouldRepaint(covariant ComplexDFTPainter old) {
    if (oldPaths.length == data['drawing'].length) {
      switch (style) {
        case AnimationStyle.once:
          return false;

        case AnimationStyle.loop:
          clean();
          return true;

        default:
          return true;
      }
    }

    return true;
  }
}
