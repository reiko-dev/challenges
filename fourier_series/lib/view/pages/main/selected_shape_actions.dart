import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:fourier_series/view/pages/main/my_color_picker.dart';
import 'package:get/get.dart';

class SelectedShape extends StatelessWidget {
  const SelectedShape();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blue,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Shape actions:',
              style: Theme.of(context).textTheme.headline4,
            ).paddingSymmetric(horizontal: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: GetBuilder<DrawingController>(
                    builder: (_) {
                      return DropdownButton<int>(
                        onChanged: (val) => _.selectedShapeIndex = val,
                        value: _.selectedShapeIndex,
                        items: List.generate(
                          _.shapes.length,
                          (index) => DropdownMenuItem<int>(
                            value: index,
                            child: Center(
                              child: Text('${index + 1}'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => DrawingController.i.removeShape(),
                  child: Text('Delete'),
                ),
                SizedBox(width: 20),
                const MyColorPicker(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}