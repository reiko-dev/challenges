import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:fourier_series/view/pages/main/animation_preview.dart';
import 'package:fourier_series/view/pages/main/bottom_panel.dart';
import 'package:fourier_series/view/pages/main/drawing_animation.dart';

import 'package:fourier_series/domain/controllers/drawing_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage();

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
              child: GetBuilder<DrawingController>(
                builder: (_) => _.animationState == AnimationState.not_ready
                    ? const AnimationPreview()
                    : GestureDetector(
                        onTap: () {
                          //TODO: If it's running an animation: stop and shows the pause icon.
                          //Else, tries to select a Shape.
                        },
                        child: const DrawingAnimation(),
                      ),
              ),
            ),
            Spacer(),
            BottomPanel(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
