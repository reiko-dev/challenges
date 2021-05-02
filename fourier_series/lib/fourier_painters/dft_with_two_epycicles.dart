import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourier_series/fourier_painters/dft_real_part_algorithm.dart';
import 'package:fourier_series/fourier_painters/drawing.dart';

class DFTWithTwoEpycicles extends StatefulWidget {
  @override
  createState() => _DFTWithTwoEpyciclesState();
}

class _DFTWithTwoEpyciclesState extends State<DFTWithTwoEpycicles>
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
    return Stack(
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (_, __) => CustomPaint(
            painter: DFTPainter(controller),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            icon: Icon(
              Icons.stop,
              color: Colors.white,
            ),
            onPressed: () {
              if (controller.isAnimating)
                controller.stop();
              else
                controller.forward();
            },
          ),
        )
      ],
    );
  }
}

class DFTPainter extends CustomPainter {
  final AnimationController animationController;
  const DFTPainter(this.animationController);

  static double time = 0;
  static final rand = Random();
  static var path = [];

  @override
  void paint(Canvas canvas, Size size) {
    //This is the signal, any arbitrary digital signal/array of numbers
    var signalX = [];
    var signalY = [];

    int skip = 30;

    for (int i = 0; i < drawing.length; i += skip) {
      signalX.add(drawing[i]['x']);
      signalY.add(drawing[i]['y']);
      // signalX.add(0);
      // signalY.add(0);
    }

    var fourierX = dftRealPartAlgorithm(signalX);
    var fourierY = dftRealPartAlgorithm(signalY);

    // fourierX.sort((a, b) => b['amp'] - a['amp']);
    // fourierY.sort((a, b) => b['amp'] - a['amp']);
    fourierX.sort((a, b) => b['amp'].compareTo(a['amp']));
    fourierY.sort((a, b) => b['amp'].compareTo(a['amp']));

    draw(fourierX, fourierY, canvas);
  }

  List<double> epiCycles(
      double x, double y, double rotation, fourier, Canvas canvas) {
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
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(prevX, prevY), radius, paint);

      //Draw a line to the center of the next circle.
      paint..style = PaintingStyle.fill;
      canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
    }

    return [x, y];
  }

  draw(fourierX, fourierY, canvas) {
    Paint paint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke;

    var vx = epiCycles(450, 75, 0, fourierX, canvas);
    var vy = epiCycles(100, 400, pi / 2, fourierY, canvas);
    var v = [vx[0], vy[1]];

    // double x = 0, y = 0;

    //unshift
    path.insert(0, v);

    //Moves the wave a bit to the left
    // canvas.translate(200, 0);
    // canvas.drawLine(Offset(x - 200, y), Offset(0, path.first), paint);
    canvas.drawLine(Offset(vx[0], vx[1]), Offset(v[0], v[1]), paint);
    canvas.drawLine(Offset(vy[0], vy[1]), Offset(v[0], v[1]), paint);

    // begin shape
    Path pathToDraw = Path()..moveTo(0, path.first[1]);
    paint.style = PaintingStyle.stroke;

    for (int i = 0; i < path.length; i++) {
      pathToDraw.lineTo(path[i][0].toDouble(), path[i][1]);
    }
    // canvas.translate(150, )
    canvas.drawPath(pathToDraw, paint);

    final dt = 2 * pi / fourierY.length;
    time += dt;
    if (time > 2 * pi) {
      time = 0;
      path = [];
      animationController.stop();
    } else {
      animationController.animateTo(time);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
