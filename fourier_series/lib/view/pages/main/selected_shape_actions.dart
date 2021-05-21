import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:fourier_series/utils/dimensions_percent.dart';

import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:fourier_series/view/pages/main/my_color_picker.dart';

class SelectedShape extends StatelessWidget {
  const SelectedShape();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.5.wp, vertical: 0.5.hp),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blue,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Shapes:',
              style: Theme.of(context).textTheme.headline4,
            ).paddingSymmetric(horizontal: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 0.5.wp),
                Container(
                  width: 60,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: GetBuilder<DrawingController>(
                    builder: (_) {
                      return DropdownButton<int>(
                        onChanged: (val) => _.selectedShapeIndex = val,
                        value: _.selectedShapeIndex,
                        iconDisabledColor: Colors.grey.shade600,
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
                SizedBox(width: 1.0.wp),
                ElevatedButton(
                  onPressed: () => DrawingController.i.removeShape(),
                  child: Text('Delete'),
                ),
                const MyColorPicker(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
