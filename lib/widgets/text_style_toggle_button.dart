import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/image_segmentation_controller.dart';
import '../models/text_model.dart';

class TextStyleToggleButton extends StatelessWidget {
  const TextStyleToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageSegmentationController>();

    return Obx(() {
      if (controller.selectedTextIndex.value < 0 ||
          controller.selectedTextIndex.value >= controller.textWidgets.length) {
        return const SizedBox.shrink();
      }

      final currentStyle = controller
          .textWidgets[controller.selectedTextIndex.value]
          .textStyle
          .value;

      return ElevatedButton(
        onPressed: () {
          TextStyleType nextStyle;
          switch (currentStyle) {
            case TextStyleType.normal:
              nextStyle = TextStyleType.bold;
              break;
            case TextStyleType.bold:
              nextStyle = TextStyleType.italic;
              break;
            case TextStyleType.italic:
              nextStyle = TextStyleType.normal;
              break;
          }
          controller.updateTextStyle(nextStyle);
        },
        child: Icon(_getStyleIcon(currentStyle),color: Colors.black,),
      );
    });
  }

  IconData _getStyleIcon(TextStyleType style) {
    switch (style) {
      case TextStyleType.normal:
        return Icons.format_clear;
      case TextStyleType.bold:
        return Icons.format_bold;
      case TextStyleType.italic:
        return Icons.format_italic;
    }
  }
}
