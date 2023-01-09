part of '../../aveochat.dart';

class ChatRoomThemeData {
  final String captionHint;
  final String messageHint;
  final Icon sendIcon;
  final Color? sentMessageColor;
  final Color? receivedMessageColor;
  final Color? sentMessageTileColor;
  final Color? receivedMessageTileColor;
  final Color? backgroundColor;
  final Icon deleteMessageIcon;
  final Icon copyMessageIcon;
  final bool showTimestamp;
  final bool enableReadReciepts;
  final ChatRoomAppBarThemeData chatRoomAppBarThemeData;
  final AudioMessageBubbleThemeData audioMessageBubbleThemeData;
  final ImageMessageBubbleThemeData imageMessageBubbleThemeData;

  const ChatRoomThemeData({
    this.captionHint = 'Write a caption...',
    this.messageHint = 'Message',
    this.sendIcon = const Icon(
      Icons.send,
    ),
    this.deleteMessageIcon = const Icon(
      Icons.delete,
      color: Colors.redAccent,
    ),
    this.copyMessageIcon = const Icon(
      Icons.copy_all,
      color: Colors.black,
    ),
    this.sentMessageColor,
    this.receivedMessageColor,
    this.sentMessageTileColor,
    this.receivedMessageTileColor,
    this.backgroundColor,
    this.showTimestamp = true,
    this.enableReadReciepts = true,
    this.chatRoomAppBarThemeData = const ChatRoomAppBarThemeData(),
    this.audioMessageBubbleThemeData = const AudioMessageBubbleThemeData(),
    this.imageMessageBubbleThemeData = const ImageMessageBubbleThemeData(),
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

/// [AudioMessageBubbleThemeData]
///
/// [DEFAULT] :
/// keepImageAliveWhenScrolled = true;
/// bgTintColor = Colors.white24;
///
/// ChatRoomThemeData(
///   audioMessageBubbleThemeData: AudioMessageBubbleThemeData(
///     keepAudioAliveWhenScrolled: true, // preserve audio message state when scrolled.
///     bgTintColor: Colors.white10, // Background tint applied to audio player of audio message.
///   )
/// )
///
class AudioMessageBubbleThemeData {
  final bool keepAudioAliveWhenScrolled;
  final Color bgTintColor;
  const AudioMessageBubbleThemeData({
    this.keepAudioAliveWhenScrolled = true,
    this.bgTintColor = Colors.white24,
  });
}

/// [ImageMessageBubbleThemeData]
///
/// [DEFAULT] :
/// keepImageAliveWhenScrolled = false;
///
/// ChatRoomThemeData(
///   imageMessageBubbleThemeData: ImageMessageBubbleThemeData(
///     keepImageAliveWhenScrolled: true, // preserve image message state when scrolled.
///   )
/// )
///
class ImageMessageBubbleThemeData {
  final bool keepImageAliveWhenScrolled;
  const ImageMessageBubbleThemeData({
    this.keepImageAliveWhenScrolled = false,
  });
}

/// [AveoChatConfigOptions]
///
/// [DEFAULT] :
/// allowUserSearch = true;
/// allowMessageDeletion = true;
/// searchHint = 'Search';
/// avatarBackgroundColor = null;
/// chatTileColor = null;
/// backgroundColor = null;
/// chatRoomThemeData = const ChatRoomThemeData()
///
/// This class provides variety of configuration
/// and theme options within the module.
///
/// Example to set custom theme or configurations :
///
///   AveoChatConfig.setAveoChatConfigOptions(
///       aveoChatConfigOptions: const AveoChatConfigOptions(
///     chatRoomThemeData: ChatRoomThemeData(
///       chatRoomAppBarThemeData: ChatRoomAppBarThemeData(
///         backgroundColor: Colors.white,
///         foregroundColor: Colors.black,
///         elevation: 0,
///       ),
///     ),
///   ));
///
/// Explore for more options.
///
class AveoChatConfigOptions {
  final bool allowUserSearch;
  final bool allowMessageDeletion;
  final bool allowMessageCopy;
  final String searchHint;
  final Color? avatarBackgroundColor;
  final Color? chatTileColor;
  final Color? backgroundColor;
  final ChatRoomThemeData chatRoomThemeData;

  const AveoChatConfigOptions({
    this.allowUserSearch = true,
    this.allowMessageDeletion = true,
    this.allowMessageCopy = true,
    this.searchHint = 'Search',
    this.avatarBackgroundColor,
    this.chatTileColor,
    this.backgroundColor,
    this.chatRoomThemeData = const ChatRoomThemeData(),
  });
}
