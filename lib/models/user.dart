part of '../../../aveochat.dart';

class AveoUser {
  String userId;
  String displayName;
  int? timestamp;
  List<String>? chats;

  AveoUser({
    required this.userId,
    required this.displayName,
    this.timestamp,
    this.chats = const [],
  }) {
    timestamp = DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName.toLowerCase(),
      'timestamp': timestamp,
      'chats': chats,
    };
  }

  factory AveoUser.fromMap(Map<String, dynamic> map) {
    List<String> chats = [];
    if (map.containsKey('chats')) {
      for (var item in map['chats']) {
        chats.add(item.toString());
      }
    }
    return AveoUser(
      userId: map['userId'] as String,
      displayName: map['displayName'].toString().toTitleCase(),
      timestamp: map.containsKey('timestamp') ? map['timestamp'] as int : null,
      chats: chats,
    );
  }
}
