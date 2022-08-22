part of '../aveochat.dart';

/// ChatServices
///
/// List of available chat services provided by Melos Chat Module.
/// * FIREBASE - Chatting service based on firebase firestore as backend.
///
///
///
/// Usage :
/// MelosChat(service: ChatService.FIREBASE)
enum ChatServices {
  FIREBASE,
}

class MelosChat {
  late ChatServices chatService;
  late MelosUser user;
  late FirebaseChatService firebaseChatService;

  // Customisations
  late MelosChatOptions melosChatOptions;

  MelosChat.internal();
  static final MelosChat instance = MelosChat.internal();

  factory MelosChat({
    required ChatServices service,
    required MelosUser user,
    MelosChatOptions melosChatOptions = const MelosChatOptions(),
  }) {
    instance.chatService = service;
    instance.user = user;
    instance.melosChatOptions = melosChatOptions;
    return instance;
  }

  Future<MM> getService<MM>() async {
    switch (instance.chatService) {
      case ChatServices.FIREBASE:
        // call firebase
        instance.firebaseChatService =
            FirebaseChatServiceImpl(FirebaseFirestore.instance);
        instance.firebaseChatService.createUser(user: instance.user);
        MM obj = instance.firebaseChatService as MM;
        return obj;
    }
  }
}
