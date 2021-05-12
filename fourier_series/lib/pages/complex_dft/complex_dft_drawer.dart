import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourier_series/fourier_painters/drawing.dart';
import 'package:fourier_series/pages/complex_dft/complex_dft_algorithm.dart';

class DFTWithComplexNumberDrawer extends StatefulWidget {
  @override
  createState() => _DFTWithComplexNumberDrawerState();
}

class _DFTWithComplexNumberDrawerState extends State<DFTWithComplexNumberDrawer>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 3500),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => CustomPaint(
        painter: DFTWithComplexNumberPainter(controller),
      ),
    );
  }
}

class DFTWithComplexNumberPainter extends CustomPainter {
  final AnimationController animationController;
  DFTWithComplexNumberPainter(this.animationController);

  final rand = Random();
  final colors = [Colors.blue, Colors.pink, Colors.yellow];
  static double time = 0;
  static int currentColorIndex = 0;
  static var path = [];

  @override
  void paint(Canvas canvas, Size size) {
    //This is the signal, any arbitrary digital signal/array of numbers
    List<dynamic> fourier = [];

    int skip = 7;

    for (int i = 0; i < drawing.length; i += skip) {
      final c = Complex(drawing[i].dx, drawing[i].dy);

      fourier.add(c);
    }

    var fourierX = complexNumberDFTAlgorithm(fourier);

    fourierX.sort((a, b) => b['amp'].compareTo(a['amp']));

    draw(fourierX, canvas);
  }

  List<double> epicycles(
      double x, double y, double rotation, fourier, Canvas canvas) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
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
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(prevX, prevY), radius, paint);

      //Draw a line to the center of the next circle.
      paint..style = PaintingStyle.fill;
      canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
    }

    return [x, y];
  }

  draw(fourier, canvas) {
    Paint paint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke;

    // width: 804,
    //height: 604,
    var v = epicycles(400, 300, 0, fourier, canvas);

    //unshift
    path.insert(0, v);

    // begin shape
    Path pathToDraw = Path()..moveTo(path.first[0], path.first[1]);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = randomColor();

    for (int i = 0; i < path.length; i++) {
      pathToDraw.lineTo(path[i][0].toDouble(), path[i][1]);
    }
    // canvas.translate(150, )
    canvas.drawPath(pathToDraw, paint);

    final dt = 2 * pi / fourier.length;
    time += dt;
    if (time > 2 * pi) {
      time = 0;
      path = [];
      animationController.stop();
    } else {
      animationController.animateTo(time);
    }
  }

  Color randomColor() {
    int newColor = rand.nextInt(3);
    while (newColor == currentColorIndex) {
      newColor = rand.nextInt(3);
    }
    currentColorIndex = newColor;

    return colors[currentColorIndex];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
