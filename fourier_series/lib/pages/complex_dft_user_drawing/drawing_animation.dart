import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/pages/complex_dft_user_drawing/algorithm.dart';

class DrawingAnimation extends StatefulWidget {
  DrawingAnimation(this.drawingList, this.skip) : assert(skip > 0);
  final List<List<Offset>> drawingList;
  final int skip;

  @override
  createState() => _ComplexDFTUserDrawerState();
}

class _ComplexDFTUserDrawerState extends State<DrawingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  bool isLoaded = false;
  Map<String, dynamic> dataToCompute = {};

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 3500),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    );

    dataToCompute = {
      'drawing': widget.drawingList,
      'skip': widget.skip,
    };
    loadData();
    print('initState end');
  }

  @override
  void dispose() {
    if (controller.isAnimating) controller.stop();
    controller.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    List<Future> futuresList = [];
    dataToCompute['drawing'].forEach((List<Offset> points) {
      futuresList.add(
        compute(
          computeUserDrawingData,
          {'skip': dataToCompute['skip'], 'drawing': points},
        ),
      );
    });

    dataToCompute['fourier'] = [];

    await Future.wait(futuresList).then(
      (value) {
        value.forEach((element) {
          dataToCompute['fourier'].add(element['fourier']);
        });
      },
    );
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded
        ? AnimatedBuilder(
            animation: controller,
            builder: (_, __) => CustomPaint(
              painter: ComplexDFTPainter(
                controller,
                dataToCompute['fourier'][0] as List<Map<String, dynamic>>,
                AnimationStyle.loopOver,
              ),
            ),
          )
        : CircularProgressIndicator();
  }
}

enum AnimationStyle { once, loop, loopOver }

class ComplexDFTPainter extends CustomPainter {
  final AnimationController animationController;
  ComplexDFTPainter(this.animationController, this.fourier, this.style);

  final List<Map<String, dynamic>> fourier;

  final rand = Random();
  final colors = [Colors.blue, Colors.pink, Colors.yellow];
  final AnimationStyle style;
  static double time = 0;
  static int currentColorIndex = 0;
  static var path = [];

  static void clean() {
    currentColorIndex = 0;
    time = 0;
    path = [];
  }

  @override
  void paint(Canvas canvas, Size size) {
    draw(fourier, canvas);
  }

  List<double> epicycles(fourier, Canvas canvas) {
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

  draw(fourier, canvas) {
    Paint paint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke;

    var v = epicycles(fourier, canvas);

    path.insert(0, v);
    // path.add(v);

    // begin shape
    Path pathToDraw = Path()..moveTo(path.first[0], path.first[1]);
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.3);

    for (int i = 0; i < path.length; i++) {
      pathToDraw.lineTo(path[i][0].toDouble(), path[i][1]);
    }
    // canvas.translate(150, )
    canvas.drawPath(pathToDraw, paint);

    final dt = 2 * pi / fourier.length;
    time += dt;
    animationController.animateTo(time);
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
  bool shouldRepaint(covariant ComplexDFTPainter old) {
    if (ComplexDFTPainter.path.length < fourier.length)
      return true;
    else {
      switch (style) {
        case AnimationStyle.once:
          return false;

        case AnimationStyle.loop:
          clean();
          return true;

        default:
          if (path.length > 2 * fourier.length)
            path.removeRange(fourier.length * 2, path.length - 1);

          return true;
      }
    }
  }
}
