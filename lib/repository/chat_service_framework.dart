part of '../../aveochat.dart';

abstract class ChatServiceFramework {
  /// Create a user entry in firestore inside users collection.
  Future createUser({required AveoUser user});

  /// Get all the chats for provided unique userId.
  Future<List<ChatRoomModel>> getChatsByUserId({required String uniqueUserId});

  /// Get all the chats for provided unique userId.
  Stream<List<ChatRoomModel>> getChatsStreamByUserId(
      {required String search, required String uniqueUserId});

  /// Get all the conversation between you and other person, using chatId.
  Future<List<Message>> getConversationByChatId(
      {required String chatId, bool descending = false});

  /// Stream all the conversation between you and other person, using chatId.
  Stream<List<Message>> getConversationStreamByChatIdForUserId({
    required String chatId,
    required String userId,
    bool descending = false,
  });

  /// Send a message to a chat.
  Future sendMessageByChatId(
      {required String chatId, required Message message});

  /// Retrieve ChatRoom's name from given ChatRoomModel & current user's UserId.
  String getChatRoomName(
      {required ChatRoomModel chat, required String thisUserId});

  /// Start a new Chat from searched list.
  Future<ChatRoomModel> startNewChatRoom(
      {required AveoUser currentUser, required AveoUser otherUser});

  /// [EXPERIMENTAL] Returns a list of Users by providing a search query.
  Future<List<AveoUser>> findUsersBySearchQuery(
      {required String query, required AveoUser user});

  /// Delete the selected messages from the list of given chatId.
  Future<bool> deleteConversation(
      {required String chatId, required List<String> selectedMessageIds});
}
