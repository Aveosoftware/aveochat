part of '../../aveochat.dart';

class AveoChat extends StatefulWidget {
  const AveoChat({Key? key, required BuildContext context}) : super(key: key);

  @override
  State<AveoChat> createState() => _AveoChatState();
}

PageController pageController = PageController(keepPage: true);

ChatRoomModel chatObject =
    ChatRoomModel(chatId: 'chatId', participants: [], chatName: '');

class _AveoChatState extends State<AveoChat> {
  // late Stream<List<ChatRoomModel>> chatsStream;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    loadStream();
    searchController.addListener(() {
      loadStream();
      searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: searchController.text.length));
    });
    super.initState();
  }

  loadStream() {
    // chatsStream = AveoChatConfig.instance.firebaseChatService
    //     .getChatsStreamByUserId(
    //         uniqueUserId: AveoChatConfig.instance.user.userId,
    //         search: searchController.text.trim());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      children: [
        KeepAlivePage(
            child:
                ChatList(searchController: searchController, mounted: mounted)),
        ChatRoom(
          chat: chatObject,
        )
      ],
    );
  }
}

class ChatList extends StatelessWidget {
  const ChatList({
    Key? key,
    required this.searchController,
    required this.mounted,
  }) : super(key: key);

  final TextEditingController searchController;
  final bool mounted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AveoChat'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Container(
            color: AveoChatConfig.instance.aveoChatOptions.backgroundColor,
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SearchBox(
                    context,
                    searchController,
                    clearSearch: () {
                      searchController.text = '';
                    },
                    allowUserSearch:
                        AveoChatConfig.instance.aveoChatOptions.allowUserSearch,
                    searchHint:
                        AveoChatConfig.instance.aveoChatOptions.searchHint,
                  ),
                  StreamBuilder(
                    stream: AveoChatConfig.instance.firebaseChatService
                        .getChatsStreamByUserId(
                            uniqueUserId: AveoChatConfig.instance.user.userId,
                            search: searchController.text.trim()),
                    builder:
                        (context, AsyncSnapshot<List<ChatRoomModel>> snapshot) {
                      // WHEN LOADING
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: ChatShimmer(context: context),
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
                              context,
                              chatName: AveoChatConfig
                                  .instance.firebaseChatService
                                  .getChatRoomName(
                                      chat: snapshot.data![index],
                                      thisUserId:
                                          AveoChatConfig.instance.user.userId),
                              chatTileColor: AveoChatConfig
                                  .instance.aveoChatOptions.chatTileColor,
                              avatarBackgroundColor: AveoChatConfig.instance
                                  .aveoChatOptions.avatarBackgroundColor,
                              chat: snapshot.data![index],
                            );
                          },
                        );
                      }

                      if (snapshot.hasData &&
                          snapshot.data!.isEmpty &&
                          searchController.text.isEmpty)
                      // IF NO DATA IS AVAILABLE
                      {
                        return const Center(
                          heightFactor: 8,
                          child:
                              Text("Search for people & get started chatting."),
                        );
                      }

                      return FutureBuilder(
                        future: AveoChatConfig.instance.firebaseChatService
                            .findUsersBySearchQuery(
                                query: searchController.text.trim(),
                                user: AveoChatConfig.instance.user),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (searchController.text.trim().isNotEmpty) {
                              if (snapshot.data.isEmpty) {
                                return const Center(
                                  child: Text("No user found."),
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              await AveoChatConfig
                                                  .instance.firebaseChatService
                                                  .startNewChatRoom(
                                                      currentUser:
                                                          AveoChatConfig
                                                              .instance.user,
                                                      otherUser:
                                                          snapshot.data[index]);
                                          searchController.text = '';
                                          if (mounted) {
                                            // pageController.nextPage(
                                            //     duration: const Duration(
                                            //         milliseconds: 400),
                                            //     curve: Curves.linear);
                                            // Navigator.of(context)
                                            //     .push(MaterialPageRoute(
                                            //   builder: (context) => ChatRoom(
                                            //     chat: chatRoom,
                                            //   ),
                                            // ));

                                          }
                                        } catch (e, s) {
                                          print(s);
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
                          return Center(
                              child: ChatShimmer(
                            context: context,
                          ));
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

class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
