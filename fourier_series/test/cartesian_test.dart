import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fourier_series/maths/cartesian.dart';

void main() {
  final p1 = Offset(-3, -1);
  final p2 = Offset(5, 2);

  final distance = calculatesDistance(p2, p1).floor();
  final mediumPoint = calculatesMediumPoint(p1, p2);
  final generalEquation = GeneralEquation.fromTwoPoints(p1, p2);

  test('Tests the cartesian classes', () {
    expect(distance, 8);

    expect(mediumPoint, Offset(1.0, 0.5));

    expect(generalEquation.a, -3.0);
    expect(generalEquation.b, 8.0);
    expect(generalEquation.c, -1.0);

    final points = generatePoints(generalEquation, p1: p1, p2: p2);

    expect(points.length, 7);
    expect(points[0].dx, -2.0);
    expect(points[0].dy, -0.625);
  });
}
