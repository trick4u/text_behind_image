
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
  final Rx<TextStyleType> textStyle; // Add this

  TextData({
    required String initialText,
    required double initialX,
    required double initialY,
    String initialFont = 'Roboto',
    Color initialColor = Colors.white,
    double fontSize = 60.0,
    double initialOpacity = 1.0,

    TextStyleType initialTextStyle = TextStyleType.normal, // Add this
  })  : text = initialText.obs,
        xPos = initialX.obs,
        yPos = initialY.obs,
        font = initialFont.obs,
        color = initialColor.obs,
        fontSize = fontSize.obs,
        opacity = initialOpacity.obs,
        textStyle = initialTextStyle.obs; // Initialize textStyle
}