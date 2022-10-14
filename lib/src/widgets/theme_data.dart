part of '../../aveochat.dart';

class ChatRoomThemeData {
  final String messageHint;
  final Icon sendIcon;
  final Color? sentMessageColor;
  final Color? receivedMessageColor;
  final Color? sentMessageTileColor;
  final Color? receivedMessageTileColor;
  final Color? backgroundColor;
  final bool showTimestamp;
  final bool enableReadReciepts;
  final ChatRoomAppBarThemeData chatRoomAppBarThemeData;

  const ChatRoomThemeData({
    this.messageHint = 'Message',
    this.sendIcon = const Icon(
      Icons.send,
    ),
    this.sentMessageColor,
    this.receivedMessageColor,
    this.sentMessageTileColor,
    this.receivedMessageTileColor,
    this.backgroundColor,
    this.showTimestamp = true,
    this.enableReadReciepts = true,
    this.chatRoomAppBarThemeData = const ChatRoomAppBarThemeData(),
  });
}

class ChatRoomAppBarThemeData {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool? centerTitle;
  final double? elevation;

  const ChatRoomAppBarThemeData({
    this.backgroundColor,
    this.foregroundColor,
    this.centerTitle,
    this.elevation,
  });
}

class AveoChatConfigOptions {
  final bool allowUserSearch;
  final bool allowMessageDeletion;
  final String searchHint;
  final Color? avatarBackgroundColor;
  final Color? chatTileColor;
  final Color? backgroundColor;
  final ChatRoomThemeData chatRoomThemeData;

  const AveoChatConfigOptions({
    this.allowUserSearch = true,
    this.allowMessageDeletion = true,
    this.searchHint = 'Search',
    this.avatarBackgroundColor,
    this.chatTileColor,
    this.backgroundColor,
    this.chatRoomThemeData = const ChatRoomThemeData(),
  });
}
