part of '../../melos_chat.dart';

Widget MelosChatScreen(
  BuildContext context,
) {
  return LayoutBuilder(
    builder: (context, constraints) => Container(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: SingleChildScrollView(
        primary: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16.0, left: 16.0),
                  hintText: 'Search',
                  filled: true,
                  suffixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(54.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () async {
                  await showSearch(
                    context: context,
                    delegate: TheSearch(),
                    query: "",
                  );
                },
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            StreamBuilder(
              stream: MelosChat.instance.firebaseChatService
                  .getChatsStreamByUserId(
                      uniqueUserId: MelosChat.instance.user.userId),
              builder: (context, AsyncSnapshot<List<ChatRoomModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      String chatName = MelosChat.instance.firebaseChatService
                          .getChatRoomName(
                              chat: snapshot.data![index],
                              thisUserId: MelosChat.instance.user.userId);
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ChatRoom(chat: snapshot.data![index]),
                          ));
                        },
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(chatName[0].toUpperCase()),
                        ),
                        title: Text(chatName.toTitleCase()),
                      );
                    },
                  );
                }
                return const Center(
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
