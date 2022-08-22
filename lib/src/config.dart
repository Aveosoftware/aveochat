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

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
