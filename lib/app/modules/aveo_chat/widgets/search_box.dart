import 'package:aveochat/app/modules/aveo_chat/controllers/aveo_chat_controller.dart';
import 'package:aveochat/aveochat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBox extends GetView<AveoChatController> {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: AveoChatConfig.instance.aveoChatOptions.allowUserSearch,
        child: Column(
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
              child: TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16.0, left: 16.0),
                  hintText: AveoChatConfig.instance.aveoChatOptions.searchHint,
                  filled: true,
                  suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            controller.searchController.clear();
                            controller.searchQuery.value = '';
                          },
                        )
                      : const Icon(Icons.search, color: Colors.grey)),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(54.0),
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  controller.searchQuery.value = value;
                },
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
          ],
        ));
  }
}
