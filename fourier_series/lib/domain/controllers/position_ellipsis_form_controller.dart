import 'package:flutter/cupertino.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:get/get.dart';

class PositionEllipsisFormController extends GetxController {
  static PositionEllipsisFormController get i => Get.find();
  final key = GlobalKey<FormState>();

  var controllerDx = TextEditingController();
  var controllerDy = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final dc = DrawingController.i;
    controllerDx.text = dc.ellipsisCenter.dx.truncate().toString();
    controllerDy.text = dc.ellipsisCenter.dy.truncate().toString();

    controllerDx.addListener(() {
      final dx = double.tryParse(controllerDx.text);
      if (dx == null) {
        print(
            'Error: ellipsisCenter.dx value ${controllerDx.text} is not valid.');
        return;
      }
      dc.ellipsisCenter = Offset(dx, dc.ellipsisCenter.dy);
    });

    controllerDy.addListener(() {
      final dy = double.tryParse(controllerDy.text);
      if (dy == null) {
        print(
            'Error: ellipsisCenter.dy value ${controllerDy.text} is not valid.');

        return;
      }

      dc.ellipsisCenter = Offset(dc.ellipsisCenter.dx, dy);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controllerDx.dispose();
    controllerDy.dispose();
  }

  void reset() {
    key.currentState!.reset();
    controllerDx.text = '';
    controllerDy.text = '';
  }
}
