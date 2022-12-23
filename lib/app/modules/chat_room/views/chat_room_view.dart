import 'package:aveochat/aveochat.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends StatefulWidget {
  ChatRoomView({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  @override
  final ChatRoomController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AveoChatConfig
              .instance.aveoChatOptions.chatRoomThemeData.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          AveoChatConfig.instance.chatServiceFramework.getChatRoomName(
              chat: controller.chat,
              thisUserId: AveoChatConfig.instance.user.userId),
        ),
        backgroundColor: AveoChatConfig.instance.aveoChatOptions
            .chatRoomThemeData.chatRoomAppBarThemeData.backgroundColor,
        centerTitle: AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData
            .chatRoomAppBarThemeData.centerTitle,
        elevation: AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData
            .chatRoomAppBarThemeData.elevation,
        foregroundColor: AveoChatConfig.instance.aveoChatOptions
            .chatRoomThemeData.chatRoomAppBarThemeData.foregroundColor,
        actions: [
          AveoChatConfig.instance.aveoChatOptions.allowMessageDeletion
              ? Obx(
                  () => controller.hasSelectionStarted.value
                      ? IconButton(
                          onPressed: () async {
                            await controller.deleteSelection();
                          },
                          icon: AveoChatConfig.instance.aveoChatOptions
                              .chatRoomThemeData.deleteMessageIcon,
                        )
                      : const SizedBox.shrink(),
                )
              : const SizedBox.shrink(),
          Obx(
            () => controller.hasSelectionStarted.value
                ? IconButton(
                    onPressed: () async {
                      await controller.copySelection();
                    },
                    icon: AveoChatConfig.instance.aveoChatOptions
                        .chatRoomThemeData.copyMessageIcon,
                  )
                : const SizedBox.shrink(),
          )
        ],
      ),
      body: StreamBuilder(
        stream: controller.conversationStream.stream,
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
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Obx(() => MessageBubble(
                            context,
                            readStatus: snapshot.data![index].readStatus,
                            isSelected: controller.selectionList
                                    .firstWhereOrNull((element) =>
                                        element.msgId ==
                                        snapshot.data![index].msgId) !=
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
                              if (!controller.hasSelectionStarted.value &&
                                  !snapshot.data![index].isDeleted &&
                                  snapshot.data![index].sentBy ==
                                      AveoChatConfig.instance.user.userId) {
                                controller.selectionList
                                    .add(snapshot.data![index]);
                                controller.hasSelectionStarted.value = true;
                              }
                            },
                            onTap: () {
                              if (controller.hasSelectionStarted.value &&
                                  !snapshot.data![index].isDeleted) {
                                if (controller.selectionList.firstWhereOrNull(
                                        (element) =>
                                            element.msgId ==
                                            snapshot.data![index].msgId) !=
                                    null) {
                                  controller.selectionList.value
                                      .remove(snapshot.data![index]);
                                  controller.selectionList.refresh();
                                  if (controller.selectionList.isEmpty) {
                                    controller.hasSelectionStarted.value =
                                        false;
                                  }
                                } else {
                                  if (snapshot.data![index].sentBy ==
                                      AveoChatConfig.instance.user.userId) {
                                    controller.selectionList.value
                                        .add(snapshot.data![index]);
                                    controller.selectionList.refresh();
                                  }
                                }
                              }
                            },
                          ));
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
              controller: controller.messageController,
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
                if (controller.messageController.text.trim().isNotEmpty) {
                  try {
                    String trimmedMsg =
                        controller.messageController.text.trim();
                    controller.messageController.clear();
                    await AveoChatConfig.instance.chatServiceFramework
                        .sendMessageByChatId(
                      chatId: controller.chat.chatId,
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

  @override
  void dispose() {
    Get.delete<ChatRoomController>(force: true);
    super.dispose();
  }
}
