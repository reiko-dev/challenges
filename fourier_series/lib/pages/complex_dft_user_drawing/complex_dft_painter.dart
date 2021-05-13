import 'dart:math';

import 'package:flutter/material.dart';

enum AnimationStyle { once, loop, loopOver }

class ComplexDFTPainter extends CustomPainter {
  final AnimationController animationController;
  ComplexDFTPainter(
    this.animationController,
    this.data,
    this.style,
  );

  final Map<String, dynamic> data;

  double firstEllipseRadius = 0;

  final colors = [
    Colors.blue,
    Colors.pink,
    Colors.yellow,
    Colors.green,
    Colors.purple,
    Colors.red
  ];
  final AnimationStyle style;
  static double time = 0;
  static List<Offset> path = [];
  static int currentDrawingIndex = 0;

  static List<List<Offset>> oldPaths = [];
  static int currentColorIndex = 0;

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
      changeColor();
    }

    drawOldPaths(canvas);

    draw(data['fourier'] as List<Map<String, dynamic>>, canvas);
  }

  void changeColor() {
    if (currentColorIndex == colors.length - 1)
      currentColorIndex = 0;
    else
      currentColorIndex++;
  }

  void drawOldPaths(Canvas canvas) {
    if (oldPaths.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0x77FFFFFF)
      ..strokeWidth = 2;

    final path = Path();

    oldPaths.forEach((list) {
      path.moveTo(list.first.dx, list.first.dy);

      list.forEach((Offset point) {
        path.lineTo(point.dx, point.dy);
      });
    });

    canvas.drawPath(path, paint);
  }

  List<double> epicycles(List<Map<String, dynamic>> fourier, Canvas canvas) {
    //TODO: define as the center of the window
    double x = 400, y = 300;

    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
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
      paint
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(prevX, prevY), radius, paint);

      //Draw a line to the center of the next circle.
      paint..style = PaintingStyle.fill;
      canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
    }

    return [x, y];
  }

  draw(List<Map<String, dynamic>> fourier, canvas) {
    Paint paint = Paint()
      ..color = colors[currentColorIndex]
      ..style = PaintingStyle.stroke;

    var v = epicycles(fourier, canvas);

    //
    //Verifica se este é o loop de retorno ao ponto de origem.
    //Se for, não deve desenhar uma linha ao ponto de origem.
    if (path.length == 0 || path.length % fourier.length != 0)
      path.insert(0, Offset(v[0], v[1]));

    // begin shape
    Path pathToDraw = Path()..moveTo(path.first.dx, path.first.dy);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

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
    return true;
    // if (ComplexDFTPainter.path.length <
    //     listOfFourier[currentDrawingIndex].length)
    //   return true;
    // else {
    //   switch (style) {
    //     case AnimationStyle.once:
    //       return false;

    //     case AnimationStyle.loop:
    //       clean();
    //       return true;

    //     default:
    //       //Cleans the path for saving memory.
    //       if (path.length > 2 * listOfFourier[currentDrawingIndex].length) {
    //         path.removeRange(
    //             listOfFourier[currentDrawingIndex].length * 2, path.length - 1);
    //       }

    //       return true;
    //   }
    // }
  }
}
