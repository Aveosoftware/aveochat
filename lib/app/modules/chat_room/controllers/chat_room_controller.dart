import 'dart:async';

import 'package:aveochat/aveochat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomController extends GetxController {
  ChatRoomController({required this.chat});
  ChatRoomModel chat;
  late StreamController<List<Message>> conversationStream = StreamController();
  TextEditingController messageController = TextEditingController();

  RxList<Message> selectionList = <Message>[].obs;
  RxBool hasSelectionStarted = false.obs;

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

  @override
  void dispose() {
    conversationStream.close();
    super.dispose();
  }
}
