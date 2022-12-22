part of '../../../../aveochat.dart';

class AveoChat extends GetView {
  AveoChat({Key? key}) : super(key: key);

  @override
  final AveoChatController controller = Get.put(AveoChatController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          onPanUpdate: (details) {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: Container(
            color: AveoChatConfig.instance.aveoChatOptions.backgroundColor,
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SearchBox(),
                  Obx(
                    () {
                      log(controller.searchQuery.value);
                      return StreamBuilder(
                        stream: controller.chatsStream,
                        builder: (context,
                            AsyncSnapshot<List<ChatRoomModel>> snapshot) {
                          // WHEN LOADING
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: ChatShimmer(),
                            );
                          }

                          // WHEN DATA IS LOADED
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              primary: false,
                              itemBuilder: (context, index) {
                                return ChatTile(
                                  chat: snapshot.data![index],
                                );
                              },
                            );
                          }

                          // WHEN DATA IS LOADED BUT EMPTY
                          if (snapshot.hasData &&
                              snapshot.data!.isEmpty &&
                              controller.searchQuery.value.isEmpty) {
                            return const NoChatsAvailable();
                          }

                          // WHEN DATA IS LOADED & DATA IS EMPTY & SEARCH IS NOT EMPTY
                          return FutureBuilder(
                            future: AveoChatConfig.instance.chatServiceFramework
                                .findUsersBySearchQuery(
                                    query: controller.searchQuery.value,
                                    user: AveoChatConfig.instance.user),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (controller.searchQuery.value
                                    .trim()
                                    .isNotEmpty) {
                                  if (snapshot.data.isEmpty) {
                                    return const Center(
                                      heightFactor: 10,
                                      child: Text("No user found."),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          'Other Contacts',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      ...List.generate(
                                        snapshot.data.length,
                                        (index) => ListTile(
                                          onTap: () async {
                                            try {
                                              ChatRoomModel chatRoom =
                                                  await AveoChatConfig.instance
                                                      .chatServiceFramework
                                                      .startNewChatRoom(
                                                          currentUser:
                                                              AveoChatConfig
                                                                  .instance
                                                                  .user,
                                                          otherUser: snapshot
                                                              .data[index]);
                                              controller.searchController
                                                  .clear();
                                              controller.searchQuery.value = '';

                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatRoomView(
                                                  chat: chatRoom,
                                                ),
                                              ));
                                            } catch (e, s) {
                                              log(s.toString());
                                            }
                                          },
                                          title: Text(
                                              snapshot.data[index].displayName),
                                        ),
                                      ).toList()
                                    ],
                                  );
                                } else {
                                  return Container();
                                }
                              }
                              return const Center(
                                child: ChatShimmer(),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
