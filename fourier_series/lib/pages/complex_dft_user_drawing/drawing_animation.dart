import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/pages/complex_dft_user_drawing/algorithm.dart';
import 'package:fourier_series/pages/complex_dft_user_drawing/complex_dft_painter.dart';

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

    int totalOfPoints = 0;

    await Future.wait(futuresList).then(
      (value) {
        value.forEach((element) {
          dataToCompute['fourier'].add(element['fourier']);
          totalOfPoints += element['fourier'].length as int;
        });
      },
    );

    dataToCompute['totalOfPoints'] = totalOfPoints;

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
                dataToCompute['fourier'],
                dataToCompute['totalOfPoints'],
                AnimationStyle.loop,
              ),
            ),
          )
        : CircularProgressIndicator();
  }
}
