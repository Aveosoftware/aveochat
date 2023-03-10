import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ChatShimmer extends StatelessWidget {
  const ChatShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...List.generate(
              16,
              (index) => ListTile(
                leading: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: const CircleAvatar(),
                ),
                title: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Get.width,
                        height: 12,
                        color: Colors.red,
                        child: Container(),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        width: Get.width * 0.6,
                        height: 8,
                        color: Colors.red,
                        child: Container(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ).toList()
          ],
        ),
      ),
    );
  }
}
