import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../controller/font_controller.dart';
import '../controller/image_segmentation_controller.dart';
import 'text_style_toggle_button.dart';

class FlipControlsWidget extends StatelessWidget {
  const FlipControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageSegmentationController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      
      child: FlipCard(
        key: controller.flipCardKey,
        direction: FlipDirection.HORIZONTAL,
        front: OpacityControlsWidget(),
        back: ImageAdjustmentControls(),
      ),
    );
  }
}

class ImageAdjustmentControls extends StatelessWidget {
  const ImageAdjustmentControls({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageSegmentationController>();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with flip button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.tune, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Image Adjustments',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => controller.flipCard(),
                icon: Icon(Icons.flip_to_front, size: 20, color: Colors.grey[600]),
                tooltip: 'Switch to Text Controls',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Sliders row 1
          Row(
            children: [
              // Brightness
              Expanded(
                child: Obx(() => _buildCompactSlider(
                  icon: Icons.brightness_6,
                  label: 'Brightness',
                  value: controller.brightness.value,
                  onChanged: controller.updateBrightness,
                  min: -100.0,
                  max: 100.0,
                  divisions: 40,
                  color: Colors.amber,
                  displayValue: '${controller.brightness.value.round()}',
                )),
              ),
              const SizedBox(width: 12),
              // Contrast
              Expanded(
                child: Obx(() => _buildCompactSlider(
                  icon: Icons.contrast,
                  label: 'Contrast',
                  value: controller.contrast.value,
                  onChanged: controller.updateContrast,
                  min: 0.5,
                  max: 2.0,
                  divisions: 30,
                  color: Colors.purple,
                  displayValue: controller.contrast.value.toStringAsFixed(1),
                )),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Sliders row 2
          Row(
            children: [
              // Saturation
              Expanded(
                child: Obx(() => _buildCompactSlider(
                  icon: Icons.palette,
                  label: 'Saturation',
                  value: controller.saturation.value,
                  onChanged: controller.updateSaturation,
                  min: 0.0,
                  max: 2.0,
                  divisions: 40,
                  color: Colors.pink,
                  displayValue: controller.saturation.value.toStringAsFixed(1),
                )),
              ),
              const SizedBox(width: 12),
              // Hue Shift
              Expanded(
                child: Obx(() => _buildCompactSlider(
                  icon: Icons.color_lens,
                  label: 'Hue',
                  value: controller.hueShift.value,
                  onChanged: controller.updateHueShift,
                  min: -180.0,
                  max: 180.0,
                  divisions: 72,
                  color: Colors.cyan,
                  displayValue: '${controller.hueShift.value.round()}°',
                )),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Filter toggles and reset
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Sepia toggle
              Obx(() => _buildToggleButton(
                label: 'Sepia',
                icon: Icons.filter_vintage,
                isActive: controller.isSepia.value,
                onTap: controller.toggleSepia,
                activeColor: Colors.brown,
              )),
              
              // Grayscale toggle
              Obx(() => _buildToggleButton(
                label: 'B&W',
                icon: Icons.filter_b_and_w,
                isActive: controller.isGrayscale.value,
                onTap: controller.toggleGrayscale,
                activeColor: Colors.grey,
              )),
              
              // Reset button
              _buildToggleButton(
                label: 'Reset',
                icon: Icons.refresh,
                isActive: false,
                onTap: controller.resetImageAdjustments,
                activeColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSlider({
    required IconData icon,
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required double min,
    required double max,
    required int divisions,
    required Color color,
    required String displayValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '$label: $displayValue',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: color,
            inactiveColor: color.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor.withOpacity(0.2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? activeColor : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? activeColor : Colors.grey[600],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isActive ? activeColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OpacityControlsWidget extends StatelessWidget {
  const OpacityControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageSegmentationController>();
    final fontController = Get.find<FontController>();
    final Rx<Color> selectedColor = Colors.white.obs;

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with flip button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.text_fields, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Text Controls',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => controller.flipCard(),
                icon: Icon(Icons.flip_to_back, size: 20, color: Colors.grey[600]),
                tooltip: 'Switch to Image Adjustments',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Font Size and Opacity sliders
          Row(
            children: [
              // Font Size
              Expanded(
                child: Obx(() => _buildCompactSlider(
                  icon: Icons.format_size,
                  label: 'Size',
                  value: controller.selectedTextIndex.value >= 0 &&
                          controller.selectedTextIndex.value < controller.textWidgets.length
                      ? controller.textWidgets[controller.selectedTextIndex.value].fontSize.value
                      : 30.0,
                  onChanged: controller.selectedTextIndex.value >= 0 ? controller.updateFontSize : null,
                  min: 10.0,
                  max: 200.0,
                  divisions: 20,
                  color: Colors.blue,
                  displayValue: controller.selectedTextIndex.value >= 0 &&
                          controller.selectedTextIndex.value < controller.textWidgets.length
                      ? '${controller.textWidgets[controller.selectedTextIndex.value].fontSize.value.round()}'
                      : '30',
                )),
              ),
              const SizedBox(width: 12),
              // Text Opacity
              Expanded(
                child: Obx(() => _buildCompactSlider(
                  icon: Icons.opacity,
                  label: 'Opacity',
                  value: controller.selectedTextIndex.value >= 0 &&
                          controller.selectedTextIndex.value < controller.textWidgets.length
                      ? controller.textWidgets[controller.selectedTextIndex.value].opacity.value
                      : 1.0,
                  onChanged: controller.selectedTextIndex.value >= 0 
                      ? (value) => controller.updateTextOpacity(value) 
                      : null,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  color: Colors.green,
                  displayValue: controller.selectedTextIndex.value >= 0 &&
                          controller.selectedTextIndex.value < controller.textWidgets.length
                      ? '${(controller.textWidgets[controller.selectedTextIndex.value].opacity.value * 100).round()}%'
                      : '100%',
                )),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Font, Style, and Color Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.font_download,
                label: 'Font',
                onPressed: () => _showFontDialog(context, controller, fontController),
              ),
              TextStyleToggleButton(),
              _buildControlButton(
                icon: Icons.color_lens,
                label: 'Color',
                onPressed: () => _showColorDialog(context, controller, selectedColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactSlider({
    required IconData icon,
    required String label,
    required double value,
    required ValueChanged<double>? onChanged,
    required double min,
    required double max,
    required int divisions,
    required Color color,
    required String displayValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '$label: $displayValue',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
          child: Slider(
            value: value,
            onChanged: onChanged,
            min: min,
            max: max,
            divisions: divisions,
            activeColor: onChanged != null ? color : Colors.grey,
            inactiveColor: (onChanged != null ? color : Colors.grey).withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
          ),
          child: Icon(icon, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _showFontDialog(BuildContext context, ImageSegmentationController controller, FontController fontController) {
    if (controller.textWidgets.isEmpty || controller.selectedTextIndex.value < 0) {
      Get.snackbar('No Text Selected', 'Select a text widget first');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Select Font', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Preview', style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Obx(() {
                      final textData = controller.selectedTextIndex.value >= 0 &&
                              controller.selectedTextIndex.value < controller.textWidgets.length
                          ? controller.textWidgets[controller.selectedTextIndex.value]
                          : null;
                      return Text(
                        textData?.text.value.isEmpty ?? true ? 'Sample Text' : textData!.text.value,
                        style: fontController.getFontStyle(
                          textData?.font.value ?? fontController.defaultFont,
                          fontSize: 30.0,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: fontController.availableFonts.length,
                  itemBuilder: (context, fontIndex) {
                    final font = fontController.availableFonts[fontIndex];
                    return ListTile(
                      title: Text(
                        controller.selectedTextIndex.value >= 0 &&
                                controller.selectedTextIndex.value < controller.textWidgets.length
                            ? controller.textWidgets[controller.selectedTextIndex.value].text.value.isEmpty
                                ? 'Sample Text'
                                : controller.textWidgets[controller.selectedTextIndex.value].text.value
                            : 'Sample Text',
                        style: fontController.getFontStyle(font, fontSize: 30.0),
                      ),
                      onTap: () {
                        if (controller.selectedTextIndex.value >= 0 &&
                            controller.selectedTextIndex.value < controller.textWidgets.length) {
                          final selectedIndex = controller.selectedTextIndex.value;
                          fontController.setSelectedFont(selectedIndex, font);
                          controller.textWidgets[selectedIndex].font.value = font;
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
        ],
      ),
    );
  }

  void _showColorDialog(BuildContext context, ImageSegmentationController controller, Rx<Color> selectedColor) {
    if (controller.textWidgets.isEmpty || controller.selectedTextIndex.value < 0) {
      Get.snackbar('No Text', 'Select a text widget first');
      return;
    }

    selectedColor.value = controller.textWidgets[controller.selectedTextIndex.value].color.value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Pick a color', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: selectedColor.value,
            onColorChanged: (color) {
              selectedColor.value = color;
              controller.textWidgets[controller.selectedTextIndex.value].color.value = color;
            },
            availableColors: [
              Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
              Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
              Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
              Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
              Colors.brown, Colors.grey, Colors.blueGrey, Colors.black, Colors.white,
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Done', style: TextStyle(color: Colors.grey[600])),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}