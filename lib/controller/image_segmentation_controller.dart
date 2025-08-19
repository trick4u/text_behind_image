import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_background_remover/image_background_remover.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/text_model.dart';

class SegmentationData {
  final Uint8List originalBytes;
  final Uint8List maskBytes;
  final int originalWidth;
  final int originalHeight;
  final int maskWidth;
  final int maskHeight;

  SegmentationData({
    required this.originalBytes,
    required this.maskBytes,
    required this.originalWidth,
    required this.originalHeight,
    required this.maskWidth,
    required this.maskHeight,
  });
}

// Result class for receiving data from isolate
class SegmentationResult {
  final Uint8List foregroundBytes;
  final Uint8List backgroundBytes;
  final int width;
  final int height;
  final String? error;

  SegmentationResult({
    required this.foregroundBytes,
    required this.backgroundBytes,
    required this.width,
    required this.height,
    this.error,
  });
}

class ImageSegmentationController extends GetxController {
  // Observable variables
  final Rx<ui.Image?> original = Rx<ui.Image?>(null);
  final Rx<ui.Image?> foreground = Rx<ui.Image?>(null);
  final Rx<ui.Image?> background = Rx<ui.Image?>(null);
  final RxDouble foregroundOpacity = 0.0.obs;
  final RxDouble backgroundOpacity = 0.0.obs;
  final RxDouble xPos = 100.0.obs;
  final RxDouble yPos = 100.0.obs;
  final RxString text = "Hello".obs;
  final RxBool isProcessing = false.obs;
  final RxBool isSaving = false.obs;
  final RxList<TextData> textWidgets = <TextData>[].obs;
  final RxBool isInitialized = false.obs;
  final RxDouble fontSize = 30.0.obs; // Added font size observable
  final RxInt selectedTextIndex = (-1).obs; // Add this line

  final GlobalKey _repaintBoundaryKey = GlobalKey();
  final GlobalKey _saveRepaintBoundaryKey =
      GlobalKey(); // New key for save widget

  GlobalKey get repaintBoundaryKey => _repaintBoundaryKey;
  GlobalKey get saveRepaintBoundaryKey => _saveRepaintBoundaryKey;

  // Private variables
  final picker = ImagePicker();
  Uint8List? _originalBytes;

