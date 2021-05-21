import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:fourier_series/utils/dimensions_percent.dart';

import 'package:fourier_series/view/pages/main/animation_preview.dart';
import 'package:fourier_series/view/pages/main/bottom_panel.dart';
import 'package:fourier_series/view/pages/main/drawing_animation.dart';

import 'package:fourier_series/domain/controllers/drawing_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 90.0.wp,
              height: 80.0.hp,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: GetBuilder<DrawingController>(
                builder: (_) => _.animationState == AnimationState.not_ready
                    ? const AnimationPreview()
                    : GestureDetector(
                        onTap: () {
                          _.animationState = AnimationState.not_ready;
                        },
                        child: const DrawingAnimation(),
                      ),
              ),
            ),
            BottomPanel(),
          ],
        ),
      ),
    );
  }
}
