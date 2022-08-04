part of '../firebase_chat.dart';

class Message {
  String msgId;
  String message;
  String sentBy;
  String timestamp;
  bool isDeleted;

  Message({
    this.msgId = '',
    required this.message,
    required this.sentBy,
    required this.timestamp,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'msgId': msgId,
      'message': message,
      'sent_by': sentBy,
      'timestamp': timestamp,
      'isDeleted': isDeleted,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      msgId: map['msgId'] as String,
      message: map['message'] as String,
      sentBy: map['sent_by'] as String,
      timestamp: map['timestamp'] as String,
      isDeleted: map['isDeleted'] as bool,
    );
  }
}
