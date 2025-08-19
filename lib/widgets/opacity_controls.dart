import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import '../controller/font_controller.dart';
import '../controller/image_segmentation_controller.dart';

class OpacityControlsWidget extends StatelessWidget {
  const OpacityControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImageSegmentationController>();
    final fontController = Get.find<FontController>();

    // Observable for selected color
    final Rx<Color> selectedColor = Colors.white.obs;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Font Size:"),
              Expanded(
                child: Obx(
                  () => Slider(
                    value: controller.fontSize.value,
                    onChanged: controller.updateFontSize,
                    min: 10.0,
                    max: 100.0,
                    divisions: 30,
                    label: controller.fontSize.value.round().toString(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Change Font:"),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (controller.textWidgets.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.black87,
                        title: const Text(
                          'Select Font',
                          style: TextStyle(color: Colors.white),
                        ),
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
                                    const Text(
                                      'Preview',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Obx(() {
                                      final textData = controller.textWidgets.isNotEmpty
                                          ? controller.textWidgets[0]
                                          : null;
                                      return Text(
                                        textData?.text.value.isEmpty ?? true
                                            ? 'Sample Text'
                                            : textData!.text.value,
                                        style: fontController.getFontStyle(
                                          textData?.font.value ?? fontController.defaultFont,
                                          fontSize: controller.fontSize.value,
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
                                        controller.textWidgets.isNotEmpty
                                            ? controller.textWidgets[0].text.value.isEmpty
                                                ? 'Sample Text'
                                                : controller.textWidgets[0].text.value
                                            : 'Sample Text',
                                        style: fontController.getFontStyle(
                                          font,
                                        ),
                                      ),
                                      onTap: () {
                                        for (var i = 0; i < controller.textWidgets.length; i++) {
                                          fontController.setSelectedFont(i, font);
                                          controller.textWidgets[i].font.value = font;
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
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Get.snackbar('No Text', 'Add a text widget first');
                  }
                },
                child: const Text('Select Font'),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Select Text:"),
              const SizedBox(width: 10),
              Obx(
                () => DropdownButton<int>(
                  value: controller.selectedTextIndex.value >= 0 &&
                          controller.selectedTextIndex.value < controller.textWidgets.length
                      ? controller.selectedTextIndex.value
                      : null,
                  hint: const Text("Select a text"),
                  items: controller.textWidgets.asMap().entries.map((entry) {
                    final index = entry.key;
                    final textData = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Text(
                        textData.text.value.isEmpty ? "Text ${index + 1}" : textData.text.value,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectedTextIndex.value = value;
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text("Text Color:"),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  if (controller.textWidgets.isNotEmpty && controller.selectedTextIndex.value >= 0) {
                    selectedColor.value = controller.textWidgets[controller.selectedTextIndex.value].color.value;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: selectedColor.value,
                            onColorChanged: (color) {
                              selectedColor.value = color;
                              // Update color for the selected text widget only
                              controller.textWidgets[controller.selectedTextIndex.value].color.value = color;
                            },
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Done'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    Get.snackbar('No Text', 'Select a text widget first');
                  }
                },
                child: const Text('Pick Color'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}