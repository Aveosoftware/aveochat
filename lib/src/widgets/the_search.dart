import 'package:aveochat/aveochat.dart';
import 'package:flutter/material.dart';

class TheSearch extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: AveoChatConfig.instance.firebaseChatService
          .findUsersBySearchQuery(
              query: query, user: AveoChatConfig.instance.user),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (query.isNotEmpty) {
            if (snapshot.data.isEmpty) {
              return const Center(
                child: Text("No user found."),
              );
            }
            return Column(
              children: [
                ...List.generate(
                  snapshot.data.length,
                  (index) => ListTile(
                    onTap: () async {
                      try {
                        ChatRoomModel chatRoom = await AveoChatConfig
                            .instance.firebaseChatService
                            .startNewChatRoom(
                          currentUser: AveoChatConfig.instance.user,
                          otherUser: snapshot.data[index],
                        );
                        Navigator.of(context).push(MaterialPageRoute(
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
