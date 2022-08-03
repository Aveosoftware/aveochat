part of '../../melos_chat.dart';

Widget MessageTile(
  BuildContext context, {
  required String message,
  required bool isMessageSent,
  required Color sentMessageColor,
  required Color receivedMessageColor,
  required Color sentMessageTileColor,
  required Color receivedMessageTileColor,
  onTap,
  onLongPress,
  String? timestamp,
  bool isSelected = false,
  required bool isDeleted,
}) {
  return ListTile(
    tileColor: isSelected ? Colors.grey[400] : null,
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
            bottomLeft: isMessageSent ? const Radius.circular(14) : Radius.zero,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Text(
          isDeleted
              ? isMessageSent
                  ? "🚫 You deleted this message"
                  : "🚫 This message was deleted"
              : message,
          style: TextStyle(
            fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
            color: isMessageSent ? sentMessageColor : receivedMessageColor,
          ),
        ),
      ),
    ),
  );
}
