import 'package:flutter/material.dart';
import 'package:fourier_series/fourier_painters/fourier_painter.dart';

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Container(
            width: 904,
            height: 604,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: FourierSquaresPainter(),
          ),
        ),
      ),
    );
  }
}
