//Formula img
//https://wikimedia.org/api/rest_v1/media/math/render/svg/18b0e4c82f095e3789e51ad8c2c6685306b5662b
//

import 'dart:math';

///TODO:
///What i need for a circular epicycle
///1. Amplitude (the radius)
///2. Frequency: how many cycles trough the circle does it rotate per unit of time.
///3. Phase: an offset where does this wave pattern begins.
List<dynamic> dftRealPartAlgorithm(x) {
  List<dynamic> X = [];

  final N = x.length;

  for (var k = 0; k < N; k++) {
    //real component
    double re = 0;

    //imaginaery component
    double im = 0;

    for (var n = 0; n < N; n++) {
      var phi = (2 * pi * k * n) / N;

      re += x[n] * cos(phi);

      im -= x[n] * sin(phi);
    }

    re = re / N;
    im = im / N;

    var freq = k;
    var amp = sqrt(re * re + im * im);
    var phase = atan2(im, re);

    // X[k] = {re, im}; //this is used on the tube
    X.add({
      'amp': amp,
      'freq': freq,
      'im': im,
      'phase': phase,
      're': re,
    });
  }

  return X;
}

///
/// The input is a map like:
/// ```dart
/// {
///   'drawing': [
///     {"x": -75.23920093800275, "y": -9.276916512631997},
///     [...]
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
///   'fourierX': { 'amp': amp, 'freq': freq, 'im': im, 'phase': phase, 're': re,}
///   'fourierY': { 'amp': amp, 'freq': freq, 'im': im, 'phase': phase, 're': re,}
/// }
/// ```
void computingDrawingData(Map input) {
  //This is the signal, any arbitrary digital signal/array of numbers
  var signalX = [];
  var signalY = [];

  int skip = 3;
  final drawing = input['drawing'];
  for (int i = 0; i < drawing.length; i += skip) {
    signalX.add(drawing[i]['x']);
    signalY.add(drawing[i]['y']);
  }

  var fourierX = dftRealPartAlgorithm(signalX);
  var fourierY = dftRealPartAlgorithm(signalY);

  fourierX.sort((a, b) => b['amp'].compareTo(a['amp']));
  fourierY.sort((a, b) => b['amp'].compareTo(a['amp']));

  input['fourierX'] = fourierX;
  input['fourierY'] = fourierY;
}
