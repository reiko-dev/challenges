import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:fourier_series/view/pages/main/ellipsis_position_panel.dart';
import 'package:fourier_series/view/pages/main/complex_dft_painter.dart';
import 'package:fourier_series/view/pages/main/delete_shape.dart';
import 'package:get/get.dart';

class BottomPanel extends StatelessWidget {
  const BottomPanel();

  void showDrawingAnimation(DrawingController drawingController) {
    drawingController.startAnimation();
    ComplexDFTPainter.clean();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrawingController>(
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => showDrawingAnimation(_),
            child: Text('Run DFT'),
          ),
          SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {
              _.shapes = [];
              ComplexDFTPainter.clean();
              _.clearData();
            },
            child: Text('Clear'),
            style: ElevatedButton.styleFrom(primary: Colors.red),
          ),
          SizedBox(width: 20),
          Column(
            children: [
              Text(
                'Skip value:',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Container(
                width: 200,
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
          SizedBox(width: 20),
          Column(
            children: [
              Text(
                'Line width:',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Container(
                // color: Colors.white,
                width: 200,
                height: 40,
                child: Slider(
                    value: _.strokeWidth,
                    label: '${_.strokeWidth}',
                    activeColor: Colors.purple,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (newWidth) => _.strokeWidth = newWidth),
              ),
            ],
          ),
          SizedBox(width: 20),

          //Sets the center point for the ellipsis group.
          const EllipsisPositionPanel(),

          // DeleteDrawingWidget(onDeleteShape),
          const DeleteShape(),
        ],
      ),
    );
  }
}
