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
                    return msgTypeImage(context);
                  case MsgType.video:
                    return msgTypeVideo();
                  case MsgType.audio:
                    return msgTypeAudio();
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

  msgTypeImage(context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment:
            isMessageSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 140,
            padding: const EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0),
            child: Visibility(
              visible: message.isNotEmpty,
              replacement: const Center(
                child: CupertinoActivityIndicator(),
              ),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageViewer(tag: message, url: message),
                    ),
                  );
                },
                child: Hero(
                  tag: message,
                  child: CachedNetworkImage(
                    imageUrl: message,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(14),
                            topRight: const Radius.circular(14),
                            bottomRight: isMessageSent
                                ? Radius.zero
                                : const Radius.circular(14),
                            bottomLeft: isMessageSent
                                ? const Radius.circular(14)
                                : Radius.zero,
                          ),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          caption.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  child: Text(
                    caption,
                    // textAlign: isMessageSent ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                      color: isMessageSent
                          ? sentMessageColor
                          : receivedMessageColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  msgTypeVideo() {}

  msgTypeAudio() {}
}
