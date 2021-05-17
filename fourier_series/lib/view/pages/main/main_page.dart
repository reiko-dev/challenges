import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:fourier_series/utils/dimensions_percent.dart';

import 'package:fourier_series/domain/entities/shape.dart';
import 'package:fourier_series/view/pages/main/animation_preview.dart';
import 'package:fourier_series/view/pages/main/bottom_panel.dart';
import 'package:fourier_series/view/pages/main/drawing_animation.dart';

import 'package:fourier_series/domain/controllers/drawing_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final drawingController = DrawingController.i;
  int? drawingIndexToRemove;

  bool _startAnimation = false;

  //Centralizes the the Epicycles
  double xEpicyclePosition = 50.0.wp, yEpicyclePosition = 50.0.hp;

  int currentShapeIndex = 0;

  List<Shape> shapes = [];

  void onPanUpdate(DragUpdateDetails dragDetails) {
    drawingController.addPoint(
      Offset(
        dragDetails.localPosition.dx - xEpicyclePosition,
        dragDetails.localPosition.dy - yEpicyclePosition,
      ),
      currentShapeIndex,
    );
  }

  onDeleteShape(int newValue) {
    if (newValue >= 0)
      currentShapeIndex = newValue;
    else
      print('Can\'t delete a non existent shape.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: Get.width,
        height: Get.height,
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
                        //TODO: If it's running an animation: stop and shows the pause icon.
                        //Else, tries to select a Shape.
                      },
                      child: const DrawingAnimation(),
                    )
                  : GestureDetector(
                      onPanUpdate: onPanUpdate,
                      onPanEnd: (_) {
                        drawingIndexToRemove = currentShapeIndex;
                        currentShapeIndex++;
                      },
                      child: Container(
                        color: Colors.black,
                        child: const AnimationPreview(),
                      ),
                    ),
            ),
            Spacer(),
            BottomPanel(onDeleteShape),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
