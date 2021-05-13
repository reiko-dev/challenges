import 'dart:math';

import 'package:flutter/material.dart';

double calculatesDistance(Offset p1, Offset p2) {
  return sqrt(pow((p2.dx - p1.dx), 2) + pow(p2.dy - p1.dy, 2));
}

Offset calculatesMediumPoint(Offset p1, Offset p2) {
  double xm = (p1.dx + p2.dx) / 2;
  double ym = (p1.dy + p2.dy) / 2;

  return Offset(xm, ym);
}

List<Offset> generatePoints(
  GeneralEquation ge, {
  required Offset p1,
  required Offset p2,
}) {
  int numberOfPoints = calculatesDistance(p1, p2).floor();

  if (numberOfPoints < 1) return [];

  final List<Offset> points = [];

  double lowerXPoint = p1.dx, greatherXPoint = p2.dx;

  if (p1.dx > p2.dx) {
    lowerXPoint = p2.dx;
    greatherXPoint = p1.dx;
  }

  //
  double incrementSize = (greatherXPoint - lowerXPoint) / numberOfPoints;

  for (int i = 0; i < numberOfPoints - 1; i++) {
    lowerXPoint += incrementSize;
    final dy = (ge.a * lowerXPoint + ge.c) / (ge.b * -1);

    points.add(Offset(lowerXPoint, dy));
  }

  return points;
}

class GeneralEquation {
  GeneralEquation(this.a, this.b, this.c);
  double a, b, c;

  factory GeneralEquation.fromTwoPoints(Offset p1, Offset p2) {
    return calculatesGeneralEquationFromPoints(p1, p2);
  }

  static GeneralEquation calculatesGeneralEquationFromPoints(
      Offset p1, Offset p2) {
    double a = p1.dy - p2.dy;
    double b = p2.dx - p1.dx;
    double c = p1.dx * p2.dy - p2.dx * p1.dy;

    return GeneralEquation(a, b, c);
  }

  @override
  String toString() {
    String bString = b >= 0 ? '+ ${b}y ' : '${b}y ';
    String cString = c >= 0 ? '+ ${c} ' : '$c ';

    return 'General eq.: ${a}x ' + bString + cString + '= 0';
  }
}
