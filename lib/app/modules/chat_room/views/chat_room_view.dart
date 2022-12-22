import 'package:aveochat/aveochat.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  final ChatRoomModel chat;
  const ChatRoomView({Key? key, required this.chat}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AveoChatConfig
              .instance.aveoChatOptions.chatRoomThemeData.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AveoChatConfig.instance.chatServiceFramework.getChatRoomName(
              chat: chat, thisUserId: AveoChatConfig.instance.user.userId),
        ),
        backgroundColor: AveoChatConfig.instance.aveoChatOptions
            .chatRoomThemeData.chatRoomAppBarThemeData.backgroundColor,
        centerTitle: AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData
            .chatRoomAppBarThemeData.centerTitle,
        elevation: AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData
            .chatRoomAppBarThemeData.elevation,
        foregroundColor: AveoChatConfig.instance.aveoChatOptions
            .chatRoomThemeData.chatRoomAppBarThemeData.foregroundColor,
      ),
      body: Center(
        child: Text(
          'ChatRoomView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
