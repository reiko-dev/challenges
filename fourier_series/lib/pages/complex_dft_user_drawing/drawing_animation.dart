import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/pages/complex_dft_user_drawing/algorithm.dart';
import 'package:fourier_series/pages/complex_dft_user_drawing/complex_dft_painter.dart';

class DrawingAnimation extends StatefulWidget {
  DrawingAnimation(this.drawingList, this.strokeWidth);
  final List<List<Offset>> drawingList;
  final double strokeWidth;

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
    final List<Offset> points = [];

    dataToCompute['drawing'].forEach((element) {
      points.addAll(element);
    });

    final result = await compute(computeUserDrawingData, points);

    dataToCompute['fourier'] = result;

    if (mounted)
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
                dataToCompute,
                AnimationStyle.loopOver,
                widget.strokeWidth,
              ),
            ),
          )
        : Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(),
            ),
          );
  }
}
