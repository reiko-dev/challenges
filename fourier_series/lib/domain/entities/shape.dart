import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Shape extends GetxController {
  factory Shape({
    Color color = Colors.white,
    List<Offset> points = const [],
    double strokeWidth = 1,
  }) =>
      Shape._internal(
        color,
        strokeWidth,
        [...points],
      );

  Shape._internal(this._color, this.strokeWidth, this._points);

  Color _color;
  List<Offset> _points;
  double strokeWidth;

  Color get color => _color;

  set color(Color newColor) {
    _color = newColor;

    update();
  }

  List<Offset> get points => _points;

  set points(List<Offset> newPointsList) {
    _points = newPointsList;
    update();
  }
}
