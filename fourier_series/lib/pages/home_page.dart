import 'package:flutter/material.dart';
import 'package:fourier_series/fourier_painters/dft_with_two_epycicles.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    // var signal = [
    //   100,
    //   100,
    //   100,
    //   -100,
    //   -100,
    //   -100,
    //   100,
    //   100,
    //   100,
    //   -100,
    //   -100,
    //   -100,
    // ];

    // int aux = 0;
    // dft(signal).forEach((element) {
    //   print('$aux: $element');
    //   aux++;
    // });

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            width: 804,
            height: 604,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: DFTWithTwoEpycicles(),
          ),
        ),
      ),
    );
  }
}
