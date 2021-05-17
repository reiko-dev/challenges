import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:get/get.dart';

class DeleteShape extends StatelessWidget {
  const DeleteShape();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DrawingController>(
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                if (_.shapeIndexToDelete != null)
                  _.removeShape(_.shapeIndexToDelete!);
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
                onChanged: (val) => _.shapeIndexToDelete = val,
                value: _.shapeIndexToDelete,
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
      },
    );
  }
}
