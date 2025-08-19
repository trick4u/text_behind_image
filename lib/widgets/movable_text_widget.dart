import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/image_segmentation_controller.dart';
import '../controller/font_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/image_segmentation_controller.dart';
import '../controller/font_controller.dart';

class MovableTextWidget extends StatelessWidget {
  final int index;
  const MovableTextWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FontController());
    final controller = Get.find<ImageSegmentationController>();
    final fontController = Get.find<FontController>();

    return Obx(() {
      // Ensure index is valid
      if (index >= controller.textWidgets.length) {
        return const SizedBox.shrink();
      }

      final textData = controller.textWidgets[index];

      return Positioned(
        left: textData.xPos.value,
        top: textData.yPos.value,
        child: GestureDetector(
          onPanUpdate: (details) {
            controller.updatePosition(index, details.delta.dx, details.delta.dy);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            // Add a subtle background to make text more visible behind the image
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Delete button with better visibility
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () => controller.removeTextWidget(index),
                        constraints: const BoxConstraints(
                          minWidth: 24,
                          minHeight: 24,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Text input with better contrast for "behind image" effect
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                      ),
                      child: TextField(
                        controller: TextEditingController(text: textData.text.value)
                          ..selection = TextSelection.collapsed(
                              offset: textData.text.value.length),
                        onChanged: (newText) => controller.updateText(index, newText),
                        style: fontController.getFontStyle(textData.font.value).copyWith(
                          color: textData.color.value,
                          fontSize: controller.fontSize.value,
                          fontWeight: FontWeight.bold,
                          // Enhanced shadows for better visibility behind foreground
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
                        maxLines: null, // Allow multi-line text
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}