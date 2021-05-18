import 'package:flutter/material.dart';
import 'package:fourier_series/view/pages/main/complex_dft_painter.dart';

import 'package:get/get.dart';

import 'package:fourier_series/utils/dimensions_percent.dart';

import 'package:fourier_series/domain/controllers/drawing_controller.dart';

class DrawingAnimation extends StatefulWidget {
  const DrawingAnimation();

  @override
  createState() => _ComplexDFTUserDrawerState();
}

class _ComplexDFTUserDrawerState extends State<DrawingAnimation>
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
  void dispose() {
    if (controller.isAnimating) controller.stop();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => GetBuilder<DrawingController>(
        builder: (drawingController) {
          return drawingController.animationState != AnimationState.loading
              ? CustomPaint(
                  painter: ComplexDFTPainter(
                    animationController: controller,
                    drawing: drawingController,
                    style: AnimationStyle.loopOver,
                  ),
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
