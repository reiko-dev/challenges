import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/position_ellipsis_form_controller.dart';
import 'package:get/get.dart';

class EllipsisPositionPanel extends StatelessWidget {
  const EllipsisPositionPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pef = Get.put(PositionEllipsisFormController());

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
            child: Form(
              key: pef.key,
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
                    child: TextFormField(
                      controller: pef.controllerDx,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      textAlign: TextAlign.center,
                      maxLength: 4,
                      style: TextStyle(
                        color: const Color(0xFF2196F3),
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
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
                    child: TextField(
                      controller: pef.controllerDy,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      maxLength: 4,
                      style: TextStyle(
                        color: const Color(0xFF2196F3),
                        fontWeight: FontWeight.bold,
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(signed: true),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
