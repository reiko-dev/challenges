import 'package:flutter/material.dart';
import 'package:fourier_series/view/pages/main/complex_dft_painter.dart';

import 'package:get/get.dart';

import 'package:fourier_series/domain/entities/fourier.dart';
import 'package:fourier_series/domain/usecases/compute_shapes_usecase.dart';
import 'package:fourier_series/view/models/drawing_model.dart';
import 'package:fourier_series/view/models/shape_model.dart';

enum AnimationState { not_ready, loading, loaded, animating, stopped }

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

  //Necessary for the delete shape widget
  int? _shapeIndexToDelete;

  int? get shapeIndexToDelete => _shapeIndexToDelete;

  AnimationState _animationState = AnimationState.not_ready;

  AnimationState get animationState => _animationState;

  set shapeIndexToDelete(int? newVal) {
    _shapeIndexToDelete = newVal;
    update();
  }

  set shapes(List<ShapeModel> newShapes) {
    _drawing.shapes = newShapes;
    update();
  }

  void addShape(ShapeModel shape) {
    _drawing.shapes.add(shape);
    _shapeIndexToDelete = _drawing.shapes.length - 1;
    update();
  }

  void removeShape(int shapeIndex) {
    //TODO: stop animation
    _drawing.shapes.removeAt(shapeIndex);

    if (shapeIndexToDelete == 0) {
      if (_drawing.shapes.isEmpty)
        shapeIndexToDelete = null;
      else
        shapeIndexToDelete = _drawing.shapes.length - 1;
    } else
      shapeIndexToDelete = shapeIndexToDelete! - 1;

    _animationState = AnimationState.not_ready;

    update();
  }

  void addPoint(Offset point) {
    if (shapes.isEmpty)
      addShape(ShapeModel(points: [point]));
    else {
      _drawing.shapes.last.addPoint(point);
      update();
    }
  }

  void startAnimation() {
    if (hasPoint()) {
      computeDrawingData();
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

  void _fourierList(List<Fourier> newFourierList, AnimationState state) {
    _drawing.fourierList = newFourierList;
    _animationState = state;
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
    _animationState = AnimationState.not_ready;
    ComplexDFTPainter.clean();
    update();
  }

  void clearData() {
    _drawing.clear();
    _shapeIndexToDelete = null;
    _animationState = AnimationState.not_ready;
    update();
  }

  Future<void> computeDrawingData() async {
    _fourierList([], AnimationState.loading);

    final fourierList =
        await computeDrawingUsecase(_drawing, _drawing.skipValue);

    _fourierList(fourierList, AnimationState.loaded);
  }
}
