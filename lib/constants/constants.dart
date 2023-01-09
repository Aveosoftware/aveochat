// ignore_for_file: constant_identifier_names

part of '../aveochat.dart';

// List of Collections that are being used in Firebase Service.
class Collections {
  static const USERS = 'users';
  static const CHATROOMS = 'chatrooms';
  static const CONVERSATIONS = 'conversation';
}

class ReadStatus {
  static const SENT = -1;
  static const DELIVERED = 0;
  static const READ = 1;
}

class MsgType {
  static const text = 'text';
  static const image = 'image';
  static const video = 'video';
  static const audio = 'audio';
}

class StorageRef {
  static Reference get getImageRef => FirebaseStorage.instance
      .ref()
      .child('users')
      .child(AveoChatConfig.instance.user.userId)
      .child('image');
  static Reference get getVideoRef => FirebaseStorage.instance
      .ref()
      .child('users')
      .child(AveoChatConfig.instance.user.userId)
      .child('video');
  static Reference get getAudioRef => FirebaseStorage.instance
      .ref()
      .child('users')
      .child(AveoChatConfig.instance.user.userId)
      .child('audio');

  static getRefByMsgTyoe(String msgType) {
    switch (msgType) {
      case MsgType.image:
        return getImageRef;
      case MsgType.audio:
        return getAudioRef;
      case MsgType.video:
        return getVideoRef;
      default:
    }
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
