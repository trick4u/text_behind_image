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
          // Font Size Control
          Obx(
            () => Row(
              children: [
                Icon(Icons.format_size, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Font Size:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
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
                    activeColor: Colors.blue,
                    inactiveColor: Colors.blue.withOpacity(0.3),
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
                SizedBox(
                  width: 40,
                  child: Obx(() => Text(
                        controller.selectedTextIndex.value >= 0 &&
                                controller.selectedTextIndex.value <
                                    controller.textWidgets.length
                            ? '${controller.textWidgets[controller.selectedTextIndex.value].fontSize.value.round()}'
                            : '30',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Text Opacity Control
          Obx(
            () => Row(
              children: [
                Icon(Icons.opacity, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Text Opacity:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
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
                    activeColor: Colors.green,
                    inactiveColor: Colors.green.withOpacity(0.3),
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
                SizedBox(
                  width: 40,
                  child: Obx(() => Text(
                        controller.selectedTextIndex.value >= 0 &&
                                controller.selectedTextIndex.value <
                                    controller.textWidgets.length
                            ? '${(controller.textWidgets[controller.selectedTextIndex.value].opacity.value * 100).round()}%'
                            : '100%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Font and Color Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (controller.textWidgets.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          'Select Font',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
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
                                    Text(
                                      'Preview',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
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
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Get.snackbar('No Text', 'Add a text widget first');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.font_download, size: 20),
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
                        backgroundColor: Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          'Pick a color',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        content: SingleChildScrollView(
                          child: BlockPicker(
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
                            availableColors: [
                              Colors.red,
                              Colors.pink,
                              Colors.purple,
                              Colors.deepPurple,
                              Colors.indigo,
                              Colors.blue,
                              Colors.lightBlue,
                              Colors.cyan,
                              Colors.teal,
                              Colors.green,
                              Colors.lightGreen,
                              Colors.lime,
                              Colors.yellow,
                              Colors.amber,
                              Colors.orange,
                              Colors.deepOrange,
                              Colors.brown,
                              Colors.grey,
                              Colors.blueGrey,
                              Colors.black,
                              Colors.white,
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'Done',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.color_lens, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}