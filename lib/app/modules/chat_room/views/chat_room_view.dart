import 'package:aveochat/app/modules/chat_room/widgets/files_picked.dart';
import 'package:aveochat/aveochat.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_room_controller.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({
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
    var chatroomThemeData =
        AveoChatConfig.instance.aveoChatOptions.chatRoomThemeData;
    return Scaffold(
      backgroundColor: chatroomThemeData.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(controller.chat.chatName),
        backgroundColor:
            chatroomThemeData.chatRoomAppBarThemeData.backgroundColor,
        centerTitle: chatroomThemeData.chatRoomAppBarThemeData.centerTitle,
        elevation: chatroomThemeData.chatRoomAppBarThemeData.elevation,
        foregroundColor:
            chatroomThemeData.chatRoomAppBarThemeData.foregroundColor,
        actions: [
          AveoChatConfig.instance.aveoChatOptions.allowMessageDeletion
              ? Obx(
                  () => controller.hasSelectionStarted.value
                      ? IconButton(
                          onPressed: () async {
                            await controller.deleteSelection();
                          },
                          icon: chatroomThemeData.deleteMessageIcon,
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
                    icon: chatroomThemeData.copyMessageIcon,
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
                            msgType: snapshot.data![index].type,
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
                            receivedMessageTileColor:
                                chatroomThemeData.receivedMessageColor ??
                                    Colors.blueGrey,
                            receivedMessageColor:
                                chatroomThemeData.receivedMessageColor ??
                                    Colors.white,
                            sentMessageColor:
                                chatroomThemeData.sentMessageColor ??
                                    Colors.white,
                            sentMessageTileColor:
                                chatroomThemeData.sentMessageTileColor ??
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
                                  controller.selectionList
                                      .remove(snapshot.data![index]);
                                  controller.selectionList.refresh();
                                  if (controller.selectionList.isEmpty) {
                                    controller.hasSelectionStarted.value =
                                        false;
                                  }
                                } else {
                                  if (snapshot.data![index].sentBy ==
                                      AveoChatConfig.instance.user.userId) {
                                    controller.selectionList
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
                const FilesPicked()
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
            contentPadding: const EdgeInsets.only(left: 12, right: 4),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FilesPickerButton(),
                IconButton(
                  icon: AveoChatConfig
                      .instance.aveoChatOptions.chatRoomThemeData.sendIcon,
                  onPressed: () async {
                    await controller.sendMessage();
                  },
                ),
              ],
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
