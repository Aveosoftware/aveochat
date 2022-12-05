part of '../../aveochat.dart';

class ChatRoom extends StatefulWidget {
  final ChatRoomModel chat;
  const ChatRoom({
    Key? key,
    required this.chat,
  }) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late Stream<List<Message>> conversationStream;
  late List<Message> conversation = [];
  TextEditingController messageController = TextEditingController();

  List<Message> selectionList = [];
  bool hasSelectionStarted = false;

  @override
  void initState() {
    // conversationStream = AveoChatConfig.instance.firebaseChatService
    //     .getConversationStreamByChatIdForUserId(
    //         userId: chatObject.participants
    //             .firstWhere((element) =>
    //                 element.userId != AveoChatConfig.instance.user.userId)
    //             .userId,
    //         chatId: chatObject.chatId,
    //         descending: true);
    addDemoData();
    super.initState();
  }

  addDemoData() {
    conversation.add(
      Message(
          message: "Hello",
          sentBy: AveoChatConfig.instance.user.userId,
          timestamp:
              DateTime.now().subtract(Duration(minutes: 40)).toIso8601String()),
    );

    conversation.add(
      Message(
          message: "Hey Man",
          sentBy: '',
          timestamp: DateTime.now()
              .subtract(const Duration(minutes: 38))
              .toIso8601String()),
    );

    conversation.add(
      Message(
          message: "How are you?",
          sentBy: AveoChatConfig.instance.user.userId,
          timestamp: DateTime.now()
              .subtract(const Duration(minutes: 37))
              .toIso8601String()),
    );

    conversation.add(
      Message(
          message: "I'm doing good",
          sentBy: '',
          timestamp: DateTime.now()
              .subtract(const Duration(minutes: 40))
              .toIso8601String()),
    );

    conversation.add(
      Message(
          message: "What about you?",
          sentBy: '',
          timestamp: DateTime.now()
              .subtract(const Duration(minutes: 40))
              .toIso8601String()),
    );
  }

  deleteSelection() async {
    await AveoChatConfig.instance.firebaseChatService.deleteConversation(
      chatId: chatObject.chatId,
      selectedMessageIds: selectionList.map((e) => e.msgId).toList(),
    );
    clearSelection();
  }

  copySelection() async {
    if (selectionList.length == 1) {
      Clipboard.setData(ClipboardData(text: selectionList.first.message));
      return;
    }
    selectionList.sort(
      (a, b) => DateTime.parse(a.timestamp)
          .millisecondsSinceEpoch
          .compareTo(DateTime.parse(b.timestamp).millisecondsSinceEpoch),
    );
    String copyData = '';
    for (var obj in selectionList) {
      copyData =
          "$copyData[${DateFormat('d/M, h:m a').format(DateTime.parse(obj.timestamp).toLocal())}] ${obj.message}\n";
    }
    Clipboard.setData(ClipboardData(text: copyData));
    clearSelection();
  }

  clearSelection() {
    hasSelectionStarted = false;
    setState(() {});
    selectionList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AveoChatConfig
              .instance.aveoChatOptions.chatRoomThemeData.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AveoChatConfig.instance.aveoChatOptions
            .chatRoomThemeData.chatRoomAppBarThemeData.backgroundColor,
        centerTitle: AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData
            .chatRoomAppBarThemeData.centerTitle,
        elevation: AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData
            .chatRoomAppBarThemeData.elevation,
        foregroundColor: AveoChatConfig.instance.aveoChatOptions
            .chatRoomThemeData.chatRoomAppBarThemeData.foregroundColor,
        title: Text(
          AveoChatConfig.instance.firebaseChatService.getChatRoomName(
              chat: chatObject,
              thisUserId: AveoChatConfig.instance.user.userId),
        ),
        leading: IconButton(
            onPressed: () {
              pageController.previousPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear);
            },
            icon: const Icon(Icons.keyboard_arrow_left)),
        actions: [
          AveoChatConfig.instance.aveoChatOptions.allowMessageDeletion
              ? hasSelectionStarted
                  ? IconButton(
                      onPressed: () async {
                        await deleteSelection();
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                    )
                  : Container()
              : Container(),
          hasSelectionStarted
              ? IconButton(
                  onPressed: () async {
                    await copySelection();
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.white,
                  ),
                )
              : Container()
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ...List.generate(
              conversation.length,
              (index) => MessageBubble(
                    context,
                    readStatus: 1,
                    isDeleted: false,
                    message: conversation[index].message,
                    isMessageSent: conversation[index].sentBy ==
                        AveoChatConfig.instance.user.userId,
                    timestamp: conversation[index].timestamp,
                    receivedMessageTileColor: AveoChatConfig
                            .instance
                            .aveoChatOptions
                            .chatRoomThemeData
                            .receivedMessageColor ??
                        Colors.blueGrey,
                    receivedMessageColor: AveoChatConfig
                            .instance
                            .aveoChatOptions
                            .chatRoomThemeData
                            .receivedMessageColor ??
                        Colors.white,
                    sentMessageColor: AveoChatConfig.instance.aveoChatOptions
                            .chatRoomThemeData.sentMessageColor ??
                        Colors.white,
                    sentMessageTileColor: AveoChatConfig
                            .instance
                            .aveoChatOptions
                            .chatRoomThemeData
                            .sentMessageTileColor ??
                        Theme.of(context).primaryColor,
                    onLongPress: () {},
                    onTap: () {},
                  )).toList(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          padding: MediaQuery.of(context).viewInsets,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34.0),
          ),
          child: ListTile(
            dense: true,
            minVerticalPadding: 0,
            minLeadingWidth: 0,
            title: TextFormField(
              controller: messageController,
              minLines: 1,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: AveoChatConfig
                    .instance.aveoChatOptions.chatRoomThemeData.messageHint,
                focusedBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            trailing: IconButton(
              icon: AveoChatConfig
                  .instance.aveoChatOptions.chatRoomThemeData.sendIcon,
              onPressed: () async {
                if (messageController.text.trim().isNotEmpty) {
                  try {
                    String trimmedMsg = messageController.text.trim();
                    messageController.clear();
                    await AveoChatConfig.instance.firebaseChatService
                        .sendMessageByChatId(
                      chatId: chatObject.chatId,
                      message: Message(
                        message: trimmedMsg,
                        sentBy: AveoChatConfig.instance.user.userId,
                        timestamp: DateTime.now().toUtc().toIso8601String(),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
