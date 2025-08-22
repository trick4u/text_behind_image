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
          Obx(
            () => Row(
              children: [
                const Icon(Icons.format_size),
                Expanded(
                  child: Slider(
                    value:
                        controller.selectedTextIndex.value >= 0 &&
                            controller.selectedTextIndex.value <
                                controller.textWidgets.length
                        ? controller
                              .textWidgets[controller.selectedTextIndex.value]
                              .fontSize
                              .value
                        : 30.0,
                    onChanged: controller.selectedTextIndex.value >= 0
                        ? controller.updateFontSize
                        : null,
                    min: 10.0,
                    max: 200.0,
                    divisions: 20,
                    label:
                        controller.selectedTextIndex.value >= 0 &&
                            controller.selectedTextIndex.value <
                                controller.textWidgets.length
                        ? controller
                              .textWidgets[controller.selectedTextIndex.value]
                              .fontSize
                              .value
                              .round()
                              .toString()
                        : '30',
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Row(
              children: [
                const Icon(Icons.opacity),
                Expanded(
                  child: Slider(
                    value:
                        controller.selectedTextIndex.value >= 0 &&
                            controller.selectedTextIndex.value <
                                controller.textWidgets.length
                        ? controller
                              .textWidgets[controller.selectedTextIndex.value]
                              .opacity
                              .value
                        : 1.0,
                    onChanged: controller.selectedTextIndex.value >= 0
                        ? (value) => controller.updateTextOpacity(value)
                        : null,
                    min: 0.0,
                    max: 1.0,
                    divisions: 100,
                    label:
                        controller.selectedTextIndex.value >= 0 &&
                            controller.selectedTextIndex.value <
                                controller.textWidgets.length
                        ? controller
                              .textWidgets[controller.selectedTextIndex.value]
                              .opacity
                              .value
                              .toStringAsFixed(1)
                        : '1.0',
                  ),
                ),
              ],
            ),
          ),
    
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                                      final textData =
                                          controller.textWidgets.isNotEmpty
                                          ? controller.textWidgets[0]
                                          : null;
                                      return Text(
                                        textData?.text.value.isEmpty ?? true
                                            ? 'Sample Text'
                                            : textData!.text.value,
                                        style: fontController.getFontStyle(
                                          textData?.font.value ??
                                              fontController.defaultFont,
                                          fontSize: 30.0,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      fontController.availableFonts.length,
                                  itemBuilder: (context, fontIndex) {
                                    final font = fontController
                                        .availableFonts[fontIndex];
                                    return ListTile(
                                      title: Text(
                                        controller.textWidgets.isNotEmpty
                                            ? controller
                                                      .textWidgets[0]
                                                      .text
                                                      .value
                                                      .isEmpty
                                                  ? 'Sample Text'
                                                  : controller
                                                        .textWidgets[0]
                                                        .text
                                                        .value
                                            : 'Sample Text',
                                        style: fontController.getFontStyle(
                                          font,
                                          fontSize: 30.0,
                                        ),
                                      ),
                                      onTap: () {
                                        for (
                                          var i = 0;
                                          i < controller.textWidgets.length;
                                          i++
                                        ) {
                                          fontController.setSelectedFont(
                                            i,
                                            font,
                                          );
                                          controller.textWidgets[i].font.value =
                                              font;
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
                child: const Icon(Icons.font_download),
              ),

              ElevatedButton(
                onPressed: () {
                  if (controller.textWidgets.isNotEmpty &&
                      controller.selectedTextIndex.value >= 0) {
                    selectedColor.value = controller
                        .textWidgets[controller.selectedTextIndex.value]
                        .color
                        .value;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Pick a color'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: selectedColor.value,
                            onColorChanged: (color) {
                              selectedColor.value = color;
                              controller
                                      .textWidgets[controller
                                          .selectedTextIndex
                                          .value]
                                      .color
                                      .value =
                                  color;
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
                child: const Icon(Icons.color_lens),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
