import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:fourier_series/utils/dimensions_percent.dart';

import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:fourier_series/view/pages/main/ellipsis_position_panel.dart';
import 'package:fourier_series/view/pages/main/complex_dft_painter.dart';
import 'package:fourier_series/view/pages/main/selected_shape_actions.dart';

class BottomPanel extends StatelessWidget {
  BottomPanel() : super(key: UniqueKey());
  final scrollController = ScrollController(initialScrollOffset: 10);

  void showDrawingAnimation(DrawingController drawingController) {
    drawingController.startAnimation();
    ComplexDFTPainter.clean();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75.0.wp,
      height: 15.0.hp,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Scrollbar(
          controller: scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: GetBuilder<DrawingController>(
              builder: (_) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 1.0.wp),
                  ElevatedButton(
                    onPressed: () => showDrawingAnimation(_),
                    child: Text('Run DFT'),
                  ),
                  SizedBox(width: 2.0.wp),
                  ElevatedButton(
                    onPressed: () {
                      _.shapes = [];
                      ComplexDFTPainter.clean();
                      _.clearData();
                    },
                    child: Text('Clear'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                  SizedBox(width: 2.0.wp),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Skip value:',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Container(
                        width: 150,
                        height: 40,
                        child: Slider(
                          value: DrawingController.i.skipValue.toDouble(),
                          label: '${DrawingController.i.skipValue}',
                          activeColor: Colors.green,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          onChanged: (newSkip) =>
                              DrawingController.i.skipValue = newSkip.toInt(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 1.0.wp),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Line width:',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Container(
                        width: 150,
                        height: 40,
                        child: Slider(
                          value: _.selectedShape?.strokeWidth ?? 1,
                          label: '${_.selectedShape?.strokeWidth ?? 1}',
                          activeColor: Colors.purple,
                          min: 1,
                          max: 10,
                          divisions: 9,
                          onChanged: _.selectedShape == null
                              ? null
                              : (value) => _.strokeWidth = value,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 1.0.wp),

                  //Sets the center point for the ellipsis group.
                  const EllipsisPositionPanel(),

                  SizedBox(width: 1.0.wp),

                  const SelectedShape(),

                  SizedBox(width: 1.0.wp),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
