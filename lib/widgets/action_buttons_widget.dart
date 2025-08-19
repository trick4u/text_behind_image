

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/image_segmentation_controller.dart';
import '../text_behind_image.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageSegmentationController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        
        const SizedBox(width: 16),
        FloatingActionButton(
          onPressed: controller.pickImage,
          child: const Icon(Icons.add_a_photo),
        ),
      ],
    );
  }
}
