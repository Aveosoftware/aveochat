part of 'firebase_chat.dart';

class FirebaseChatServiceImpl extends FirebaseChatService {
  FirebaseChatServiceImpl(super.db);

  @override
  Future<List<ChatRoomModel>> getChatsByUserId(
      {required String uniqueUserId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await db.collection(Collections.USERS).doc(uniqueUserId).get();
    List<ChatRoomModel> chats = [];
    try {
      if (snap.data()!['chats'] != null) {
        for (String chat in snap.get('chats')) {
          var data = await db.collection(Collections.CHATROOMS).doc(chat).get();
          chats.add(ChatRoomModel.fromMap(data.data()!));
        }
      }
    } catch (e, s) {
      if (kDebugMode) {
        print(s);
      }
      return chats;
    }
    return chats;
  }

  @override
  Stream<List<ChatRoomModel>> getChatsStreamByUserId(
      {required String search, required String uniqueUserId}) async* {
    StreamController<List<ChatRoomModel>> stream =
        StreamController<List<ChatRoomModel>>();
    List<ChatRoomModel> chats = [];
    try {
      var data = db
          .collection(Collections.USERS)
          .doc(uniqueUserId)
          .snapshots()
          .map((event) =>
              event.data() != null ? MelosUser.fromMap(event.data()!) : null);

      data.listen((event) async {
        if (event?.chats != null) {
          chats = [];
          for (String chat in event!.chats!) {
            var data =
                await db.collection(Collections.CHATROOMS).doc(chat).get();
            var chatRoom = ChatRoomModel.fromMap(data.data()!);
            if (chatRoom.participants.firstWhereOrNull((element) => element
                    .displayName
                    .toLowerCase()
                    .contains(search.toLowerCase())) !=
                null) chats.add(chatRoom);
          }
          stream.add(chats);
        }
      });
    } catch (e, s) {
      print(s);
    }

    yield* stream.stream;
  }

  @override
  Future<List<Message>> getConversationByChatId(
      {required String chatId, bool descending = false}) async {
    QuerySnapshot<Map<String, dynamic>> snap = await db
        .collection(Collections.CHATROOMS)
        .doc(chatId)
        .collection(Collections.CONVERSATIONS)
        .orderBy("timestamp", descending: descending)
        .get();
    List<Message> conversation = [];
    try {
      for (var data in snap.docs) {
        conversation.add(Message.fromMap(data.data()));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return conversation;
    }
    return conversation;
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>?> sendMessageByChatId(
      {required String chatId, required Message message}) async {
    late DocumentReference<Map<String, dynamic>>? doc;
    try {
      doc = await db
          .collection(Collections.CHATROOMS)
          .doc(chatId)
          .collection(Collections.CONVERSATIONS)
          .add(message.toMap());
      await doc.update({'msgId': doc.id});
    } on Exception catch (e, s) {
      if (kDebugMode) {
        print(s);
      }
    }
    return doc;
  }

  @override
  Future createUser({required MelosUser user}) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await db.collection(Collections.USERS).doc(user.userId).get();
    if (doc.exists) {
      return db.collection(Collections.USERS).doc(user.userId).update({
        'userId': user.userId,
        'displayName': user.displayName,
      });
    }
    return db.collection(Collections.USERS).doc(user.userId).set(user.toMap());
  }

  @override
  Stream<List<Message>> getConversationStreamByChatIdForUserId({
    required String chatId,
    required String userId,
    bool descending = false,
  }) async* {
    yield* db
        .collection(Collections.CHATROOMS)
        .doc(chatId)
        .collection(Collections.CONVERSATIONS)
        .orderBy("timestamp", descending: descending)
        .snapshots()
        .map((querySnapshot) {
      // readTheMessages(chatId, userId);
      return querySnapshot.docs.map((e) {
        if (Message.fromMap(e.data()).sentBy == userId &&
            Message.fromMap(e.data()).readStatus == ReadStatus.DELIVERED) {
          e.reference.update({'readStatus': ReadStatus.READ});
        }
        return Message.fromMap(e.data());
      }).toList();
    });
  }

  @override
  String getChatRoomName(
      {required ChatRoomModel chat, required String thisUserId}) {
    if (chat.participants.length == 2) {
      return chat.participants
          .firstWhere((element) => element.userId != thisUserId)
          .displayName;
    }
    return chat.chatName;
  }

  @override
  Future<ChatRoomModel> startNewChatRoom(
      {required MelosUser currentUser, required MelosUser otherUser}) async {
    late ChatRoomModel newCreatedChat;
    try {
      MelosUser myUser = MelosUser.fromMap(
          (await db.collection(Collections.USERS).doc(currentUser.userId).get())
              .data()!);
      if (myUser.chats != null && myUser.chats!.isNotEmpty) {
        for (var chatRoomId in myUser.chats!) {
          ChatRoomModel snap = ChatRoomModel.fromMap(
              (await db.collection(Collections.CHATROOMS).doc(chatRoomId).get())
                  .data()!);
          List<MelosUser?>? users = snap.participants;
          if (snap.participants.length == 2 &&
              users.firstWhereOrNull(
                      (element) => element!.userId == otherUser.userId) !=
                  null) {
            newCreatedChat = snap;
            return newCreatedChat;
          }
        }
      }

      var docRef = await db.collection(Collections.CHATROOMS).add(
            ChatRoomModel(
                    chatId: "",
                    participants: [
                      MelosUser(
                          userId: currentUser.userId,
                          displayName: currentUser.displayName),
                      MelosUser(
                          userId: otherUser.userId,
                          displayName: otherUser.displayName),
                    ],
                    chatName: "")
                .toMap(),
          );
      await docRef.update({"chatId": docRef.id});
      var thisUser =
          await db.collection(Collections.USERS).doc(currentUser.userId).get();
      MelosUser user = MelosUser.fromMap(thisUser.data()!);
      user.chats!.add(docRef.id);
      thisUser.reference.update({'chats': user.chats});

      var thatUser =
          await db.collection(Collections.USERS).doc(otherUser.userId).get();
      user = MelosUser.fromMap(thatUser.data()!);
      user.chats!.add(docRef.id);
      thatUser.reference.update({'chats': user.chats});

      newCreatedChat = ChatRoomModel.fromMap((await docRef.get()).data()!);
    } catch (e, s) {
      print(s);
    }
    return newCreatedChat;
  }

  @override
  Future<List<MelosUser>> findUsersBySearchQuery(
      {required String query, required MelosUser user}) async {
    final List<MelosUser> suggestions = [];
    try {
      QuerySnapshot<Map<String, dynamic>> data = await db
          .collection(Collections.USERS)
          .orderBy('displayName')
          .startAt([query.toUpperCase()]).endAt(
              ['${query.toLowerCase()}\uf8ff']).get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in data.docs) {
        if (MelosUser.fromMap(doc.data()).userId != user.userId) {
          suggestions.add(MelosUser.fromMap(doc.data()));
        }
      }
    } catch (e, s) {
      print(s);
    }
    return suggestions;
  }

  @override
  Future<bool> deleteConversation({
    required String chatId,
    required List<String> selectedMessageIds,
  }) async {
    try {
      for (String id in selectedMessageIds) {
        await db
            .collection(Collections.CHATROOMS)
            .doc(chatId)
            .collection(Collections.CONVERSATIONS)
            .doc(id)
            .update({'isDeleted': true});
      }
    } catch (e) {
      return false;
    }
    return true;
  }
}
