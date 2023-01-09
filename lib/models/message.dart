part of '../aveochat.dart';

class Message {
  String msgId;
  String message;
  String caption;
  String type;
  String sentBy;
  String timestamp;
  bool isDeleted;
  int readStatus;

  Message({
    this.msgId = '',
    required this.message,
    this.caption = '',
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
      'caption': caption,
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
      caption: map.containsKey('caption') ? map['caption'] as String : '',
      type: map.containsKey('type') ? map['type'] as String : 'text',
      sentBy: map.containsKey('sent_by') ? map['sent_by'] as String : '',
      timestamp: map.containsKey('timestamp') ? map['timestamp'] as String : '',
      isDeleted:
          map.containsKey('isDeleted') ? map['isDeleted'] as bool : false,
      readStatus: map.containsKey('readStatus') ? map['readStatus'] as int : 0,
    );
  }
}

class MessageUpdate {
  String message;
  String caption;
  String type;

  MessageUpdate({
    required this.message,
    this.caption = '',
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'caption': caption,
      'type': type,
    };
  }

  factory MessageUpdate.fromMap(Map<String, dynamic> map) {
    return MessageUpdate(
      message: map.containsKey('message') ? map['message'] as String : '',
      caption: map.containsKey('caption') ? map['caption'] as String : '',
      type: map.containsKey('type') ? map['type'] as String : 'text',
    );
  }
}
