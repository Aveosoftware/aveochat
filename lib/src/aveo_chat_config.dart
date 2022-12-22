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
  /// Select a service to be used for backend.
  late ChatServices chatService;

  /// Defined model of user.
  late AveoUser user;

  /// An abstract class that handles multiple service implementations.
  late ChatServiceFramework chatServiceFramework;
  // Customisations
  late AveoChatConfigOptions aveoChatOptions = const AveoChatConfigOptions();

  // Singleton
  AveoChatConfig.internal();
  static final AveoChatConfig instance = AveoChatConfig.internal();

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
        await instance.chatServiceFramework.createUser(user: instance.user);
    }
  }

  Future<void> initializeService<MM>() async {
    switch (instance.chatService) {
      case ChatServices.FIREBASE:
        instance.chatService = ChatServices.FIREBASE;
        instance.chatServiceFramework =
            FirebaseChatService(FirebaseFirestore.instance);
    }
  }
}
