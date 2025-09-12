// Controller
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'dart:math' as math;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/image_segmentation_controller.dart';
import 'widgets/action_buttons_widget.dart';
import 'widgets/movable_text_widget.dart';
import 'widgets/opacity_controls.dart';
import 'widgets/pulsating_icon.dart';

// Main Widget
class OriginalImageOnly extends StatelessWidget {
  const OriginalImageOnly({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImageSegmentationController());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 40),
            const SizedBox(width: 8),
            Text(
              "Text Fusion",
              style: GoogleFonts.eduAuVicWaNtHand(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          Obx(
            () => controller.textWidgets.length < 3
                ? IconButton(
                    icon: Icon(Icons.add, color: Colors.black),
                    onPressed: () {
                      controller.addTextWidget();
                    },
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => controller.original.value != null
                ? IconButton(
                    icon: Icon(Icons.delete, color: Colors.black),
                    onPressed: () {
                      controller.removeImage();
                    },
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),

      body: Column(
        children: [
          Column(
            children: [
              AspectRatio(aspectRatio: 0.85, child: ImageDisplayWidget()),
              Obx(
                () =>
                    controller.foreground.value != null &&
                        controller.background.value != null
                    ? FlipControlsWidget()
                    : const SizedBox.shrink(),
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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          child: Card(
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade50,
                      Colors.purple.shade50,
                      Colors.pink.shade50,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated container with pulsing effect
                    const PulsingIcon(),
                    const SizedBox(height: 24),
                    Text(
                      "Add Your Image",
                      style: GoogleFonts.eduAuVicWaNtHand(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Tap the camera button to get started",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Decorative elements
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildFeatureChip("Text Behind", Icons.text_fields),
                        const SizedBox(width: 12),
                        _buildFeatureChip("Filters", Icons.tune),
                        const SizedBox(width: 12),
                        _buildFeatureChip("Effects", Icons.auto_fix_high),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Your existing code for when image is present
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Card(
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: RepaintBoundary(
              key: controller.saveRepaintBoundaryKey,
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix(
                  _createEnhancedColorMatrix(
                    brightness: controller.brightness.value,
                    contrast: controller.contrast.value,
                    saturation: controller.saturation.value,
                    hueShift: controller.hueShift.value,
                    isSepia: controller.isSepia.value,
                    isGrayscale: controller.isGrayscale.value,
                  ),
                ),
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
        ),
      );
    });
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.blue.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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

List<double> _createEnhancedColorMatrix({
  required double brightness,
  required double contrast,
  required double saturation,
  required double hueShift,
  required bool isSepia,
  required bool isGrayscale,
}) {
  // Base identity matrix
  var matrix = [
    1.0, 0.0, 0.0, 0.0, 0.0, // Red
    0.0, 1.0, 0.0, 0.0, 0.0, // Green
    0.0, 0.0, 1.0, 0.0, 0.0, // Blue
    0.0, 0.0, 0.0, 1.0, 0.0, // Alpha
  ];

  // Apply contrast
  if (contrast != 1.0) {
    matrix = _multiplyColorMatrix(matrix, [
      contrast,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      contrast,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      contrast,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]);
  }

  // Apply brightness
  if (brightness != 0.0) {
    final b = brightness / 100.0 * 255.0;
    matrix = _multiplyColorMatrix(matrix, [
      1.0,
      0.0,
      0.0,
      0.0,
      b,
      0.0,
      1.0,
      0.0,
      0.0,
      b,
      0.0,
      0.0,
      1.0,
      0.0,
      b,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]);
  }

  // Apply saturation
  if (saturation != 1.0) {
    final s = saturation;
    final sr = (1.0 - s) * 0.213;
    final sg = (1.0 - s) * 0.715;
    final sb = (1.0 - s) * 0.072;

    matrix = _multiplyColorMatrix(matrix, [
      sr + s,
      sg,
      sb,
      0.0,
      0.0,
      sr,
      sg + s,
      sb,
      0.0,
      0.0,
      sr,
      sg,
      sb + s,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]);
  }

  // Apply hue shift
  if (hueShift != 0.0) {
    final hue = hueShift * math.pi / 180.0;
    final cosHue = math.cos(hue);
    final sinHue = math.sin(hue);

    matrix = _multiplyColorMatrix(matrix, [
      0.213 + cosHue * 0.787 - sinHue * 0.213,
      0.715 - cosHue * 0.715 - sinHue * 0.715,
      0.072 - cosHue * 0.072 + sinHue * 0.928,
      0.0,
      0.0,
      0.213 - cosHue * 0.213 + sinHue * 0.143,
      0.715 + cosHue * 0.285 + sinHue * 0.140,
      0.072 - cosHue * 0.072 - sinHue * 0.283,
      0.0,
      0.0,
      0.213 - cosHue * 0.213 - sinHue * 0.787,
      0.715 - cosHue * 0.715 + sinHue * 0.715,
      0.072 + cosHue * 0.928 + sinHue * 0.072,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]);
  }

  // Apply grayscale
  if (isGrayscale) {
    matrix = _multiplyColorMatrix(matrix, [
      0.299,
      0.587,
      0.114,
      0.0,
      0.0,
      0.299,
      0.587,
      0.114,
      0.0,
      0.0,
      0.299,
      0.587,
      0.114,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]);
  }

  // Apply sepia
  if (isSepia) {
    matrix = _multiplyColorMatrix(matrix, [
      0.393,
      0.769,
      0.189,
      0.0,
      0.0,
      0.349,
      0.686,
      0.168,
      0.0,
      0.0,
      0.272,
      0.534,
      0.131,
      0.0,
      0.0,
      0.0,
      0.0,
      0.0,
      1.0,
      0.0,
    ]);
  }

  return matrix;
}

// Helper function to multiply two 4x5 color matrices
List<double> _multiplyColorMatrix(List<double> a, List<double> b) {
  final result = List<double>.filled(20, 0.0);

  for (int row = 0; row < 4; row++) {
    for (int col = 0; col < 5; col++) {
      double sum = 0.0;
      for (int k = 0; k < 4; k++) {
        sum += a[row * 5 + k] * b[k * 5 + col];
      }
      if (col == 4) {
        sum += a[row * 5 + 4] + b[row * 5 + 4];
      }
      result[row * 5 + col] = sum;
    }
  }

  return result;
}
