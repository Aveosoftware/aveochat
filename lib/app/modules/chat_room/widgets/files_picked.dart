import 'dart:developer';
import 'dart:io';

import 'package:aveochat/app/modules/chat_room/controllers/chat_room_controller.dart';
import 'package:aveochat/aveochat.dart';
import 'package:aveochat/core/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilesPicked extends GetView<ChatRoomController> {
  const FilesPicked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.pickedFiles.isNotEmpty
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 80,
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: controller.pickedFiles.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 80,
                    width: 80,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Obx(() {
                          // log(controller.selectedPickedFileName.value);
                          return GestureDetector(
                            onTap: () {
                              if (controller
                                      .selectedPickedFile.value.fileName !=
                                  controller.pickedFiles[index].fileName) {
                                controller.selectedPickedFile.value.fileName =
                                    controller.pickedFiles[index].fileName;
                              } else {
                                controller.selectedPickedFile.value.fileName =
                                    '';
                              }
                              controller.selectedPickedFile.update((val) {});
                              controller.captionController.text =
                                  controller.pickedFiles[index].caption;
                              controller.captionController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: controller
                                          .captionController.text.length));
                            },
                            onLongPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewer(
                                      tag: controller
                                          .pickedFiles[index].pathOrUrl,
                                      url: controller
                                          .pickedFiles[index].pathOrUrl),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: controller.selectedPickedFile.value
                                            .fileName ==
                                        controller.pickedFiles[index].fileName
                                    ? Border.all(
                                        width: 2,
                                        color: Theme.of(context).primaryColor)
                                    : null,
                              ),
                              child: Image(
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                                image: FileImage(File(
                                    controller.pickedFiles[index].pathOrUrl)),
                              ),
                            ),
                          );
                        }),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: GestureDetector(
                            onTap: () {
                              controller.pickedFiles.removeAt(index);
                              controller.selectedPickedFile.value = PickedFile(
                                  msgType: '', fileName: '', pathOrUrl: '');
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 12,
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class FilesPickerButton extends GetView<ChatRoomController> {
  const FilesPickerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await controller.pickFiles(context);
      },
      icon: const Icon(Icons.attach_file_outlined),
    );
  }
}
