import 'dart:math';

///Implementation of the mathematic formula of dft on Wikipedia:
///https://wikimedia.org/api/rest_v1/media/math/render/svg/18b0e4c82f095e3789e51ad8c2c6685306b5662b
///
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

    //imaginary component
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

    //adds, respectively:
    //amplitud, frequency, imaginary number, phase and real number
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

  final drawing = input['drawing'];
  for (int i = 0; i < drawing.length; i += input['skip'] as int) {
    signalX.add(drawing[i]['x']);
    signalY.add(drawing[i]['y']);
  }

  var fourierX = dftRealPartAlgorithm(signalX);
  var fourierY = dftRealPartAlgorithm(signalY);

  fourierX.sort((a, b) => b['amp'].compareTo(a['amp']));
  fourierY.sort((a, b) => b['amp'].compareTo(a['amp']));

  input['fourierX'] = fourierX;
  input['fourierY'] = fourierY;
  return input;
}
