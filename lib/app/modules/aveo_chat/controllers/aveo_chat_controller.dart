import 'package:aveochat/aveochat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AveoChatController extends GetxController {
  late Stream<List<ChatRoomModel>> chatsStream;
  TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    searchQuery.listen((val) {
      chatsStream = AveoChatConfig.instance.chatServiceFramework
          .getChatsStreamByUserId(
              uniqueUserId: AveoChatConfig.instance.user.userId,
              search: searchQuery.value.trim());
    });

    chatsStream = AveoChatConfig.instance.chatServiceFramework
        .getChatsStreamByUserId(
            uniqueUserId: AveoChatConfig.instance.user.userId,
            search: searchQuery.value.trim());
  }
}
