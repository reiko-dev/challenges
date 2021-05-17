import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:fourier_series/view/pages/main/complex_dft_painter.dart';
import 'package:get/get.dart';

class BottomPanel extends StatelessWidget {
  const BottomPanel(this.onDeleteShape);

  final Function onDeleteShape;

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
    onDeleteShape(0);
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
                    onChanged: (newSkip) {
                      DrawingController.i.skipValue = newSkip.toInt();
                    }),
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
          DeleteDrawingWidget(onDeleteShape),
        ],
      ),
    );
  }
}

class DeleteDrawingWidget extends StatefulWidget {
  const DeleteDrawingWidget(this.onDeleteShape);

  final Function onDeleteShape;

  @override
  _DeleteDrawingWidgetState createState() => _DeleteDrawingWidgetState();
}

class _DeleteDrawingWidgetState extends State<DeleteDrawingWidget> {
  int? shapeIndexToRemove;
  int oldLengthOfShapes = DrawingController.i.shapes.length;

  void calculatesTheNewDrawingIndex(DrawingController dc) {
    if (dc.shapes.length == 0)
      shapeIndexToRemove = null;
    else {
      if (oldLengthOfShapes != dc.shapes.length)
        shapeIndexToRemove = dc.shapes.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrawingController>(builder: (_) {
      calculatesTheNewDrawingIndex(_);
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              if (shapeIndexToRemove != null) {
                _.removeShape(shapeIndexToRemove!);
                widget.onDeleteShape(_.shapes.length);

                if (shapeIndexToRemove == 0) {
                  if (_.shapes.isEmpty) shapeIndexToRemove = null;
                } else
                  shapeIndexToRemove = shapeIndexToRemove! - 1;
                //TODO: stop animation

                // setState(() {});
              }
            },
            child: Text('Delete Shape'),
          ),
          Container(
            width: 50,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: DropdownButton<int>(
              onChanged: (newValue) {
                oldLengthOfShapes = DrawingController.i.shapes.length;
                shapeIndexToRemove = newValue;
                setState(() {});
              },
              value: shapeIndexToRemove,
              items: List.generate(
                _.shapes.length,
                (index) => DropdownMenuItem<int>(
                  value: index,
                  child: Center(
                    child: Text('${index + 1}'),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
