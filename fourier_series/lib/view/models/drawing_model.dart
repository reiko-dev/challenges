import 'package:flutter/foundation.dart';
import 'package:fourier_series/domain/entities/fourier.dart';
import 'package:fourier_series/view/models/shape_model.dart';

class DrawingModel {
  factory DrawingModel({
    List<ShapeModel> shapes = const [],
    double strokeWidth = 1,
    List<Fourier> fourierList = const [],
    int skipValue = 1,
  }) {
    return DrawingModel._internal(
        [...shapes], strokeWidth, [...fourierList], skipValue);
  }

  DrawingModel._internal(
      this.shapes, this.strokeWidth, this.fourierList, this.skipValue)
      : assert(strokeWidth > 0 && skipValue > 0);

  //properties
  List<ShapeModel> shapes;
  double strokeWidth;
  List<Fourier> fourierList;
  int skipValue;

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
