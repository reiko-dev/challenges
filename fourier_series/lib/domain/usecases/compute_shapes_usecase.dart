import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/domain/entities/fourier.dart';
import 'package:fourier_series/view/models/drawing_model.dart';
import 'package:fourier_series/view/models/shape_model.dart';
import 'package:fourier_series/domain/algorithms/dft_algorithm.dart';

class ComputeDrawingUsecase {
  Future<List<Fourier>> call(DrawingModel drawing) async {
    final List<Offset> points = [];

    drawing.shapes.forEach((ShapeModel shape) {
      for (int i = 0; i < shape.points.length; i += drawing.skipValue)
        points.add(
          Offset(
            shape.points[i].dx - drawing.ellipsisCenter.dx,
            shape.points[i].dy - drawing.ellipsisCenter.dy,
          ),
        );
    });

    return await compute(computeUserDrawingData, points);
  }
}
