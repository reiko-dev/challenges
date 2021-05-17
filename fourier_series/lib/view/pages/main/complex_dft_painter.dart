import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:fourier_series/domain/entities/fourier.dart';

enum AnimationStyle { once, loop, loopOver }

class ComplexDFTPainter extends CustomPainter {
  final AnimationController animationController;
  ComplexDFTPainter({
    required this.animationController,
    required this.drawing,
    required this.style,
    required this.xEpicyclePosition,
    required this.yEpicyclePosition,
  });

  // final Map<String, dynamic> drawing;
  final DrawingController drawing;
  final AnimationStyle style;
  double yEpicyclePosition, xEpicyclePosition;

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
    if (path.length == drawing.shapes[currentDrawingIndex].points.length) {
      //Só adiciona esse path se ele ainda não tiver sido adicionado anteriormente.
      if (oldPaths.length <= currentDrawingIndex) {
        oldPaths.add([...path]);
      }
      path.clear();

      if (currentDrawingIndex + 1 < drawing.shapes.length)
        currentDrawingIndex++;
      else
        currentDrawingIndex = 0;
    }

    drawOldPaths(canvas);

    draw(drawing.fourierList, canvas);
  }

  void drawOldPaths(Canvas canvas) {
    if (oldPaths.isEmpty) return;

    final paint = Paint()..style = PaintingStyle.stroke;

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
      paint.strokeWidth = drawing.shapes[i].strokeWidth;
      canvas.drawPath(paths[i], paint);
    }
  }

  List<double> epicycles(List<Fourier> fourier, Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < fourier.length; i++) {
      double prevX = xEpicyclePosition;
      double prevY = yEpicyclePosition;

      int freq = fourier[i].freq;
      double radius = fourier[i].amp;
      double phase = fourier[i].phase;

      xEpicyclePosition += radius * cos(freq * time + phase);
      yEpicyclePosition += radius * sin(freq * time + phase);

      ///Draws the circles
      paint..strokeWidth = 2;
      canvas.drawCircle(Offset(prevX, prevY), radius, paint);

      //Draw a line to the center of the next circle.
      canvas.drawLine(Offset(prevX, prevY),
          Offset(xEpicyclePosition, yEpicyclePosition), paint);
    }

    return [xEpicyclePosition, yEpicyclePosition];
  }

  draw(List<Fourier> fourier, canvas) {
    var v = epicycles(fourier, canvas);

    //
    //Verifica se este é o loop de retorno ao ponto de origem.
    //Se for, não deve desenhar uma linha ao ponto de origem.
    //
    if (path.length == 0 || path.length != fourier.length)
      path.insert(0, Offset(v[0], v[1]));

    // begin shape
    Path pathToDraw = Path()..moveTo(path.first.dx, path.first.dy);

    Paint paint = Paint()
      ..color = const Color(0xFFFBC02D)
      ..strokeWidth = drawing.strokeWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < path.length; i++) {
      pathToDraw.lineTo(path[i].dx.toDouble(), path[i].dy);
    }

    canvas.drawPath(pathToDraw, paint);

    final dt = 2 * pi / fourier.length;

    time += dt;

    animationController.animateTo(time);
  }

  @override
  bool shouldRepaint(covariant ComplexDFTPainter old) {
    if (oldPaths.length == drawing.shapes.length) {
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
