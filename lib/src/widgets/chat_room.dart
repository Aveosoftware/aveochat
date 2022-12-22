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
    conversationStream = AveoChatConfig.instance.chatServiceFramework
        .getConversationStreamByChatIdForUserId(
            userId: widget.chat.participants
                .firstWhere((element) =>
                    element.userId != AveoChatConfig.instance.user.userId)
                .userId,
            chatId: widget.chat.chatId,
            descending: true);
    super.initState();
  }

  deleteSelection() async {
    await AveoChatConfig.instance.chatServiceFramework.deleteConversation(
      chatId: widget.chat.chatId,
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
          AveoChatConfig.instance.chatServiceFramework.getChatRoomName(
              chat: widget.chat,
              thisUserId: AveoChatConfig.instance.user.userId),
        ),
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
      body: StreamBuilder(
        stream: conversationStream,
        builder: (context, AsyncSnapshot<List<Message>> snapshot) {
          // WHEN LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              heightFactor: 8,
              child: CircularProgressIndicator(),
            );
          }
          // WHEN DATA IS LOADED
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(
                        context,
                        readStatus: snapshot.data![index].readStatus,
                        isSelected: selectionList.firstWhereOrNull((element) =>
                                element.msgId == snapshot.data![index].msgId) !=
                            null,
                        isDeleted: snapshot.data![index].isDeleted,
                        message: snapshot.data![index].message,
                        isMessageSent: snapshot.data![index].sentBy ==
                            AveoChatConfig.instance.user.userId,
                        timestamp: snapshot.data![index].timestamp,
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
                        sentMessageColor: AveoChatConfig
                                .instance
                                .aveoChatOptions
                                .chatRoomThemeData
                                .sentMessageColor ??
                            Colors.white,
                        sentMessageTileColor: AveoChatConfig
                                .instance
                                .aveoChatOptions
                                .chatRoomThemeData
                                .sentMessageTileColor ??
                            Theme.of(context).primaryColor,
                        onLongPress: () {
                          if (!hasSelectionStarted &&
                              !snapshot.data![index].isDeleted) {
                            if (snapshot.data![index].sentBy ==
                                AveoChatConfig.instance.user.userId) {
                              selectionList.add(snapshot.data![index]);
                              hasSelectionStarted = true;
                              setState(() {});
                            }
                          }
                        },
                        onTap: () {
                          if (hasSelectionStarted &&
                              !snapshot.data![index].isDeleted) {
                            if (selectionList.firstWhereOrNull((element) =>
                                    element.msgId ==
                                    snapshot.data![index].msgId) !=
                                null) {
                              selectionList.remove(snapshot.data![index]);
                              if (selectionList.isEmpty) {
                                hasSelectionStarted = false;
                              }
                            } else {
                              if (snapshot.data![index].sentBy ==
                                  AveoChatConfig.instance.user.userId) {
                                selectionList.add(snapshot.data![index]);
                              }
                            }
                            setState(() {});
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          // IF NO DATA IS AVAILABLE
          return const Center(
            heightFactor: 8,
            child: Text("Send a Hii..!"),
          );
        },
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
                    await AveoChatConfig.instance.chatServiceFramework
                        .sendMessageByChatId(
                      chatId: widget.chat.chatId,
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
