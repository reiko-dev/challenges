import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/fourier_painters/dft_real_part_algorithm.dart';
import 'package:fourier_series/fourier_painters/drawing.dart';

class DFTWithTwoEpyciclesWithCompute extends StatefulWidget {
  @override
  createState() => _DFTWithTwoEpyciclesWithComputeState();
}

class _DFTWithTwoEpyciclesWithComputeState
    extends State<DFTWithTwoEpyciclesWithCompute>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  bool isLoaded = false;
  final Map<String, dynamic> dataToCompute = {
    'drawing': drawing,
  };

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (WidgetsBinding.instance != null) {
      Future.delayed(Duration.zero).then((value) {
        compute(computingDrawingData, dataToCompute).then((value) {
          setState(() {
            isLoaded = true;
          });
          print('BB');
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isLoaded)
          Container(
            color: Colors.yellow,
            child: SizedBox(
              width: 100,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          ),
        if (isLoaded)
          AnimatedBuilder(
            animation: controller,
            builder: (_, __) => CustomPaint(
              painter: DFTPainter(controller, dataToCompute['fourierX'],
                  dataToCompute['fourierY']),
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

    //unshift
    path.insert(0, v);

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
    if (time > (2 * pi) * 2) {
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
