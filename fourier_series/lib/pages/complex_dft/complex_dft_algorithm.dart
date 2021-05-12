import 'dart:math';

import 'package:flutter/cupertino.dart';

class Complex {
  dynamic re, im;

  Complex(this.re, this.im);

  mult(c) {
    final re = this.re * c.re - this.im * c.im;
    final im = this.re * c.im + this.im * c.re;

    return Complex(re, im);
  }

  add(c) {
    this.re += c.re;
    this.im += c.im;
  }
}

///Implementation of the mathematic formula of dft on Wikipedia:
///https://wikimedia.org/api/rest_v1/media/math/render/svg/18b0e4c82f095e3789e51ad8c2c6685306b5662b
///
///What i need for a circular epicycle
///1. Amplitude (the radius)
///2. Frequency: how many cycles trough the circle does it rotate per unit of time.
///3. Phase: an offset where does this wave pattern begins.
List<dynamic> complexNumberDFTAlgorithm(x) {
  List<Map<String, dynamic>> X = [];

  final N = x.length;

  for (var k = 0; k < N; k++) {
    var sum = Complex(0, 0);

    for (var n = 0; n < N; n++) {
      final phi = (2 * pi * k * n) / N;

      final c = Complex(cos(phi), -sin(phi));

      sum.add(x[n].mult(c));
    }

    sum.re = sum.re / N;
    sum.im = sum.im / N;

    var freq = k;
    var amp = sqrt(sum.re * sum.re + sum.im * sum.im);
    var phase = atan2(sum.im, sum.re);

    //adds, respectively:
    //amplitud, frequency, imaginary number, phase and real number
    X.add({
      'amp': amp,
      'freq': freq,
      'im': sum.im,
      'phase': phase,
      're': sum.re,
    });
  }

  return X;
}

///
/// The input is a map like:
///
///skip is the amount of points to be rendered.
///
///a) if skip=1, (1/1) of the entered points will be rendered.
///
///b) if skip=10, 1/10 points will be rendered.
/// ```dart
/// {
///

///
///   'skip': 3,
///   'drawing': [
///     {"x": -75.23920093800275, "y": -9.276916512631997},
///     ...
///     {"x": -75.23920093800275, "y": -9.276916512631997},
///    ]
/// }
/// ```
/// The input results in the map:
/// ```dart
/// {
///   'drawing': [
///     {"x": -75.23920093800275, "y": -9.276916512631997},
///     [...]
///     {"x": -75.23920093800275, "y": -9.276916512631997},
///    ],
///   'fourierX': [
///     {'amp': amp, 'freq': freq, 'im': im, 'phase': phase, 're': re,},
///     ...
///     {'amp': amp, 'freq': freq, 'im': im, 'phase': phase, 're': re,},
///    ],
///   'fourierY': [
///     {'amp': amp, 'freq': freq, 'im': im, 'phase': phase, 're': re,},
///     ...
///     {'amp': amp, 'freq': freq, 'im': im, 'phase': phase, 're': re,},
///    ],
/// }
/// ```
Map<String, dynamic> computeDrawingData(Map<String, dynamic> input) {
  //This is the signal, any arbitrary digital signal/array of numbers
  var signalX = [];
  var signalY = [];

  final drawing = input['drawing'] as List<Offset>;
  for (int i = 0; i < drawing.length; i += input['skip'] as int) {
    signalX.add(drawing[i].dx);
    signalY.add(drawing[i].dy);
  }

  var fourierX = complexNumberDFTAlgorithm(signalX);
  var fourierY = complexNumberDFTAlgorithm(signalY);

  //Sort the values
  fourierX.sort((a, b) => b['amp'].compareTo(a['amp']));
  fourierY.sort((a, b) => b['amp'].compareTo(a['amp']));

  input['fourierX'] = fourierX;
  input['fourierY'] = fourierY;
  return input;
}
