import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/image_segmentation_controller.dart';
import '../controller/font_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/image_segmentation_controller.dart';
import '../controller/font_controller.dart';
import '../models/text_model.dart';

class MovableTextWidget extends StatelessWidget {
  final int index;
  final bool hideControls;

  const MovableTextWidget({
    super.key,
    required this.index,
    this.hideControls = false,
  });

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FontController());
    final controller = Get.find<ImageSegmentationController>();
    final fontController = Get.find<FontController>();

    return Obx(() {
      if (index >= controller.textWidgets.length) {
        return const SizedBox.shrink();
      }

      final textData = controller.textWidgets[index];

      return Positioned(
        left: textData.xPos.value,
        top: textData.yPos.value,
        child: GestureDetector(
          onPanUpdate: hideControls
              ? null
              : (details) {
                  controller.updatePosition(
                    index,
                    details.delta.dx,
                    details.delta.dy,
                  );
                },
          onDoubleTap: hideControls
              ? null
              : () {
                  controller.selectedTextIndex.value = index;
                },
          onTap: hideControls
              ? null
              : () {
                  controller.selectedTextIndex.value = index;
                },
          onLongPress: hideControls
              ? null
              : () {
                  controller.removeTextWidget(index);
                },
          child: Container(
            child
                : _buildTextWithControls(
                    textData,
                    controller,
                    fontController,
                    context,
                  ),
          ),
        ),
      );
    });
  }

 Widget _buildTextOnly(
  TextData textData,
  ImageSegmentationController controller,
  FontController fontController,
) {
  return Opacity(
    opacity: textData.opacity.value,
    child: Text(
      textData.text.value,
      style: fontController
          .getFontStyle(textData.font.value)
          .copyWith(
            color: textData.color.value,
            fontSize: textData.fontSize.value,
            fontWeight: _getTextWeight(textData.textStyle.value),
            fontStyle: _getTextStyle(textData.textStyle.value),
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.9),
                offset: const Offset(1.0, 1.0),
              ),
              Shadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.7),
                offset: const Offset(2.0, 2.0),
              ),
              Shadow(
                blurRadius: 8.0,
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(3.0, 3.0),
              ),
            ],
          ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildTextWithControls(
  TextData textData,
  ImageSegmentationController controller,
  FontController fontController,
  BuildContext context,
) {
  return Container(
    constraints: BoxConstraints(
      maxWidth: MediaQuery.of(context).size.width * 0.9,
    ),
    child: Opacity(
      opacity: textData.opacity.value,
      child: TextField(
        showCursor: false,
        controller: TextEditingController(text: textData.text.value)
          ..selection = TextSelection.collapsed(
            offset: textData.text.value.length,
          ),
        onChanged: (newText) => controller.updateText(index, newText),
        style: fontController
            .getFontStyle(textData.font.value)
            .copyWith(
              color: textData.color.value,
              fontSize: textData.fontSize.value,
              fontWeight: _getTextWeight(textData.textStyle.value),
              fontStyle: _getTextStyle(textData.textStyle.value),
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.black.withOpacity(0.9),
                  offset: const Offset(1.0, 1.0),
                ),
                Shadow(
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(0.7),
                  offset: const Offset(2.0, 2.0),
                ),
                Shadow(
                  blurRadius: 8.0,
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(3.0, 3.0),
                ),
              ],
            ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}


FontWeight _getTextWeight(TextStyleType style) {
  switch (style) {
    case TextStyleType.bold:
      return FontWeight.bold;
    case TextStyleType.normal:
    case TextStyleType.italic:
      return FontWeight.normal;
  }
}

FontStyle _getTextStyle(TextStyleType style) {
  switch (style) {
    case TextStyleType.italic:
      return FontStyle.italic;
    case TextStyleType.normal:
    case TextStyleType.bold:
      return FontStyle.normal;
  }
}
}