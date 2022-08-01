part of '../../melos_chat.dart';

class ChatRoomThemeData {
  final String messageHint;
  final Icon sendIcon;
  final Color? sentMessageColor;
  final Color? receivedMessageColor;
  final Color? sentMessageTileColor;
  final Color? receivedMessageTileColor;

  const ChatRoomThemeData({
    this.messageHint = 'Message',
    this.sendIcon = const Icon(
      Icons.send,
    ),
    this.sentMessageColor,
    this.receivedMessageColor,
    this.sentMessageTileColor,
    this.receivedMessageTileColor,
  });
}

class MelosChatThemeData {
  final bool allowUserSearch;
  final String searchHint;
  final Color? avatarBackgroundColor;
  final Color? chatTileColor;
  final Color? backgroundColor;
  final Color? chatBackgroundColor;
  final ChatRoomThemeData? chatRoomThemeData;

  const MelosChatThemeData({
    this.allowUserSearch = true,
    this.searchHint = 'Search',
    this.avatarBackgroundColor,
    this.chatTileColor,
    this.backgroundColor,
    this.chatBackgroundColor,
    this.chatRoomThemeData,
  });
}
