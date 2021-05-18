import 'package:flutter/material.dart';
import 'package:fourier_series/a%20old%20stuff/fourier_painters/dft_two_epycicles_with_compute.dart';
import 'package:fourier_series/a%20old%20stuff/fourier_painters/my_drawing.dart';
import 'package:fourier_series/a%20old%20stuff/fourier_painters/user_drawing.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _startAnimation = false;
  int xEpicyclePosition = 550, yEpicyclePosition = 400;
  int currentUserDrawingIndex = 0;

  //Each list is painted drawing lines from the first to the last point.
  List<List<Offset>> userDrawingList = [];

  void onPanUpdate(DragUpdateDetails dragDetails) {
    if (currentUserDrawingIndex >= userDrawingList.length)
      userDrawingList.add([]);

    //-550 and -400 is relative to the center of the Epicycles on the X and Y axis.
    userDrawingList[currentUserDrawingIndex].add(Offset(
      dragDetails.localPosition.dx - xEpicyclePosition,
      dragDetails.localPosition.dy - yEpicyclePosition,
    ));

    if (mounted && !_startAnimation) setState(() {});
  }

  void showDFTDrawing() {
    _startAnimation = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            children: [
              Spacer(),
              Container(
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
                          currentUserDrawingIndex = 0;
                          userDrawingList = [];
                          setState(() {});
                        },
                        child: Container(
                          color: Colors.black,
                          child: DFTWithTwoEpyciclesWithCompute([myDrawing], 1),
                        ),
                      )
                    : GestureDetector(
                        onPanUpdate: onPanUpdate,
                        onPanEnd: (_) => currentUserDrawingIndex++,
                        child: Container(
                          color: Colors.black,
                          child: CustomPaint(
                            painter: UserDrawing(
                              [...userDrawingList],
                              xEpicyclePosition,
                              yEpicyclePosition,
                            ),
                          ),
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: showDFTDrawing,
                    child: Text('Run DFT'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _startAnimation = false;
                      currentUserDrawingIndex = 0;
                      userDrawingList = [];
                      setState(() {});
                    },
                    child: Text('Clear'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
