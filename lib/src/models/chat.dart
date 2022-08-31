part of '../../../aveochat.dart';

class ChatRoomModel {
  String chatId;
  List<AveoUser> participants;
  String chatName;

  ChatRoomModel({
    required this.chatId,
    required this.participants,
    required this.chatName,
  });

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> data = [];
    for (var user in participants) {
      data.add({"userId": user.userId, "displayName": user.displayName});
    }
    return {
      'chatId': chatId,
      'participants': data,
      'chatName': chatName,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    List<AveoUser> participants = [];
    for (var item in map['participants']) {
      participants.add(AveoUser.fromMap(item));
    }

    return ChatRoomModel(
      chatId: map['chatId'],
      participants: participants,
      chatName: map['chatName'],
    );
  }
}
