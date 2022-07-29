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
  late List<Message> conversation = [];
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text(MelosChat.instance.firebaseChatService.getChatRoomName(
            chat: widget.chat, thisUserId: MelosChat.instance.user.userId)),
      ),
      body: StreamBuilder(
        stream: MelosChat.instance.firebaseChatService
            .getConversationStreamByChatId(
                chatId: widget.chat.chatId, descending: true),
        builder: (context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.hasData) {
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
                          message: snapshot.data![index].message,
                          isMessageSent: snapshot.data![index].sentBy ==
                              MelosChat.instance.user.userId,
                          receivedMessageTileColor: Colors.blueGrey,
                          receivedMessageColor: Colors.white,
                          timestamp: snapshot.data![index].timestamp);
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          padding: const EdgeInsets.all(0.0),
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
              decoration: const InputDecoration(
                hintText: "Message",
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: () async {
                if (messageController.text.trim().isNotEmpty) {
                  try {
                    await MelosChat.instance.firebaseChatService
                        .sendMessageByChatId(
                            chatId: widget.chat.chatId,
                            message: Message(
                              message: messageController.text.trim(),
                              sentBy: MelosChat.instance.user.userId,
                            ));
                  } catch (e) {
                    print(e);
                  } finally {
                    messageController.clear();
                    setState(() {});
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
