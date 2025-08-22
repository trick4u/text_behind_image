// Controller
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/image_segmentation_controller.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/movable_text_widget.dart';
import 'widgets/opacity_controls.dart';

// Main Widget
class OriginalImageOnly extends StatelessWidget {
  const OriginalImageOnly({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImageSegmentationController());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png', 
              height: 40,
            ),
            Text(
              "Text fusion..",
              style: GoogleFonts.eduAuVicWaNtHand(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () => controller.textWidgets.length < 3
                ? IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      controller.addTextWidget();
                    },
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => controller.original.value != null
                ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      controller.removeImage();
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 0.85,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: ImageDisplayWidget(),
              ),
            ),
            Obx(
              () =>
                  controller.foreground.value != null &&
                      controller.background.value != null
                  ? OpacityControlsWidget()
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      floatingActionButton: ActionButtonsWidget(),
    );
  }
}

class ImageDisplayWidget extends StatelessWidget {
  const ImageDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageSegmentationController>();

    return Obx(() {
      if (controller.original.value == null) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("Pick an image "),
          ],
        );
      }
    
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Card(
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              7,
            ), // Slightly smaller to account for border
            child: RepaintBoundary(
              key: controller.saveRepaintBoundaryKey,
              child: Stack(
                children: [
                  if (controller.background.value != null)
                    Positioned.fill(
                      child: Opacity(
                        opacity: controller.backgroundOpacity.value,
                        child: CustomPaint(
                          painter: ImagePainter(controller.background.value!),
                        ),
                      ),
                    ),
    
                  // Layer 2: Text widgets (middle layer - behind foreground)
                  ...controller.textWidgets.asMap().entries.map((entry) {
                    final index = entry.key;
                    return MovableTextWidget(index: index);
                  }).toList(),
    
                  // Layer 3: Foreground image (top layer - in front of text)
                  if (controller.foreground.value != null)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: Opacity(
                          opacity: controller.foregroundOpacity.value,
                          child: CustomPaint(
                            painter: ImagePainter(
                              controller.foreground.value!,
                            ),
                          ),
                        ),
                      ),
                    ),
    
                  // Layer 4: Processing indicator (topmost layer)
                  if (controller.isProcessing.value)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black26,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(height: 16),
                              Text(
                                'Processing...',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;
  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Convert image dimensions to double for calculations
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    // Calculate aspect ratios
    final imageAspect = imageWidth / imageHeight;
    final canvasAspect = size.width / size.height;

    Rect src, dst;

    if (imageAspect > canvasAspect) {
      // Image is wider than canvas - crop left/right
      final scale = size.height / imageHeight;
      final scaledWidth = imageWidth * scale;
      final widthDiff = scaledWidth - size.width;
      src = Rect.fromLTWH(
        widthDiff / 2 / scale,
        0,
        imageWidth - widthDiff / scale,
        imageHeight,
      );
      dst = Rect.fromLTWH(0, 0, size.width, size.height);
    } else {
      // Image is taller than canvas - crop top/bottom
      final scale = size.width / imageWidth;
      final scaledHeight = imageHeight * scale;
      final heightDiff = scaledHeight - size.height;
      src = Rect.fromLTWH(
        0,
        heightDiff / 2 / scale,
        imageWidth,
        imageHeight - heightDiff / scale,
      );
      dst = Rect.fromLTWH(0, 0, size.width, size.height);
    }

    canvas.drawImageRect(image, src, dst, paint);
  }

  @override
  bool shouldRepaint(covariant ImagePainter oldDelegate) =>
      oldDelegate.image != image;
}
