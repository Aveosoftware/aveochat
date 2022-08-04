import 'package:flutter/material.dart';
import 'package:melos_chat/melos_chat.dart';

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

  List<String> selectionList = [];
  bool hasSelectionStarted = false;

  @override
  void initState() {
    conversationStream = MelosChat.instance.firebaseChatService
        .getConversationStreamByChatId(
            chatId: widget.chat.chatId, descending: true);
    super.initState();
  }

  deleteSelection() async {
    await MelosChat.instance.firebaseChatService.deleteConversation(
      chatId: widget.chat.chatId,
      selectedMessageIds: selectionList,
    );
    hasSelectionStarted = false;
    setState(() {});
    selectionList.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MelosChat
              .instance.melosChatOptions.chatRoomThemeData?.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          MelosChat.instance.firebaseChatService.getChatRoomName(
              chat: widget.chat, thisUserId: MelosChat.instance.user.userId),
        ),
        actions: [
          MelosChat.instance.melosChatOptions.allowMessageDeletion
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
                        isSelected:
                            selectionList.contains(snapshot.data![index].msgId),
                        isDeleted: snapshot.data![index].isDeleted,
                        message: snapshot.data![index].message,
                        isMessageSent: snapshot.data![index].sentBy ==
                            MelosChat.instance.user.userId,
                        timestamp: snapshot.data![index].timestamp,
                        receivedMessageTileColor: MelosChat
                                .instance
                                .melosChatOptions
                                .chatRoomThemeData
                                ?.receivedMessageColor ??
                            Colors.blueGrey,
                        receivedMessageColor: MelosChat
                                .instance
                                .melosChatOptions
                                .chatRoomThemeData
                                ?.receivedMessageColor ??
                            Colors.white,
                        sentMessageColor: MelosChat.instance.melosChatOptions
                                .chatRoomThemeData?.sentMessageColor ??
                            Colors.white,
                        sentMessageTileColor: MelosChat
                                .instance
                                .melosChatOptions
                                .chatRoomThemeData
                                ?.sentMessageTileColor ??
                            Theme.of(context).primaryColor,
                        onLongPress: () {
                          if (!hasSelectionStarted) {
                            if (snapshot.data![index].sentBy ==
                                MelosChat.instance.user.userId) {
                              selectionList.add(snapshot.data![index].msgId);
                              hasSelectionStarted = true;
                              setState(() {});
                            }
                          }
                        },
                        onTap: () {
                          if (hasSelectionStarted) {
                            if (selectionList
                                .contains(snapshot.data![index].msgId)) {
                              selectionList.remove(snapshot.data![index].msgId);
                              if (selectionList.isEmpty) {
                                hasSelectionStarted = false;
                              }
                            } else {
                              if (snapshot.data![index].sentBy ==
                                  MelosChat.instance.user.userId) {
                                selectionList.add(snapshot.data![index].msgId);
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
                hintText: MelosChat
                    .instance.melosChatOptions.chatRoomThemeData!.messageHint,
                focusedBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            trailing: IconButton(
              icon: MelosChat
                  .instance.melosChatOptions.chatRoomThemeData!.sendIcon,
              onPressed: () async {
                if (messageController.text.trim().isNotEmpty) {
                  try {
                    String trimmedMsg = messageController.text.trim();
                    messageController.clear();
                    await MelosChat.instance.firebaseChatService
                        .sendMessageByChatId(
                      chatId: widget.chat.chatId,
                      message: Message(
                        message: trimmedMsg,
                        sentBy: MelosChat.instance.user.userId,
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
