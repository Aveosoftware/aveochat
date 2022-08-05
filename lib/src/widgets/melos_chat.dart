part of '../../melos_chat.dart';

class MelosChatScreen extends StatefulWidget {
  const MelosChatScreen({Key? key, required BuildContext context})
      : super(key: key);

  @override
  State<MelosChatScreen> createState() => _MelosChatScreenState();
}

class _MelosChatScreenState extends State<MelosChatScreen> {
  late Stream<List<ChatRoomModel>> chatsStream;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    loadStream();
    searchController.addListener(() {
      loadStream();
      searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: searchController.text.length));
      setState(() {});
    });
    super.initState();
  }

  loadStream() {
    chatsStream = MelosChat.instance.firebaseChatService.getChatsStreamByUserId(
        uniqueUserId: MelosChat.instance.user.userId,
        search: searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        color: MelosChat.instance.melosChatOptions.backgroundColor,
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
                    MelosChat.instance.melosChatOptions.allowUserSearch,
                searchHint: MelosChat.instance.melosChatOptions.searchHint,
              ),
              StreamBuilder(
                stream: chatsStream,
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
                        return MelosChatTile(
                          context,
                          chatName: MelosChat.instance.firebaseChatService
                              .getChatRoomName(
                                  chat: snapshot.data![index],
                                  thisUserId: MelosChat.instance.user.userId),
                          chatTileColor:
                              MelosChat.instance.melosChatOptions.chatTileColor,
                          avatarBackgroundColor: MelosChat
                              .instance.melosChatOptions.avatarBackgroundColor,
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
                      child: Text("Search for people & get started chatting."),
                    );
                  }

                  return FutureBuilder(
                    future: MelosChat.instance.firebaseChatService
                        .findUsersBySearchQuery(
                            query: searchController.text.trim(),
                            user: MelosChat.instance.user),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
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
                                      ChatRoomModel chatRoom = await MelosChat
                                          .instance.firebaseChatService
                                          .startNewChatRoom(
                                              currentUser:
                                                  MelosChat.instance.user,
                                              otherUser: snapshot.data[index]);
                                      searchController.text = '';
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ChatRoom(
                                          chat: chatRoom,
                                        ),
                                      ));
                                    } catch (e, s) {
                                      print(s);
                                    }
                                  },
                                  title: Text(snapshot.data[index].displayName),
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
    );
  }
}
