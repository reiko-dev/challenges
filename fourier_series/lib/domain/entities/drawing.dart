import 'package:fourier_series/domain/entities/shape.dart';
import 'package:get/get.dart';

class Drawing extends GetxController {
  factory Drawing({
    List<Shape> shapes = const [],
    double strokeWidth = 1,
  }) {
    return Drawing._internal([...shapes], strokeWidth);
  }

  Drawing._internal(this._shapes, this._strokeWidth);

  //properties
  List<Shape> _shapes;
  double _strokeWidth;

  List<Shape> get shapes => _shapes;
  set shapes(List<Shape> newShapes) {
    _shapes = newShapes;
    update();
  }

  double get strokeWidth => _strokeWidth;

  set strokeWidth(double newStrokeWidth) {
    _strokeWidth = newStrokeWidth;
    update();
  }
}
