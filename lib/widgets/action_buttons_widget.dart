import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/image_segmentation_controller.dart';
import '../text_behind_image.dart';
import 'text_style_toggle_button.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageSegmentationController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
    
        Obx(
          () => controller.original.value != null
              ? FloatingActionButton(
                  heroTag: 'saveImage',
                  onPressed:
                      controller.isSaving.value ||
                          controller.original.value == null
                      ? null
                      : controller.saveImage,
                  tooltip: 'Save Image',
                  child: controller.isSaving.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.save),
                )
              : SizedBox.shrink(),
        ),
        const SizedBox(width: 16),

        Obx(
          () => controller.original.value != null
              ? FloatingActionButton(
                  heroTag: 'shareImage',
                  onPressed: controller.isSharing.value ||
                          controller.original.value == null
                      ? null
                      : controller.shareImage,
                  tooltip: 'Share Image',
                  child: controller.isSharing.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.share),
                )
              : SizedBox.shrink(),
        ),
           const SizedBox(width: 16),
        FloatingActionButton(
          heroTag: 'pickImage',
          onPressed: controller.showImageSourceDialog,
          tooltip: 'Pick Image',
          child: const Icon(Icons.add_a_photo),
        ),
      ],
    );
  }
}