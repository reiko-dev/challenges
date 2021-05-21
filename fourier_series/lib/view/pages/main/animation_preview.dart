import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fourier_series/view/models/shape_model.dart';

import 'package:get/get.dart';

import 'package:fourier_series/domain/controllers/drawing_controller.dart';

///It's necessary to use statefullWidget because ValueBuilder doesn't works properly in this specific situation!
class AnimationPreview extends StatefulWidget {
  const AnimationPreview();

  @override
  _AnimationPreviewState createState() => _AnimationPreviewState();
}

class _AnimationPreviewState extends State<AnimationPreview> {
  bool newList = true;

  void onPanUpdate(DragUpdateDetails dragDetails) {
    final point = Offset(
      dragDetails.localPosition.dx,
      dragDetails.localPosition.dy,
    );

    if (newList) {
      DrawingController.i.addShape(ShapeModel(points: [point]));
      newList = false;
    } else
      DrawingController.i.addPoint(point);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: (_) => newList = true,
      child: Container(
        color: Colors.black,
        child: GetBuilder<DrawingController>(builder: (drawingController) {
          return drawingController.hasPoint()
              ? CustomPaint(
                  painter: AnimationPreviewPainter(dc: drawingController),
                )
              : SizedBox.shrink();
        }),
      ),
    );
  }
}

class AnimationPreviewPainter extends CustomPainter {
  AnimationPreviewPainter({required this.dc});

  final DrawingController dc;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = dc.selectedShape!.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = Colors.white;

    dc.shapes.forEach((shape) {
      final path = Path()
        ..moveTo(
          shape.points.first.dx,
          shape.points.first.dy,
        );
      shape.points.forEach((element) {
        path.lineTo(element.dx, element.dy);
      });
      canvas.drawPath(
        path,
        paint
          ..strokeWidth = shape.strokeWidth
          ..color = shape.color,
      );
    });
  }

  @override
  bool shouldRepaint(covariant old) => true;
}
