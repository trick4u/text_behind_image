

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/image_segmentation_controller.dart';

class PulsingIcon extends StatelessWidget {
  const PulsingIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageSegmentationController>();
    
    return Obx(() => Transform.scale(
      scale: controller.pulseScale.value,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          size: 48,
          color: Colors.blue.shade600,
        ),
      ),
    ));
  }
}