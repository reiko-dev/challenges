import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/fourier_painters/dft_real_part_algorithm.dart';

class DFTWithTwoEpyciclesWithCompute extends StatefulWidget {
  const DFTWithTwoEpyciclesWithCompute(this.drawing);
  final List<Map<String, double>> drawing;

  @override
  createState() => _DFTWithTwoEpyciclesWithComputeState();
}

class _DFTWithTwoEpyciclesWithComputeState
    extends State<DFTWithTwoEpyciclesWithCompute>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  bool isLoaded = false;
  Map<String, dynamic> dataToCompute = {};

  @override
  void initState() {
    super.initState();
    dataToCompute = {
      'drawing': widget.drawing,
      'skip': 5,
    };
    controller = AnimationController(
      duration: Duration(milliseconds: 3500),
      vsync: this,
    );
    loadData();
    print('initState end');
  }

  Future<void> loadData() async {
    print('started computing');
    dataToCompute = await compute(computeDrawingData, dataToCompute);
    isLoaded = true;

    setState(() {});
    print('finished');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isLoaded)
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: SizedBox(
                width: 100,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        if (isLoaded)
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => CustomPaint(
              painter: DFTPainter(
                controller,
                dataToCompute['fourierX'],
                dataToCompute['fourierY'],
              ),
            ),
          ),
      ],
    );
  }
}

class DFTPainter extends CustomPainter {
  final AnimationController animationController;
  const DFTPainter(this.animationController, this.fourierX, this.fourierY);
  final fourierX, fourierY;

  static double time = 0;
  static final rand = Random();
  static var path = [];

  @override
  void paint(Canvas canvas, Size size) {
    draw(fourierX, fourierY, canvas);
  }

  Offset epiCycles(Offset position, double rotation, fourier, Canvas canvas) {
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
    Paint paint = Paint()
      ..color = Colors.white.withAlpha(100)
      ..style = PaintingStyle.stroke;

    var vx = epiCycles(Offset(550, 75), 0, fourierX, canvas);
    var vy = epiCycles(Offset(100, 400), pi / 2, fourierY, canvas);
    var v = [vx.dx, vy.dy];

    //unshift
    path.insert(0, v);

    //Draw a line from the center of the most external ellipse (on the X axis)to the actual drawing point.
    canvas.drawLine(Offset(vx.dx, vx.dy), Offset(v[0], v[1]), paint);

    //Draw a line from the center of the most external ellipse (on the Y axis)to the actual drawing point.
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
