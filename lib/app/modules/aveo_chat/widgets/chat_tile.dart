import 'package:aveochat/app/modules/aveo_chat/controllers/aveo_chat_controller.dart';
import 'package:aveochat/app/modules/chat_room/controllers/chat_room_controller.dart';
import 'package:aveochat/app/modules/chat_room/views/chat_room_view.dart';
import 'package:aveochat/aveochat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatTile extends GetView<AveoChatController> {
  ChatRoomModel chat;
  ChatTile({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();

        Get.put(ChatRoomController(chat: chat));
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatRoomView(),
        ));
      },
      tileColor: AveoChatConfig.instance.aveoChatOptions.chatTileColor,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor:
            AveoChatConfig.instance.aveoChatOptions.avatarBackgroundColor ??
                Theme.of(context).primaryColor,
        child: Text(chat.chatName[0]),
      ),
      title: Text(chat.chatName),
    );
  }
}
