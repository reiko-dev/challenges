import 'package:flutter/material.dart';
import 'package:fourier_series/pages/complex_dft/complex_dft_drawer.dart';

class ComplexNumberDFTUserDrawingPage extends StatefulWidget {
  const ComplexNumberDFTUserDrawingPage();

  @override
  State<StatefulWidget> createState() => _DFTSWithComplexNumberstate();
}

class _DFTSWithComplexNumberstate
    extends State<ComplexNumberDFTUserDrawingPage> {
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