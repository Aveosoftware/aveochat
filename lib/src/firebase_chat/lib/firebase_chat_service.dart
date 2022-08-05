part of 'firebase_chat.dart';

abstract class FirebaseChatService {
  /// Access the FirestoreFirebase instance as db. (Similar to FirebaseFirestore.instance)
  FirebaseFirestore db;
  FirebaseChatService(this.db);

  /// Create a user entry in firestore inside users collection.
  Future createUser({required MelosUser user});

  /// Get all the chats for provided unique userId.
  Future<List<ChatRoomModel>> getChatsByUserId({required String uniqueUserId});

  /// Get all the chats for provided unique userId.
  Stream<List<ChatRoomModel>> getChatsStreamByUserId(
      {required String search, required String uniqueUserId});

  /// Get all the conversation between you and other person, using chatId.
  Future<List<Message>> getConversationByChatId(
      {required String chatId, bool descending = false});

  /// Stream all the conversation between you and other person, using chatId.
  Stream<List<Message>> getConversationStreamByChatId(
      {required String chatId, bool descending = false});

  /// Send a message to a chat.
  Future sendMessageByChatId(
      {required String chatId, required Message message});

  /// Retrieve ChatRoom's name from given ChatRoomModel & current user's UserId.
  String getChatRoomName(
      {required ChatRoomModel chat, required String thisUserId});

  /// Start a new Chat from searched list.
  Future<ChatRoomModel> startNewChatRoom(
      {required MelosUser currentUser, required MelosUser otherUser});

  /// [EXPERIMENTAL] Returns a list of Users by providing a search query.
  Future<List<MelosUser>> findUsersBySearchQuery(
      {required String query, required MelosUser user});

  /// Delete the selected messages from the list of given chatId.
  Future<bool> deleteConversation(
      {required String chatId, required List<String> selectedMessageIds});
}
