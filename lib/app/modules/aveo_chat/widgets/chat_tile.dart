import 'package:aveochat/app/modules/aveo_chat/controllers/aveo_chat_controller.dart';
import 'package:aveochat/app/modules/chat_room/views/chat_room_view.dart';
import 'package:aveochat/aveochat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatTile extends GetView<AveoChatController> {
  ChatRoomModel chat;
  ChatTile({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String chatName = AveoChatConfig.instance.chatServiceFramework
        .getChatRoomName(
            chat: chat, thisUserId: AveoChatConfig.instance.user.userId);
    return ListTile(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatRoomView(
            chat: chat,
          ),
        ));
      },
      tileColor: AveoChatConfig.instance.aveoChatOptions.chatTileColor,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor:
            AveoChatConfig.instance.aveoChatOptions.avatarBackgroundColor ??
                Theme.of(context).primaryColor,
        child: Text((AveoChatConfig.instance.chatServiceFramework
                .getChatRoomName(
                    chat: chat,
                    thisUserId: AveoChatConfig.instance.user.userId))[0]
            .toUpperCase()),
      ),
      title: Text(AveoChatConfig.instance.chatServiceFramework
          .getChatRoomName(
              chat: chat, thisUserId: AveoChatConfig.instance.user.userId)
          .toTitleCase()),
    );
  }
}
