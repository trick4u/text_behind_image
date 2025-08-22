import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class FontController extends GetxController {
  // List of 50 available Google Fonts
 final RxList<String> availableFonts = [
    'Montserrat',
    'Poppins',
    'Bebas Neue',
    'Inter',
    'Oswald',
    'Josefin Sans', // Proxy for Futura
    'Playfair Display',
    'Lora',
    'Crimson Pro',
    'Libre Baskerville',
    'Roboto Slab',
    'Arvo',
    'Bitter',
    'Lobster',
    'Dancing Script',
    'Great Vibes',
    'Amatic SC',
    'Space Mono',
    'Inconsolata',
    'Abril Fatface',
  ].obs;

  // Currently selected font for a specific text widget
  final RxMap<int, String> selectedFonts = <int, String>{}.obs;

  final RxMap<int, double> fontSizes = <int, double>{}.obs;
  final double defaultFontSize = 30.0;
  final double minFontSize = 8.0;
  final double maxFontSize = 72.0;

  // Default font
  final String defaultFont = 'Roboto';

  void setFontSize(int index, double fontSize) {
    fontSizes[index] = fontSize;
  }

  double getFontSize(int index) {
    return fontSizes[index] ?? defaultFontSize;
  }
  

  // Get TextStyle for a given font
 TextStyle getFontStyle(String fontName, {double fontSize = 30}) {
    switch (fontName) {
      case 'Montserrat':
        return GoogleFonts.montserrat(fontSize: fontSize, color: Colors.white);
      case 'Poppins':
        return GoogleFonts.poppins(fontSize: fontSize, color: Colors.white);
      case 'Bebas Neue':
        return GoogleFonts.bebasNeue(fontSize: fontSize, color: Colors.white);
      case 'Inter':
        return GoogleFonts.inter(fontSize: fontSize, color: Colors.white);
      case 'Oswald':
        return GoogleFonts.oswald(fontSize: fontSize, color: Colors.white);
      case 'Josefin Sans':
        return GoogleFonts.josefinSans(fontSize: fontSize, color: Colors.white);
      case 'Playfair Display':
        return GoogleFonts.playfairDisplay(fontSize: fontSize, color: Colors.white);
      case 'Lora':
        return GoogleFonts.lora(fontSize: fontSize, color: Colors.white);
      case 'Crimson Pro':
        return GoogleFonts.crimsonPro(fontSize: fontSize, color: Colors.white);
      case 'Libre Baskerville':
        return GoogleFonts.libreBaskerville(fontSize: fontSize, color: Colors.white);
      case 'Roboto Slab':
        return GoogleFonts.robotoSlab(fontSize: fontSize, color: Colors.white);
      case 'Arvo':
        return GoogleFonts.arvo(fontSize: fontSize, color: Colors.white);
      case 'Bitter':
        return GoogleFonts.bitter(fontSize: fontSize, color: Colors.white);
      case 'Lobster':
        return GoogleFonts.lobster(fontSize: fontSize, color: Colors.white);
      case 'Dancing Script':
        return GoogleFonts.dancingScript(fontSize: fontSize, color: Colors.white);
      case 'Great Vibes':
        return GoogleFonts.greatVibes(fontSize: fontSize, color: Colors.white);
      case 'Amatic SC':
        return GoogleFonts.amaticSc(fontSize: fontSize, color: Colors.white);
      case 'Space Mono':
        return GoogleFonts.spaceMono(fontSize: fontSize, color: Colors.white);
      case 'Inconsolata':
        return GoogleFonts.inconsolata(fontSize: fontSize, color: Colors.white);
      case 'Abril Fatface':
        return GoogleFonts.abrilFatface(fontSize: fontSize, color: Colors.white);
      default:
        return GoogleFonts.montserrat(fontSize: fontSize, color: Colors.white);
    }
  }

  // Set selected font for a specific text widget
  void setSelectedFont(int index, String fontName) {
    selectedFonts[index] = fontName;
  }

  // Get selected font for a specific text widget
  String getSelectedFont(int index) {
    return selectedFonts[index] ?? defaultFont;
  }
}
