import 'package:flutter/material.dart';
import 'package:fourier_series/view/models/shape_model.dart';

import 'package:get/get.dart';
import 'package:fourier_series/utils/dimensions_percent.dart';

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
  bool _startAnimation = false;
  bool newList = true;

  void onPanUpdate(DragUpdateDetails dragDetails) {
    //50.0.hp/wp Centralizes the the Epicycles
    final point = Offset(
      dragDetails.localPosition.dx - 50.0.wp,
      dragDetails.localPosition.dy - 50.0.hp,
    );

    if (newList) {
      DrawingController.i.addShape(ShapeModel(points: [point]));
      newList = false;
    } else
      DrawingController.i.addPoint(point);
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
                      onPanEnd: (_) => newList = true,
                      child: Container(
                        color: Colors.black,
                        child: const AnimationPreview(),
                      ),
                    ),
            ),
            Spacer(),
            const BottomPanel(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}