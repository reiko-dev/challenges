import 'package:flutter/material.dart';
import 'package:fourier_series/fourier_painters/dft_two_epycicles_with_compute.dart';
import 'package:fourier_series/user_drawing.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _startAnimation = false;
  List<Map<String, double>> drawing2 = [];

  void onPanUpdate(DragUpdateDetails dragDetails) {
    print(dragDetails.localPosition);
    //-550 and -400 is relative to the center of the Epicycles on the X and Y axis.
    drawing2.add({
      "x": dragDetails.localPosition.dx - 550,
      "y": dragDetails.localPosition.dy - 400
    });
  }

  void showDFTDrawing(DragEndDetails x) {
    _startAnimation = true;
    setState(() {});
  }

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
              border: Border.all(color: Colors.white, width: 2),
            ),
            // child: ,
            child: _startAnimation
                ? GestureDetector(
                    onTap: () {
                      _startAnimation = false;
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.black,
                      child: DFTWithTwoEpyciclesWithCompute(drawing2),
                    ),
                  )
                : GestureDetector(
                    onPanUpdate: onPanUpdate,
                    onPanEnd: showDFTDrawing,
                    child: Container(
                      color: Colors.black,
                      child: CustomPaint(
                        painter: UserDrawing(),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
