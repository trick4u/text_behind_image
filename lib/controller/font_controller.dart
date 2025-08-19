import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class FontController extends GetxController {
  // List of 50 available Google Fonts
  final RxList<String> availableFonts = [
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Poppins',
    'Raleway',
    'Merriweather',
    'Noto Sans',
    'Inter',

    'Ubuntu',
    'Playfair Display',
    'Bebas Neue',
    'Oswald',
    'Rubik',
    'Fira Sans',
    'Work Sans',
    'Quicksand',
    'Barlow',
    'Karla',
    'PT Sans',
    'Nunito',
    'Source Serif Pro',
    'Crimson Text',
    'Lora',
    'Bitter',
    'Arvo',
    'Libre Baskerville',
    'Noto Serif',
    'Domine',
    'Cabin',
    'Heebo',
    'Titillium Web',
    'Varela Round',
    'Mukta',
    'Hind',
    'IBM Plex Sans',
    'Overpass',
    'Dosis',
    'Archivo',
    'Manrope',
    'Space Mono',
    'Inconsolata',
    'Courier Prime',
    'Lobster',
    'Pacifico',
    'Dancing Script',
    'Amatic SC',
    'Shadows Into Light',
    'Caveat',
    'Indie Flower',
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
  TextStyle getFontStyle(String fontName, {double fontSize = 20}) {
    switch (fontName) {
      case 'Open Sans':
        return GoogleFonts.openSans(fontSize: fontSize, color: Colors.white);
      case 'Lato':
        return GoogleFonts.lato(fontSize: fontSize, color: Colors.white);
      case 'Montserrat':
        return GoogleFonts.montserrat(fontSize: fontSize, color: Colors.white);
      case 'Poppins':
        return GoogleFonts.poppins(fontSize: fontSize, color: Colors.white);
      case 'Raleway':
        return GoogleFonts.raleway(fontSize: fontSize, color: Colors.white);
      case 'Merriweather':
        return GoogleFonts.merriweather(
          fontSize: fontSize,
          color: Colors.white,
        );
      case 'Noto Sans':
        return GoogleFonts.notoSans(fontSize: fontSize, color: Colors.white);
      case 'Inter':
        return GoogleFonts.inter(fontSize: fontSize, color: Colors.white);

      case 'Ubuntu':
        return GoogleFonts.ubuntu(fontSize: fontSize, color: Colors.white);
      case 'Playfair Display':
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          color: Colors.white,
        );
      case 'Bebas Neue':
        return GoogleFonts.bebasNeue(fontSize: fontSize, color: Colors.white);
      case 'Oswald':
        return GoogleFonts.oswald(fontSize: fontSize, color: Colors.white);
      case 'Rubik':
        return GoogleFonts.rubik(fontSize: fontSize, color: Colors.white);
      case 'Fira Sans':
        return GoogleFonts.firaSans(fontSize: fontSize, color: Colors.white);
      case 'Work Sans':
        return GoogleFonts.workSans(fontSize: fontSize, color: Colors.white);
      case 'Quicksand':
        return GoogleFonts.quicksand(fontSize: fontSize, color: Colors.white);
      case 'Barlow':
        return GoogleFonts.barlow(fontSize: fontSize, color: Colors.white);
      case 'Karla':
        return GoogleFonts.karla(fontSize: fontSize, color: Colors.white);
      case 'PT Sans':
        return GoogleFonts.ptSans(fontSize: fontSize, color: Colors.white);
      case 'Nunito':
        return GoogleFonts.nunito(fontSize: fontSize, color: Colors.white);

      case 'Crimson Text':
        return GoogleFonts.crimsonText(fontSize: fontSize, color: Colors.white);
      case 'Lora':
        return GoogleFonts.lora(fontSize: fontSize, color: Colors.white);
      case 'Bitter':
        return GoogleFonts.bitter(fontSize: fontSize, color: Colors.white);
      case 'Arvo':
        return GoogleFonts.arvo(fontSize: fontSize, color: Colors.white);
      case 'Libre Baskerville':
        return GoogleFonts.libreBaskerville(
          fontSize: fontSize,
          color: Colors.white,
        );
      case 'Noto Serif':
        return GoogleFonts.notoSerif(fontSize: fontSize, color: Colors.white);
      case 'Domine':
        return GoogleFonts.domine(fontSize: fontSize, color: Colors.white);
      case 'Cabin':
        return GoogleFonts.cabin(fontSize: fontSize, color: Colors.white);
      case 'Heebo':
        return GoogleFonts.heebo(fontSize: fontSize, color: Colors.white);
      case 'Titillium Web':
        return GoogleFonts.titilliumWeb(
          fontSize: fontSize,
          color: Colors.white,
        );
      case 'Varela Round':
        return GoogleFonts.varelaRound(fontSize: fontSize, color: Colors.white);
      case 'Mukta':
        return GoogleFonts.mukta(fontSize: fontSize, color: Colors.white);
      case 'Hind':
        return GoogleFonts.hind(fontSize: fontSize, color: Colors.white);
      case 'IBM Plex Sans':
        return GoogleFonts.ibmPlexSans(fontSize: fontSize, color: Colors.white);
      case 'Overpass':
        return GoogleFonts.overpass(fontSize: fontSize, color: Colors.white);
      case 'Dosis':
        return GoogleFonts.dosis(fontSize: fontSize, color: Colors.white);
      case 'Archivo':
        return GoogleFonts.archivo(fontSize: fontSize, color: Colors.white);
      case 'Manrope':
        return GoogleFonts.manrope(fontSize: fontSize, color: Colors.white);
      case 'Space Mono':
        return GoogleFonts.spaceMono(fontSize: fontSize, color: Colors.white);
      case 'Inconsolata':
        return GoogleFonts.inconsolata(fontSize: fontSize, color: Colors.white);
      case 'Courier Prime':
        return GoogleFonts.courierPrime(
          fontSize: fontSize,
          color: Colors.white,
        );
      case 'Lobster':
        return GoogleFonts.lobster(fontSize: fontSize, color: Colors.white);
      case 'Pacifico':
        return GoogleFonts.pacifico(fontSize: fontSize, color: Colors.white);
      case 'Dancing Script':
        return GoogleFonts.dancingScript(
          fontSize: fontSize,
          color: Colors.white,
        );
      case 'Amatic SC':
        return GoogleFonts.amaticSc(fontSize: fontSize, color: Colors.white);
      case 'Shadows Into Light':
        return GoogleFonts.shadowsIntoLight(
          fontSize: fontSize,
          color: Colors.white,
        );
      case 'Caveat':
        return GoogleFonts.caveat(fontSize: fontSize, color: Colors.white);
      case 'Indie Flower':
        return GoogleFonts.indieFlower(fontSize: fontSize, color: Colors.white);
      case 'Roboto':
      default:
        return GoogleFonts.roboto(fontSize: fontSize, color: Colors.white);
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
