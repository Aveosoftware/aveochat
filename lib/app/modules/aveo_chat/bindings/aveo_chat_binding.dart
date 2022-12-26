import 'package:get/get.dart';

import '../controllers/aveo_chat_controller.dart';

class AveoChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AveoChatController>(
      () => AveoChatController(),
    );
  }
}
