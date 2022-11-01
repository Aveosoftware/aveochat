part of '../aveochat.dart';

/// ChatServices
///
/// List of available chat services provided by Aveo Chat Module.
/// * FIREBASE - Chatting service based on firebase firestore as backend.
///
///
///
/// Usage :
/// AveoChatConfig(...).getService(ChatService.FIREBASE)
enum ChatServices {
  FIREBASE,
}

class AveoChatConfig {
  late ChatServices chatService;
  late AveoUser user;
  late FirebaseChatService firebaseChatService;

  // Customisations
  late AveoChatConfigOptions aveoChatOptions = const AveoChatConfigOptions();

  AveoChatConfig.internal();
  static final AveoChatConfig instance = AveoChatConfig.internal();

  // factory AveoChatConfig.init({
  //   required AveoUser user,
  // }) {
  //   instance.user = user;
  //   return instance;
  // }

  void setAveoChatConfigOptions({
    required ChatServices chatService,
    required AveoChatConfigOptions aveoChatConfigOptions,
  }) {
    instance.chatService = chatService;
    initializeService();
    instance.aveoChatOptions = aveoChatConfigOptions;
  }

  Future<void> setUser({required AveoUser aveoUser}) async {
    instance.user = aveoUser;
    switch (instance.chatService) {
      case ChatServices.FIREBASE:
        await instance.firebaseChatService.createUser(user: instance.user);
    }
  }

  Future<void> initializeService<MM>() async {
    switch (instance.chatService) {
      case ChatServices.FIREBASE:
        instance.chatService = ChatServices.FIREBASE;
        instance.firebaseChatService =
            FirebaseChatServiceImpl(FirebaseFirestore.instance);
        await instance.firebaseChatService.createUser(user: instance.user);
    }
  }
}
