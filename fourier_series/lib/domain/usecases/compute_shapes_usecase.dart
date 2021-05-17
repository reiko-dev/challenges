import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/domain/entities/fourier.dart';
import 'package:fourier_series/view/models/drawing_model.dart';
import 'package:fourier_series/view/models/shape_model.dart';
import 'package:fourier_series/domain/algorithms/dft_algorithm.dart';

class ComputeDrawingUsecase {
  //TODO: Optmize this method.
  //Run part of the DFT algorithm for the edited shapes and sort the new amount of values.
  Future<List<Fourier>> call(DrawingModel drawing, int skipValue) async {
    final List<Offset> points = [];

    drawing.shapes.forEach((ShapeModel shape) {
      for (int i = 0; i < shape.points.length; i += skipValue)
        points.add(shape.points[i]);
    });

    return await compute(computeUserDrawingData, points);
  }
}
