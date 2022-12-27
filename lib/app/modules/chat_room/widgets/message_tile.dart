part of '../../../../aveochat.dart';

class MessageBubble extends StatelessWidget {
  final String message;
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
    required this.message,
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isMessageSent
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ReadMoreText(
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
                  color:
                      isMessageSent ? sentMessageColor : receivedMessageColor,
                ),
              ),
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
