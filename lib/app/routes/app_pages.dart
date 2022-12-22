import 'package:get/get.dart';

import '../../aveochat.dart';
import '../modules/aveo_chat/bindings/aveo_chat_binding.dart';
import '../modules/chat_room/bindings/chat_room_binding.dart';
import '../modules/chat_room/views/chat_room_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.AVEO_CHAT;

  static final routes = [
    GetPage(
      name: _Paths.AVEO_CHAT,
      page: () => AveoChat(),
      binding: AveoChatBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_ROOM,
      page: () => const ChatRoomView(),
      binding: ChatRoomBinding(),
    ),
  ];
}
