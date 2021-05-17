import 'package:fourier_series/view/models/shape_model.dart';
import 'package:get/get.dart';

class ShapeController extends GetxController {
  ShapeController(this._shape);

  ShapeModel _shape;

  ShapeModel get shape => _shape;

  set shape(ShapeModel shape) {
    _shape = shape;
    update();
  }
}
