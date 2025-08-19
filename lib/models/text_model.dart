

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextData {
  final RxString text;
  final RxDouble xPos;
  final RxDouble yPos;
  final RxString font;
  final Rx<Color> color; // Add this
  TextData({
    required String initialText,
    required double initialX,
    required double initialY,
    String initialFont = 'Roboto',
    Color initialColor = Colors.white, // Add default color
  })  : text = initialText.obs,
        xPos = initialX.obs,
        yPos = initialY.obs,
        font = initialFont.obs,
        color = initialColor.obs; // Initialize color
}