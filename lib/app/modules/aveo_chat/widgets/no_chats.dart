import 'package:flutter/material.dart';

class NoChatsAvailable extends StatelessWidget {
  const NoChatsAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      heightFactor: 8,
      child: Text("Search for people & get started chatting."),
    );
  }
}
