part of '../aveochat.dart';

/// ChatServices
///
/// List of available chat services provided by Melos Chat Module.
/// * FIREBASE - Chatting service based on firebase firestore as backend.
///
///
///
/// Usage :
/// AveoChatConfig(service: ChatService.FIREBASE)
enum ChatServices {
  FIREBASE,
}

class AveoChatConfig {
  late ChatServices chatService;
  late AveoUser user;
  late FirebaseChatService firebaseChatService;

  // Customisations
  late AveoChatConfigOptions aveoChatOptions;

  AveoChatConfig.internal();
  static final AveoChatConfig instance = AveoChatConfig.internal();

  factory AveoChatConfig({
    required ChatServices service,
    required AveoUser user,
    AveoChatConfigOptions aveoChatOptions = const AveoChatConfigOptions(),
  }) {
    instance.chatService = service;
    instance.user = user;
    instance.aveoChatOptions = aveoChatOptions;
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
