import 'package:flutter/material.dart';
import 'package:fourier_series/pages/complex_dft/complex_dft_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ComplexNumberDFTUserDrawingPage(),
    );
  }
}
