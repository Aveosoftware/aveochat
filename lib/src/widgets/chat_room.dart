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

  @override
  void initState() {
    conversationStream = MelosChat.instance.firebaseChatService
        .getConversationStreamByChatId(
            chatId: widget.chat.chatId, descending: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MelosChat.instance.melosChatThemeData.backgroundColor,
      appBar: AppBar(
        title: Text(MelosChat.instance.firebaseChatService.getChatRoomName(
            chat: widget.chat, thisUserId: MelosChat.instance.user.userId)),
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
                      return MessageTile(
                        context,
                        message: snapshot.data![index].message,
                        isMessageSent: snapshot.data![index].sentBy ==
                            MelosChat.instance.user.userId,
                        timestamp: snapshot.data![index].timestamp,
                        receivedMessageTileColor: MelosChat
                                .instance
                                .melosChatThemeData
                                .chatRoomThemeData
                                ?.receivedMessageColor ??
                            Colors.blueGrey,
                        receivedMessageColor: MelosChat
                                .instance
                                .melosChatThemeData
                                .chatRoomThemeData
                                ?.receivedMessageColor ??
                            Colors.white,
                        sentMessageColor: MelosChat.instance.melosChatThemeData
                                .chatRoomThemeData?.sentMessageColor ??
                            Colors.white,
                        sentMessageTileColor: MelosChat
                                .instance
                                .melosChatThemeData
                                .chatRoomThemeData
                                ?.sentMessageTileColor ??
                            Theme.of(context).primaryColor,
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
              maxLines: null,
              decoration: InputDecoration(
                hintText: MelosChat
                    .instance.melosChatThemeData.chatRoomThemeData!.messageHint,
                focusedBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    const OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            trailing: IconButton(
              icon: MelosChat
                  .instance.melosChatThemeData.chatRoomThemeData!.sendIcon,
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
