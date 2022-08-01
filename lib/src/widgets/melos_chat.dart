part of '../../melos_chat.dart';

Widget MelosChatScreen(
  BuildContext context,
) {
  return LayoutBuilder(
    builder: (context, constraints) => Container(
      color: MelosChat.instance.melosChatThemeData.backgroundColor,
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: SingleChildScrollView(
        primary: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SearchBox(
              context,
              allowUserSearch:
                  MelosChat.instance.melosChatThemeData.allowUserSearch,
              searchHint: MelosChat.instance.melosChatThemeData.searchHint,
            ),
            StreamBuilder(
              stream: MelosChat.instance.firebaseChatService
                  .getChatsStreamByUserId(
                      uniqueUserId: MelosChat.instance.user.userId),
              builder: (context, AsyncSnapshot<List<ChatRoomModel>> snapshot) {
                // WHEN LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    heightFactor: 8,
                    child: CircularProgressIndicator(),
                  );
                }
                // WHEN DATA IS LOADED
                if (snapshot.hasData) {
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
                            MelosChat.instance.melosChatThemeData.chatTileColor,
                        avatarBackgroundColor: MelosChat
                            .instance.melosChatThemeData.avatarBackgroundColor,
                        chat: snapshot.data![index],
                      );
                    },
                  );
                }
                // IF NO DATA IS AVAILABLE
                return const Center(
                  heightFactor: 8,
                  child: Text("Search for people & get started chatting."),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
