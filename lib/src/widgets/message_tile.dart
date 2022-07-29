part of '../../melos_chat.dart';

Widget MessageTile({
  required String message,
  required bool isMessageSent,
  Color? sentMessageColor,
  Color? receivedMessageColor,
  Color? sentMessageTileColor,
  Color? receivedMessageTileColor,
  String? timestamp,
}) {
  return ListTile(
    title: Align(
      alignment: isMessageSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Expanded(
        child: Column(
          crossAxisAlignment:
              isMessageSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMessageSent
                    ? sentMessageTileColor ?? Colors.blue
                    : receivedMessageTileColor ?? Colors.black26,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomRight:
                      isMessageSent ? Radius.zero : const Radius.circular(14),
                  bottomLeft:
                      isMessageSent ? const Radius.circular(14) : Radius.zero,
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Text(
                message,
                style: TextStyle(
                  color: isMessageSent
                      ? sentMessageColor ?? Colors.white
                      : receivedMessageColor ?? Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
