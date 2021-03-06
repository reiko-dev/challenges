import 'package:flutter/material.dart';
import 'package:fourier_series/view/pages/main/complex_dft_painter.dart';

import 'package:get/get.dart';

import 'package:fourier_series/domain/controllers/drawing_controller.dart';

class DrawingAnimation extends StatefulWidget {
  const DrawingAnimation();

  @override
  createState() => _ComplexDFTUserDrawerState();
}

class _ComplexDFTUserDrawerState extends State<DrawingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  bool isStarted = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    if (controller.isAnimating) controller.stop();
    controller.dispose();
    super.dispose();
  }

  void startAnimation() {
    if (!isStarted) {
      controller.repeat();
      isStarted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrawingController>(
      builder: (dc) {
        if (dc.animationState == AnimationState.loading)
          return Center(child: CircularProgressIndicator());

        return AnimatedBuilder(
          animation: controller,
          builder: (_, __) {
            return Stack(
              children: [
                CustomPaint(
                  painter: ComplexDFTPainter(
                    drawing: dc,
                    style: AnimationStyle.loop,
                    startAnimation: startAnimation,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
