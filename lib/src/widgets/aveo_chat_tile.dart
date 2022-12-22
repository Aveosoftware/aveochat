part of '../../aveochat.dart';

Widget ChatTileOld(
  context, {
  required String chatName,
  Color? chatTileColor,
  Color? avatarBackgroundColor,
  required ChatRoomModel chat,
}) {
  String chatName = AveoChatConfig.instance.chatServiceFramework
      .getChatRoomName(
          chat: chat, thisUserId: AveoChatConfig.instance.user.userId);
  return ListTile(
    onTap: () {
      FocusManager.instance.primaryFocus!.unfocus();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChatRoom(
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
      child: Text(chatName[0].toUpperCase()),
    ),
    title: Text(chatName.toTitleCase()),
  );
}
