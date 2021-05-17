import 'package:flutter/material.dart';
import 'package:fourier_series/view/models/shape_model.dart';

class SkipPointsFromShapeUsecase {
  List<Offset> skipPoints(ShapeModel shape, int skipValue) {
    final List<Offset> listWithSkippedIPoints = [];

    for (int i = 0; i < shape.points.length; i += skipValue) {
      listWithSkippedIPoints.add(shape.points[i]);
    }

    return listWithSkippedIPoints;
  }
}
