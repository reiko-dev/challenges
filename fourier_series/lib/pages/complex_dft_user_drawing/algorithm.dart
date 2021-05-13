import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:fourier_series/pages/complex_dft_user_drawing/complex.dart';

///Implementation of the mathematic formula of dft on Wikipedia:
///https://wikimedia.org/api/rest_v1/media/math/render/svg/18b0e4c82f095e3789e51ad8c2c6685306b5662b
///
///What i need for a circular epicycle
///1. Amplitude (the radius)
///2. Frequency: how many cycles trough the circle does it rotate per unit of time.
///3. Phase: an offset where does this wave pattern begins.
List<Map<String, dynamic>> algorithm(List<Complex> x) {
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
/// The function returns the map:
/// ```dart
/// [
///     {'amp': amp, 'freq': freq, 'im': im, 'phase': phase, 're': re,},
///     ...
///     {'amp': amp, 'freq': freq, 'im': im, 'phase': phase, 're': re,},
///  ]
///
/// ```
List<Map<String, dynamic>> computeUserDrawingData(List<Offset> input) {
  //This is the signal, any arbitrary digital signal/array of numbers
  List<Complex> signal = [];

  final drawing = input;
  for (int i = 0; i < drawing.length; i++) {
    signal.add(Complex(drawing[i].dx, drawing[i].dy));
  }

  var fourier = algorithm(signal);

  //Sort the values
  fourier.sort((a, b) => b['amp'].compareTo(a['amp']));

  return fourier;
}
