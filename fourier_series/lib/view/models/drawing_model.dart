import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/domain/entities/fourier.dart';
import 'package:fourier_series/view/models/shape_model.dart';

class DrawingModel {
  factory DrawingModel({
    List<ShapeModel> shapes = const [],
    double strokeWidth = 1,
    List<Fourier> fourierList = const [],
    int skipValue = 1,
    Offset ellipsisCenter = Offset.zero,
  }) {
    return DrawingModel._internal(
        [...shapes], strokeWidth, [...fourierList], skipValue, ellipsisCenter);
  }

  DrawingModel._internal(this.shapes, this.strokeWidth, this.fourierList,
      this.skipValue, this.ellipsisCenter)
      : assert(strokeWidth > 0 && skipValue > 0);

  //properties
  List<ShapeModel> shapes;
  double strokeWidth;
  List<Fourier> fourierList;
  int skipValue;
  Offset ellipsisCenter;

  clear() {
    shapes = [];
    strokeWidth = 1;
    fourierList = [];
    skipValue = 1;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingModel &&
          runtimeType == other.runtimeType &&
          listEquals(shapes, other.shapes) &&
          strokeWidth == other.strokeWidth &&
          listEquals(fourierList, other.fourierList) &&
          skipValue == other.skipValue;

  @override
  int get hashCode =>
      shapes.hashCode + strokeWidth.hashCode + fourierList.hashCode;
}
