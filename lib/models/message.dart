part of '../aveochat.dart';

class Message {
  String msgId;
  String message;
  String type;
  String sentBy;
  String timestamp;
  bool isDeleted;
  int readStatus;

  Message({
    this.msgId = '',
    required this.message,
    required this.sentBy,
    required this.type,
    required this.timestamp,
    this.isDeleted = false,
    this.readStatus = ReadStatus.DELIVERED,
  });

  Map<String, dynamic> toMap() {
    return {
      'msgId': msgId,
      'message': message,
      'type': type,
      'sent_by': sentBy,
      'timestamp': timestamp,
      'isDeleted': isDeleted,
      'readStatus': readStatus,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      msgId: map.containsKey('msgId') ? map['msgId'] as String : '',
      message: map.containsKey('message') ? map['message'] as String : '',
      type: map.containsKey('type') ? map['type'] as String : 'text',
      sentBy: map.containsKey('sent_by') ? map['sent_by'] as String : '',
      timestamp: map.containsKey('timestamp') ? map['timestamp'] as String : '',
      isDeleted:
          map.containsKey('isDeleted') ? map['isDeleted'] as bool : false,
      readStatus: map.containsKey('readStatus') ? map['readStatus'] as int : 0,
    );
  }
}
