part of '../../../../aveochat.dart';

class MessageBubble extends StatelessWidget {
  final String msgType;
  final String message;
  final String caption;
  final bool isMessageSent;
  final Color sentMessageColor;
  final Color receivedMessageColor;
  final Color sentMessageTileColor;
  final Color receivedMessageTileColor;
  final onTap;
  final onLongPress;
  final String? timestamp;
  final bool isSelected;
  final bool isDeleted;
  final int readStatus;
  const MessageBubble(
    BuildContext context, {
    super.key,
    required this.msgType,
    required this.message,
    required this.caption,
    required this.isMessageSent,
    required this.sentMessageColor,
    required this.receivedMessageColor,
    required this.sentMessageTileColor,
    required this.receivedMessageTileColor,
    required this.onTap,
    required this.onLongPress,
    required this.timestamp,
    this.isSelected = false,
    required this.isDeleted,
    required this.readStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isSelected ? Colors.grey[300] : null,
      onTap: onTap,
      onLongPress: onLongPress,
      title: Align(
        alignment: isMessageSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          decoration: BoxDecoration(
            color:
                isMessageSent ? sentMessageTileColor : receivedMessageTileColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomRight:
                  isMessageSent ? Radius.zero : const Radius.circular(14),
              bottomLeft:
                  isMessageSent ? const Radius.circular(14) : Radius.zero,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isMessageSent
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ((() {
                switch (msgType) {
                  case MsgType.text:
                    return msgTypeText();
                  case MsgType.image:
                    return ImageMessageBubble(
                      message: message,
                      caption: caption,
                      isMessageSent: isMessageSent,
                      receivedMessageColor: receivedMessageColor,
                      sentMessageColor: sentMessageColor,
                    );
                  case MsgType.video:
                    return msgTypeVideo();
                  case MsgType.audio:
                    return AudioMessageBubble(
                      message: message,
                      caption: caption,
                      isMessageSent: isMessageSent,
                      receivedMessageColor: receivedMessageColor,
                      sentMessageColor: sentMessageColor,
                    );
                }
              })()),
              const SizedBox(
                height: 2,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData
                                .showTimestamp &&
                            !isDeleted
                        ? Text(
                            DateFormat('jm')
                                .format(DateTime.parse(timestamp!).toLocal()),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: isMessageSent
                                  ? sentMessageColor.withOpacity(0.7)
                                  : receivedMessageColor.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          )
                        : Container(),
                    AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData
                                .enableReadReciepts &&
                            !isDeleted
                        ? isMessageSent
                            ? const SizedBox(
                                width: 8.0,
                              )
                            : Container()
                        : Container(),
                    AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData
                                .enableReadReciepts &&
                            !isDeleted
                        ? isMessageSent
                            ? readStatus == ReadStatus.READ
                                ? Icon(
                                    Icons.done_all,
                                    size: 12,
                                    color: isMessageSent
                                        ? sentMessageColor.withOpacity(0.9)
                                        : receivedMessageColor.withOpacity(0.9),
                                  )
                                : Icon(
                                    Icons.done,
                                    size: 12,
                                    color: isMessageSent
                                        ? sentMessageColor.withOpacity(0.9)
                                        : receivedMessageColor.withOpacity(0.9),
                                  )
                            : Container()
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  msgTypeText() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 6.0, left: 12.0, right: 12.0, bottom: 6.0),
      child: ReadMoreText(
        isDeleted
            ? isMessageSent
                ? "🚫 You deleted this message"
                : "🚫 This message was deleted"
            : message,
        textAlign: TextAlign.start,
        colorClickableText: isMessageSent
            ? sentMessageColor.withOpacity(0.6)
            : receivedMessageColor.withOpacity(0.6),
        trimMode: TrimMode.Length,
        trimCollapsedText: 'Show more',
        trimExpandedText: 'Show less',
        style: TextStyle(
          fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
          color: isMessageSent ? sentMessageColor : receivedMessageColor,
        ),
      ),
    );
  }

  msgTypeVideo() {
    return Container(
      constraints: BoxConstraints(
          maxHeight: 60, minHeight: 60, maxWidth: 140, minWidth: 140),
      child: Text("VIDEO HAI"),
    );
  }
}
