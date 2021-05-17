import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:fourier_series/view/pages/main/complex_dft_painter.dart';
import 'package:fourier_series/view/pages/main/delete_shape.dart';
import 'package:get/get.dart';

class BottomPanel extends StatelessWidget {
  const BottomPanel();

  void showDrawingAnimation(DrawingController drawingController) {
    if (drawingController.shapes.isEmpty) {
      print('userDrawingList not valid');
      return;
    }
    ComplexDFTPainter.clean();
  }

  void clearDrawing(DrawingController dc) {
    dc.shapes = [];
    ComplexDFTPainter.clean();
    dc.clearData;
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
            onPressed: () => clearDrawing(_),
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
                // color: Colors.white,
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
          // DeleteDrawingWidget(onDeleteShape),
          const DeleteShape(),
        ],
      ),
    );
  }
}
