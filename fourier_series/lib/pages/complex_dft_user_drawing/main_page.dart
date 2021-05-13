import 'package:flutter/material.dart';
import 'package:fourier_series/pages/complex_dft_user_drawing/complex_dft_painter.dart';
import 'package:fourier_series/pages/complex_dft_user_drawing/drawing_animation.dart';
import 'package:fourier_series/pages/complex_dft_user_drawing/user_drawing.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _startAnimation = false;
  //the center of the Epicycles on the X and Y axis.
  int xEpicyclePosition = 400, yEpicyclePosition = 300;
  int currentUserDrawingIndex = 0;

  //Each list is painted drawing lines from the first to the last point.
  List<List<Offset>> userDrawingList = [];

  void onPanUpdate(DragUpdateDetails dragDetails) {
    if (currentUserDrawingIndex >= userDrawingList.length)
      userDrawingList.add([]);

    userDrawingList[currentUserDrawingIndex].add(Offset(
      dragDetails.localPosition.dx - xEpicyclePosition,
      dragDetails.localPosition.dy - yEpicyclePosition,
    ));

    if (mounted && !_startAnimation) setState(() {});
  }

  void showDFTDrawing() {
    if (userDrawingList.length < 1 ||
        (userDrawingList.length == 3 && userDrawingList[0].length < 1)) {
      print('userDrawingList not valid');
      return;
    }

    if (!_startAnimation) _startAnimation = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Spacer(flex: 3),
            Container(
              width: 804,
              height: 604,
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(16),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: _startAnimation
                  ? GestureDetector(
                      onTap: () {
                        _startAnimation = false;
                        currentUserDrawingIndex = 0;
                        userDrawingList = [];
                        ComplexDFTPainter.clean();
                        setState(() {});
                      },
                      child: DrawingAnimation(userDrawingList, 4),
                      // child: DrawingAnimation([drawing], 7),
                    )
                  : GestureDetector(
                      onPanUpdate: onPanUpdate,
                      onPanEnd: (_) => currentUserDrawingIndex++,
                      child: Container(
                        color: Colors.black,
                        child: CustomPaint(
                          painter: ComplexDFTUserDrawing(
                            [...userDrawingList],
                            xEpicyclePosition,
                            yEpicyclePosition,
                          ),
                        ),
                      ),
                    ),
            ),
            Spacer(),
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
                    ComplexDFTPainter.clean();
                    setState(() {});
                  },
                  child: Text('Clear'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
