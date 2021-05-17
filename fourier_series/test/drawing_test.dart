import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fourier_series/view/models/drawing_model.dart';
import 'package:fourier_series/view/models/shape_model.dart';

main() {
  group('Drawing entity', () {
    test('Tests shapes changes', () {
      final s1 = DrawingModel(shapes: [
        ShapeModel(points: [Offset(1, 0)])
      ]);

      final s2 = DrawingModel(shapes: [
        ShapeModel(points: [Offset(1, 0)])
      ]);

      expect(listEquals(s1.shapes, s2.shapes), true);

      s2.shapes.clear();

      expect(listEquals(s1.shapes, s2.shapes), false);

      s2.shapes = [
        ShapeModel(points: [Offset(0, 1)])
      ];
      expect(listEquals(s1.shapes, s2.shapes), false);

      s2.shapes = [
        ShapeModel(points: [Offset(1, 0)])
      ];
      expect(listEquals(s1.shapes, s2.shapes), true);

      s2.shapes = [
        ShapeModel(points: [Offset(1, 0), Offset(1, 0)])
      ];
      expect(listEquals(s1.shapes, s2.shapes), false);
    });

    test('Tests fourier list changes', () {
      final d = DrawingModel(fourierList: []);
      final d2 = DrawingModel(fourierList: []);

      expect(d == d2, true);

      // final fourier = {'amp': 20, 'freq': 1.0, 'im': 3, 'phase': 10, 're': 2};

      // d2.addFourier(fourier);
      // expect(d != d2, true);

      // d.addFourier(fourier);
      // expect(d == d2, true);
    });
  });
}
