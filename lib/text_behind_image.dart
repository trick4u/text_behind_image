// Controller
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
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

    var initialColors = [
      Colors.blue,
      Colors.deepPurple,
      Colors.deepPurpleAccent,
      Colors.blueAccent,
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Stack(
        children: [
        
          Column(
            children: [
              // Header Container (replacing AppBar)
              SizedBox(
                height: 56.0, // Standard AppBar height
              ),
              Container(
                height: 56.0, // Standard AppBar height
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  children: [
                    Image.asset('assets/logo.png', height: 40),
                    const SizedBox(width: 8),
                    Text(
                      "Text fusion..",
                      style: GoogleFonts.eduAuVicWaNtHand(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => controller.textWidgets.length < 3
                          ? IconButton(
                              icon: Icon(
                                Icons.add,
                                color: controller.original.value != null
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                controller.addTextWidget();
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => controller.original.value != null
                          ? IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: controller.original.value != null
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                controller.removeImage();
                              },
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              // Existing content (ImageDisplayWidget and OpacityControlsWidget)
              Expanded(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.85,
                      child: ImageDisplayWidget(),
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
            ],
          ),
        ],
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
            Text("Pick an image", style: TextStyle(color: Colors.grey)),
          ],
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Card(
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: RepaintBoundary(
              key: controller.saveRepaintBoundaryKey,
              child: Stack(
                children: [
                  // Layer 1: Background image
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
                            painter: ImagePainter(controller.foreground.value!),
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

class CropImageScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final CropController cropController;

  const CropImageScreen({
    super.key,
    required this.imageBytes,
    required this.cropController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Crop Image',
          style: GoogleFonts.eduAuVicWaNtHand(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final croppedBitmap = await cropController.croppedBitmap();
              final byteData = await croppedBitmap.toByteData(
                format: ui.ImageByteFormat.png,
              );
              final croppedBytes = byteData!.buffer.asUint8List();
              Get.back(result: croppedBytes);
            },
          ),
        ],
      ),
      body: Center(
        child: CropImage(
          controller: cropController,
          image: Image.memory(imageBytes),
          gridColor: Colors.white,
          gridInnerColor: Colors.white,
          gridCornerColor: Colors.white,
          gridCornerSize: 25,
          gridThinWidth: 2,
          gridThickWidth: 5,
          scrimColor: Colors.grey.withOpacity(0.5),
          alwaysShowThirdLines: true,
          minimumImageSize: 100,
          maximumImageSize: 1500,
        ),
      ),
    );
  }
}
