import 'package:flutter/material.dart';
import 'package:fourier_series/pages/dft_with_complex_number/dft_with_complex_number_drawer.dart';

class ComplexNumberDFTUserDrawing extends StatefulWidget {
  const ComplexNumberDFTUserDrawing();

  @override
  State<StatefulWidget> createState() => _DFTSWithComplexNumberstate();
}

class _DFTSWithComplexNumberstate extends State<ComplexNumberDFTUserDrawing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            width: 804,
            height: 604,
            decoration: BoxDecoration(
              color: Colors.black.withGreen(17),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: DFTWithComplexNumberDrawer(),
            // child: ,
          ),
        ),
      ),
    );
  }
}