  @override
  void onInit() {
    super.onInit();
    addTextWidget();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBackgroundRemover();
    });
  }

  void _initializeBackgroundRemover() async {
    // Run in background without blocking UI
    await Future.delayed(Duration(milliseconds: 100)); // Let UI settle
    await BackgroundRemover.instance.initializeOrt();
    isInitialized.value = true;
  }

  @override
  void onClose() {
    BackgroundRemover.instance.dispose();
    original.value?.dispose();
    foreground.value?.dispose();
    background.value?.dispose();
    super.onClose();
  }

  void addTextWidget() {
    textWidgets.add(
      TextData(
        initialText: "Hello",
        initialX: 100.0 + textWidgets.length * 20,
        initialY: 100.0 + textWidgets.length * 20,
      ),
    );
  }

  void removeTextWidget(int index) {
    if (index >= 0 && index < textWidgets.length) {
      textWidgets.removeAt(index);
    }
  }

  void updateText(int index, String newText) {
    if (index >= 0 && index < textWidgets.length) {
      textWidgets[index].text.value = newText;
    }
  }

  void updatePosition(int index, double dx, double dy) {
    if (index >= 0 && index < textWidgets.length) {
      textWidgets[index].xPos.value += dx;
      textWidgets[index].yPos.value += dy;
    }
  }

  void updateFontSize(double size) {
    fontSize.value = size.clamp(
      20.0,
      100.0,
    ); // Clamp font size between 10 and 40
  }

  Future<void> saveImage() async {
    if (original.value == null) {
      Get.snackbar('Error', 'No image to save');
      return;
    }

    try {
      isSaving.value = true;

      // Request storage permission
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          Get.snackbar(
            'Permission Denied',
            'Storage permission is required to save images',
          );
          return;
        }
      }

      // Capture the RepaintBoundary as an image
      final RenderRepaintBoundary boundary =
          _saveRepaintBoundaryKey.currentContext!.findRenderObject()
              as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();

        // Save to gallery
        final result = await ImageGallerySaverPlus.saveImage(
          pngBytes,
          quality: 100,
          name: "text_behind_image_${DateTime.now().millisecondsSinceEpoch}",
        );

        if (result['isSuccess'] == true) {
          Get.snackbar(
            'Success',
            'Image saved to gallery!',
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        } else {
          Get.snackbar('Error', 'Failed to save image');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save image: ${e.toString()}');
    } finally {
      isSaving.value = false;
    }
  }

  // Methods
  Future<void> pickImage() async {
    try {
      final x = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 1500,
        maxWidth: 1500,
        imageQuality: 80,
      );

      if (x == null) return;

      final bytes = await x.readAsBytes();
      final origImg = await decodeImageFromList(bytes);

      original.value = origImg;
      _originalBytes = bytes;
      foreground.value = null;
      background.value = null;
      foregroundOpacity.value = 0.0;
      backgroundOpacity.value = 0.0;
      segmentImage();
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> removeImage() async {
    original.value = null;
    _originalBytes = null;
    foreground.value = null;
    background.value = null;
    foregroundOpacity.value = 0.0;
    backgroundOpacity.value = 0.0;
  }

  Future<void> segmentImage() async {
    if (_originalBytes == null || original.value == null) return;

    try {
      isProcessing.value = true;

      final maskResult = await BackgroundRemover.instance.removeBg(
        _originalBytes!,
        smoothMask: true,
        enhanceEdges: true,
      );

      // Convert images to bytes for isolate transfer
      final originalByteData = await original.value!.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      final maskByteData = await maskResult.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );

      if (originalByteData == null || maskByteData == null) {
        throw Exception('Failed to convert images to bytes');
      }

      // Run segmentation in isolate
      final result = await compute(
        _segmentImageInIsolate,
        SegmentationData(
          originalBytes: originalByteData.buffer.asUint8List(),
          maskBytes: maskByteData.buffer.asUint8List(),
          originalWidth: original.value!.width,
          originalHeight: original.value!.height,
          maskWidth: maskResult.width,
          maskHeight: maskResult.height,
        ),
      );

      if (result.error != null) {
        throw Exception(result.error);
      }

      final fgImage = await _bytesToImage(
        result.foregroundBytes,
        result.width,
        result.height,
      );
      final bgImage = await _bytesToImage(
        result.backgroundBytes,
        result.width,
        result.height,
      );

      foreground.value = fgImage;
      background.value = bgImage;
      foregroundOpacity.value = 1.0;
      backgroundOpacity.value = 1.0;
    } catch (e) {
      Get.snackbar('Error', 'Failed to segment image: ${e.toString()}');
    } finally {
      isProcessing.value = false;
    }
  }

  static Future<SegmentationResult> _segmentImageInIsolate(
    SegmentationData data,
  ) async {
    try {
      final rgbaBytes = data.originalBytes;
      final width = data.originalWidth;
      final height = data.originalHeight;

      final mask = _getMaskFromBytesInIsolate(
        data.maskBytes,
        data.maskWidth,
        data.maskHeight,
      );
      final fgBytes = Uint8List(4 * width * height);
      final bgBytes = Uint8List(4 * width * height);

      for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
          final i = y * width + x;
          final maskValue = mask[y][x];
          final isForeground = maskValue > 0.5;

          if (isForeground) {
            fgBytes[i * 4] = rgbaBytes[i * 4];
            fgBytes[i * 4 + 1] = rgbaBytes[i * 4 + 1];
            fgBytes[i * 4 + 2] = rgbaBytes[i * 4 + 2];
            fgBytes[i * 4 + 3] = 255;
            bgBytes[i * 4] = 0;
            bgBytes[i * 4 + 1] = 0;
            bgBytes[i * 4 + 2] = 0;
            bgBytes[i * 4 + 3] = 0;
          } else {
            fgBytes[i * 4] = 0;
            fgBytes[i * 4 + 1] = 0;
            fgBytes[i * 4 + 2] = 0;
            fgBytes[i * 4 + 3] = 0;
            bgBytes[i * 4] = rgbaBytes[i * 4];
            bgBytes[i * 4 + 1] = rgbaBytes[i * 4 + 1];
            bgBytes[i * 4 + 2] = rgbaBytes[i * 4 + 2];
            bgBytes[i * 4 + 3] = 255;
          }
        }
      }

      return SegmentationResult(
        foregroundBytes: fgBytes,
        backgroundBytes: bgBytes,
        width: width,
        height: height,
      );
    } catch (e) {
      return SegmentationResult(
        foregroundBytes: Uint8List(0),
        backgroundBytes: Uint8List(0),
        width: 0,
        height: 0,
        error: e.toString(),
      );
    }
  }

  void updateForegroundOpacity(double opacity) {
    foregroundOpacity.value = opacity;
  }

  void updateBackgroundOpacity(double opacity) {
    backgroundOpacity.value = opacity;
  }

  static List<List<double>> _getMaskFromBytesInIsolate(
    Uint8List maskBytes,
    int width,
    int height,
  ) {
    final mask = List.generate(height, (_) => List.filled(width, 0.0));

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final i = (y * width + x) * 4;
        mask[y][x] = maskBytes[i + 3] / 255.0;
      }
    }
    return mask;
  }

  Future<ui.Image> _bytesToImage(Uint8List bytes, int width, int height) async {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      bytes,
      width,
      height,
      ui.PixelFormat.rgba8888,
      (ui.Image img) => completer.complete(img),
    );
    return completer.future;
  }
}
