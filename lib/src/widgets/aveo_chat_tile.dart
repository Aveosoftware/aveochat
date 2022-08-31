part of '../../aveochat.dart';

Widget ChatTile(
  context, {
  required String chatName,
  Color? chatTileColor,
  Color? avatarBackgroundColor,
  required ChatRoomModel chat,
}) {
  String chatName = AveoChatConfig.instance.firebaseChatService.getChatRoomName(
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
    tileColor: chatTileColor,
    leading: CircleAvatar(
      radius: 20,
      backgroundColor: avatarBackgroundColor ?? Theme.of(context).primaryColor,
      child: Text(chatName[0].toUpperCase()),
    ),
    title: Text(chatName.toTitleCase()),
  );
}
