import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            width: 904,
            height: 604,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CustomDrawer(),
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  @override
  createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  double numberOfCircles = 5;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 3500),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    );
    controller.forward();
    controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) controller.repeat();
      },
    );
  }

  onChanged(double value) {
    numberOfCircles = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: controller,
          builder: (_, __) => CustomPaint(
            painter: Circle(
              controllerValue: controller.value,
              numberOfCircles: numberOfCircles.floor(),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          width: 500,
          child: Slider(
            value: numberOfCircles.toDouble(),
            onChanged: onChanged,
            divisions: 9,
            min: 1,
            max: 10,
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

class Circle extends CustomPainter {
  final double controllerValue;
  final int numberOfCircles;
  static var wave = [];

  const Circle({required this.controllerValue, required this.numberOfCircles});

  @override
  void paint(Canvas canvas, Size size) {
    double time = controllerValue * 2 * pi;

    Paint paint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke;

    canvas.translate(200, 200);

    double x = 0;
    double y = 0;

    for (int i = 0; i < numberOfCircles; i++) {
      double prevX = x;
      double prevY = y;

      int n = i * 2 + 1;

      double radius = 100 * (4 / (n * pi));

      x += radius * cos(n * time);
      y += radius * sin(n * time);

      ///Draws the circles
      paint
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(Offset(prevX, prevY), radius, paint);

      //Draw a line to the center of the next circle.
      paint..style = PaintingStyle.fill;
      canvas.drawLine(Offset(prevX, prevY), Offset(x, y), paint);

      //Draw the circle on the end of the previous line
      // canvas.drawCircle(Offset(x, y), 4, paint);

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

    if (wave.length > 350) wave.removeLast();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  //
  //draws the waves from 150px on width to the right on.
  //Draws a line from the little circle to the last point on the wave.
  void paintBackup2(Canvas canvas, Size size) {
    final double radius = 100;

    double time = controllerValue * 2 * pi;

    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    canvas.translate(200, 200);

    canvas.drawCircle(Offset.zero, radius, paint);

    var x = radius * cos(time);
    var y = radius * sin(time);

    wave.insert(0, y);

    //Draw the circle
    paint..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 8, paint);

    //Draw the line to the little circle
    paint.strokeWidth = 2;
    canvas.drawLine(Offset.zero, Offset(x, y), paint);

    canvas.drawLine(Offset(x, y), Offset(150, wave.first), paint);

    //Moves the wave a bit to the left
    canvas.translate(150, 0);

    Path path = Path()..moveTo(0, wave.first);

    paint.style = PaintingStyle.stroke;

    for (int i = 0; i < wave.length; i++) {
      path.lineTo(i.toDouble(), wave[i]);
    }
    // canvas.translate(150, )
    canvas.drawPath(path, paint);

    if (wave.length > 350) wave.removeLast();
  }

  //Draws a circle, moves the little circle on it and draws a line from center to the little circle.
  void paintBackUp(Canvas canvas, Size size) {
    final double radius = 100;

    double time = controllerValue * 2 * pi;

    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;

    canvas.translate(200, 200);

    canvas.drawCircle(Offset.zero, radius, paint);

    var x = radius * cos(time);
    var y = radius * sin(time);
    paint..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 8, paint);

    paint.strokeWidth = 3;
    canvas.drawLine(Offset.zero, Offset(x, y), paint);
  }
}
