import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:get/get.dart';

class CenterPanel extends StatefulWidget {
  const CenterPanel({Key? key}) : super(key: key);

  @override
  _CenterPanelState createState() => _CenterPanelState();
}

class _CenterPanelState extends State<CenterPanel> {
  final dxController = TextEditingController();
  final dyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Center:'),
          Container(
            // color: Colors.red,
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  child: Text(
                    ' X: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 70,
                  height: 50,
                  child: GetBuilder<DrawingController>(
                    initState: (_) {
                      final drawingController = DrawingController.i;

                      dxController.text = drawingController.ellipsisCenter.dx
                          .truncate()
                          .toString();

                      dxController.addListener(() {
                        final dx = double.tryParse(dxController.text);
                        if (dx == null) {
                          print(
                              'Error ellipsisCenter.dx value ${dyController.text} not valid.');
                          return;
                        }

                        drawingController.ellipsisCenter =
                            Offset(dx, drawingController.ellipsisCenter.dy);
                      });
                    },
                    dispose: (_) {
                      dxController.dispose();
                    },
                    builder: (_) {
                      return TextField(
                        controller: dxController,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        textAlign: TextAlign.center,
                        maxLength: 4,
                        style: TextStyle(
                          color: const Color(0xFF2196F3),
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Text(
                    ' Y: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 70,
                  height: 50,
                  child: GetBuilder<DrawingController>(
                    initState: (_) {
                      final drawingController = DrawingController.i;

                      dyController.text = drawingController.ellipsisCenter.dy
                          .truncate()
                          .toString();

                      dyController.addListener(() {
                        final dy = double.tryParse(dyController.text);

                        if (dy == null) {
                          print(
                              'Error ellipsisCenter.dy value ${dyController.text} not valid.');
                          return;
                        }

                        drawingController.ellipsisCenter =
                            Offset(drawingController.ellipsisCenter.dx, dy);
                      });
                    },
                    dispose: (_) {
                      dyController.dispose();
                    },
                    builder: (_) {
                      return TextField(
                        controller: dyController,
                        textAlign: TextAlign.center,
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        maxLength: 4,
                        style: TextStyle(
                          color: const Color(0xFF2196F3),
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
