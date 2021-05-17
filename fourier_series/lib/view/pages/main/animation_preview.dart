import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:fourier_series/utils/dimensions_percent.dart';

import 'package:fourier_series/domain/controllers/drawing_controller.dart';

class AnimationPreview extends StatelessWidget {
  const AnimationPreview();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrawingController>(builder: (drawingController) {
      return drawingController.hasPoint()
          ? CustomPaint(
              painter: AnimationPreviewPainter(
                drawing: drawingController,
                xEpicylePosition: 50.0.wp,
                yEpicylePosition: 50.0.hp,
              ),
            )
          : Container();
    });
  }
}

class AnimationPreviewPainter extends CustomPainter {
  AnimationPreviewPainter({
    required this.xEpicylePosition,
    required this.yEpicylePosition,
    required this.drawing,
  });

  final double xEpicylePosition, yEpicylePosition;
  final DrawingController drawing;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = drawing.strokeWidth
      ..color = Colors.white;

    drawing.shapes.forEach((shape) {
      final path = Path()
        ..moveTo(
          shape.points.first.dx + xEpicylePosition,
          shape.points.first.dy + yEpicylePosition,
        );
      shape.points.forEach((element) {
        path.lineTo(
            element.dx + xEpicylePosition, element.dy + yEpicylePosition);
      });
      canvas.drawPath(path, paint);
    });
  }

  @override
  bool shouldRepaint(covariant old) => true;
}
