
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum TextStyleType { normal, bold, italic }

class TextData {
  final RxString text;
  final RxDouble xPos;
  final RxDouble yPos;
  final RxString font;
  final Rx<Color> color;
  final RxDouble fontSize;
  final RxDouble opacity;
  final Rx<TextStyleType> textStyle;

  TextData({
    required String initialText,
    required double initialX,
    required double initialY,
    String initialFont = 'Roboto',
    Color initialColor = Colors.white, // Keep white as default
    double fontSize = 80.0, // Increased from 60.0
    double initialOpacity = 1.0,
    TextStyleType initialTextStyle = TextStyleType.bold, // Changed to bold by default
  })  : text = initialText.obs,
        xPos = initialX.obs,
        yPos = initialY.obs,
        font = initialFont.obs,
        color = initialColor.obs,
        fontSize = fontSize.obs,
        opacity = initialOpacity.obs,
        textStyle = initialTextStyle.obs;
}