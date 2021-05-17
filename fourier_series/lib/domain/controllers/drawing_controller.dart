import 'package:flutter/material.dart';
import 'package:fourier_series/domain/entities/shape.dart';

import 'package:get/get.dart';

import 'package:fourier_series/domain/entities/fourier.dart';
import 'package:fourier_series/domain/usecases/compute_shapes_usecase.dart';
import 'package:fourier_series/view/models/drawing_model.dart';
import 'package:fourier_series/view/models/shape_model.dart';

class DrawingController extends GetxController {
  final computeDrawingUsecase = ComputeDrawingUsecase();

  static DrawingController get i => Get.find();

  DrawingController();

  //properties
  final _drawing = DrawingModel();

  List<ShapeModel> get shapes => _drawing.shapes;

  double get strokeWidth => _drawing.strokeWidth;

  List<Fourier> get fourierList => _drawing.fourierList;

  int get skipValue => _drawing.skipValue;

  set shapes(List<ShapeModel> newShapes) {
    _drawing.shapes = newShapes;
    update();
  }

  void addShape(ShapeModel shape) {
    _drawing.shapes.add(shape);
    update();
  }

  void removeShape(int shapeIndex) {
    _drawing.shapes.removeAt(shapeIndex);
    update();
  }

  void addPoint(Offset point, int shapeIndex) {
    if (shapeIndex < _drawing.shapes.length) {
      _drawing.shapes[shapeIndex].addPoint(point);
      update();
    } else {
      if (shapeIndex == _drawing.shapes.length)
        _drawing.shapes.add(ShapeModel(points: [point]));
      else
        print('Error when trying to add a point.');
    }
  }

  bool hasPoint() {
    return _drawing.shapes.isNotEmpty && _drawing.shapes[0].points.length > 0;
  }

  set strokeWidth(double newStrokeWidth) {
    if (newStrokeWidth <= 0)
      print('Invalid newStrokeWidth $newStrokeWidth');
    else {
      _drawing.strokeWidth = newStrokeWidth;
      update();
    }
  }

  set fourierList(List<Fourier> newFourierList) {
    _drawing.fourierList = newFourierList;
    update();
  }

  void addFourier(Fourier fourier) {
    _drawing.fourierList.add(fourier);
    update();
  }

  set skipValue(int newSkipValue) {
    //TODO: verify if the animation is stopped, if true, do not render automatically another animation.
    //Unless the user runs the DFT pressing the Run DFT button
    _drawing.skipValue = newSkipValue;

    if (fourierList.isNotEmpty)
      computeDrawingData();
    else
      update();

    print(_drawing.skipValue);
  }

  Future<void> computeDrawingData() async {
    fourierList = [];
    fourierList = await computeDrawingUsecase(_drawing, skipValue);
    update();
  }
}
