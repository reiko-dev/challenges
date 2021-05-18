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
              painter: AnimationPreviewPainter(drawing: drawingController),
            )
          : Container();
    });
  }
}

class AnimationPreviewPainter extends CustomPainter {
  AnimationPreviewPainter({required this.drawing});

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
          shape.points.first.dx,
          shape.points.first.dy,
        );
      shape.points.forEach((element) {
        path.lineTo(element.dx, element.dy);
      });
      canvas.drawPath(path, paint);
    });
  }

  @override
  bool shouldRepaint(covariant old) => true;
}
