import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:fourier_series/domain/controllers/color_controller.dart';
import 'package:fourier_series/domain/controllers/drawing_controller.dart';
import 'package:get/get.dart';

class MyColorPicker extends StatelessWidget {
  const MyColorPicker();

  Future<bool> colorPickerDialog(BuildContext context) async {
    return ColorPicker(
      // Sets the initialColor
      color: ColorController.i.selectedShapeColor,

      // Update the color
      onColorChanged: (Color color) =>
          ColorController.i.selectedShapeColor = color,
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Color Picker',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(),
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,

      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.wheel: true,
        ColorPickerType.custom: true,
      },
      opacitySubheading: Text('Opacity'),
      enableOpacity: true,
      recentColorsSubheading: Text(
        'Recent Colors',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      recentColors: ColorController.i.recentColors,
      borderColor: const Color(0xFF000000),
      showRecentColors: true,
      customColorSwatchesAndNames: ColorController.i.colorsNameMap,
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cc = Get.put(ColorController());
    //TODO: make optional to show the color HEX code
    //Only update when: 1.A new shape is added. 2. A shape color is changed.
    return GetBuilder<DrawingController>(
      builder: (_) {
        return !cc.hasSelectedShape
            ? SizedBox.shrink()
            : ColorIndicator(
                width: 40,
                height: 40,
                borderRadius: 20,
                color: cc.selectedShapeColor,
                onSelectFocus: false,
                borderColor: Colors.black,
                hasBorder: cc.withBorder(),
                onSelect: () async {
                  // Stores the current color on the previous color var, before we open the dialog.
                  cc.saveCurrentColor();

                  // Wait for the picker to close, if dialog was dismissed,
                  // then restore the color we had before it was opened.
                  if (!(await colorPickerDialog(context))) {
                    cc.restoreColor();
                  }
                },
              );
      },
    );
  }
}
