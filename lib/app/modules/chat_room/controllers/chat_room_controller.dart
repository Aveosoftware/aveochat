import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:aveochat/aveochat.dart';
import 'package:aveochat/models/picked_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomController extends GetxController {
  ChatRoomController({required this.chat});
  ChatRoomModel chat;
  late StreamController<List<Message>> conversationStream = StreamController();
  TextEditingController messageController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  RxList<Message> selectionList = <Message>[].obs;
  RxBool hasSelectionStarted = false.obs;

  RxList<PickedFile> pickedFiles = <PickedFile>[].obs;
  Rx<PickedFile> selectedPickedFile =
      PickedFile(msgType: '', fileName: '', pathOrUrl: '').obs;

  @override
  void onInit() {
    conversationStream.addStream(AveoChatConfig.instance.chatServiceFramework
        .getConversationStreamByChatIdForUserId(
            userId: chat.participants
                .firstWhere((element) =>
                    element.userId != AveoChatConfig.instance.user.userId)
                .userId,
            chatId: chat.chatId,
            descending: true));
    super.onInit();
  }

  @override
  void dispose() {
    conversationStream.close();
    super.dispose();
  }

  copySelection() async {
    if (selectionList.length == 1) {
      Clipboard.setData(ClipboardData(text: selectionList.first.message));
      return;
    }
    selectionList.sort(
      (a, b) => DateTime.parse(a.timestamp)
          .millisecondsSinceEpoch
          .compareTo(DateTime.parse(b.timestamp).millisecondsSinceEpoch),
    );
    String copyData = '';
    for (var obj in selectionList) {
      copyData =
          "$copyData[${DateFormat('d/M, h:m a').format(DateTime.parse(obj.timestamp).toLocal())}] ${obj.message}\n";
    }
    Clipboard.setData(ClipboardData(text: copyData));
    clearSelection();
  }

  clearSelection() {
    hasSelectionStarted.value = false;
    selectionList.clear();
  }

  deleteSelection() async {
    await AveoChatConfig.instance.chatServiceFramework.deleteConversation(
      chatId: chat.chatId,
      selectedMessageIds: selectionList.map((e) => e.msgId).toList(),
    );
    clearSelection();
  }

  pickFiles(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Card(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'Pick to upload',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            iconSize: 28,
                            onPressed: () async {
                              pickAndAddFiles(context, FileType.audio);
                            },
                            icon: const Icon(
                              Icons.music_note_outlined,
                              color: Colors.amber,
                            ),
                          ),
                          const Text('Audio', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            iconSize: 28,
                            onPressed: () async {
                              pickAndAddFiles(context, FileType.image);
                            },
                            icon: const Icon(
                              Icons.image,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const Text('Images', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            iconSize: 28,
                            onPressed: () async {
                              pickAndAddFiles(context, FileType.video);
                            },
                            icon: const Icon(
                              Icons.videocam_outlined,
                              color: Colors.red,
                            ),
                          ),
                          const Text('Videos', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickAndAddFiles(BuildContext context, FileType type) async {
    String msgType = '';
    switch (type) {
      case FileType.image:
        msgType = MsgType.image;
        break;
      case FileType.video:
        msgType = MsgType.video;
        break;
      case FileType.audio:
        msgType = MsgType.audio;
        break;
    }
    try {
      FilePickerResult? fileRes =
          await FilePicker.platform.pickFiles(allowMultiple: true, type: type);
      if (fileRes != null) {
        for (var file in fileRes.files) {
          pickedFiles.add(PickedFile(
              msgType: msgType, fileName: file.name, pathOrUrl: file.path!));
        }
      }
    } catch (e) {}
    Navigator.pop(context);
  }

  sendMessage() async {
    if (messageController.text.trim().isNotEmpty || pickedFiles.isNotEmpty) {
      List<Future> parentFuture = [];

      // TEXT MESSAGE
      if (messageController.text.trim().isNotEmpty) {
        try {
          String trimmedMsg = messageController.text.trim();
          messageController.clear();
          await prepareMessage(trimmedMsg, MsgType.text);
        } catch (e) {
          log(e.toString());
        }
      }

      // MEDIA MESSAGE
      if (pickedFiles.isNotEmpty) {
        List<PickedFile> files = RxList(pickedFiles);
        pickedFiles.clear();

        // Futures of indivisual image docs.
        List<Future> futures = [];
        for (PickedFile file in files) {
          selectedPickedFile.value =
              PickedFile(msgType: '', fileName: '', pathOrUrl: '');
          // Future of single File a
          List<Future> singleFileFuture = [];
          var ref = StorageRef.getImageRef.child(file.fileName);

          // Create an empty entry in firestore.
          DocumentReference<Map<String, dynamic>>? docref =
              (await prepareMessage("", file.msgType))
                  as DocumentReference<Map<String, dynamic>>?;
          if (docref == null) {
            return;
          }

          // Put file and when done, Update the empty entry with download url.
          singleFileFuture.add(
            ref.putFile(File(file.pathOrUrl)).then(
                  (p0) async => docref.update(MessageUpdate(
                    message: await ref.getDownloadURL(),
                    caption: file.caption,
                    type: file.msgType,
                  ).toMap()),
                ),
          );

          futures.add(Future.wait(singleFileFuture));
        }
        parentFuture.add(Future.wait(futures));
      }
      await Future.wait(parentFuture);
    }
  }

  prepareMessage(String msg, String msgType) {
    return AveoChatConfig.instance.chatServiceFramework.sendMessageByChatId(
      chatId: chat.chatId,
      message: Message(
        message: msg,
        type: msgType,
        sentBy: AveoChatConfig.instance.user.userId,
        timestamp: DateTime.now().toUtc().toIso8601String(),
      ),
    );
  }
}
