import 'package:flutter/material.dart';
import 'package:fourier_series/view/models/drawing_model.dart';
import 'package:fourier_series/view/models/shape_model.dart';

class AddShapeUsecase {
  bool call(
    DrawingModel drawing, {
    Color color = Colors.white,
    required List<Offset> points,
    double strokeWidth = 1,
  }) {
    drawing.shapes.add(
        ShapeModel(color: color, points: points, strokeWidth: strokeWidth));
    return true;
  }
}
