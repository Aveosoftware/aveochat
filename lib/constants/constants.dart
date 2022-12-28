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

class PickedFile {
  final String msgType;
  String fileName;
  String caption;
  final String pathOrUrl;

  PickedFile({
    required this.msgType,
    required this.fileName,
    this.caption = '',
    required this.pathOrUrl,
  });
}

class StorageRef {
  static Reference get getImageRef =>
      FirebaseStorage.instance.ref().child('image');
  static Reference get getVideoRef =>
      FirebaseStorage.instance.ref().child('video');
  static Reference get getAudioRef =>
      FirebaseStorage.instance.ref().child('audio');
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
