part of '../../melos_chat.dart';

Widget ChatTile(
  context, {
  required String chatName,
  Color? chatTileColor,
  Color? avatarBackgroundColor,
  required ChatRoomModel chat,
}) {
  String chatName = MelosChat.instance.firebaseChatService
      .getChatRoomName(chat: chat, thisUserId: MelosChat.instance.user.userId);
  return ListTile(
    onTap: () {
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
