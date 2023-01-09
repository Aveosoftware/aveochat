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
