import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fourier_series/fourier_painters/dft_algorithm.dart';

class DiscreteFourierTransform extends StatefulWidget {
  @override
  createState() => _DiscreteFourierTransformState();
}

class _DiscreteFourierTransformState extends State<DiscreteFourierTransform>
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
  static var wave = [];

  @override
  void paint(Canvas canvas, Size size) {
    //This is the signal, any arbitrary digital signal/array of numbers
    var signal = [];

    for (int i = 0; i < 100; i++) {
      signal.add(2 * i);
    }

    var fourierY = dft(signal);

    Paint paint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke;

    canvas.translate(150, 200);

    double x = 0;
    double y = 0;

    for (int i = 0; i < fourierY.length; i++) {
      double prevX = x;
      double prevY = y;

      int freq = fourierY[i]['freq'];
      double radius = fourierY[i]['amp'];
      double phase = fourierY[i]['phase'];

      x += radius * cos(freq * time + phase + pi / 2);
      y += radius * sin(freq * time + phase + pi / 2);

      ///Draws the circles
      paint
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(prevX, prevY), radius, paint);

      //Draw a line to the center of the next circle.
      paint..style = PaintingStyle.fill;
      canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);
    }

    //unshift
    wave.insert(0, y);

    //Moves the wave a bit to the left
    canvas.translate(200, 0);
    canvas.drawLine(Offset(x - 200, y), Offset(0, wave.first), paint);

    // begin shape
    Path path = Path()..moveTo(0, wave.first);
    paint.style = PaintingStyle.stroke;

    for (int i = 0; i < wave.length; i++) {
      path.lineTo(i.toDouble(), wave[i]);
    }
    // canvas.translate(150, )
    canvas.drawPath(path, paint);

    final dt = 2 * pi / fourierY.length;
    time += dt;
    animationController.animateTo(time);

    if (wave.length > 250) wave.removeLast();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
