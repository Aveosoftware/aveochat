import 'package:animations/animations.dart';
import 'package:aveochat/aveochat.dart';
import 'package:aveochat/core/image_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageMessageBubble extends StatefulWidget {
  final String message;
  final String caption;
  final bool isMessageSent;
  final Color sentMessageColor;
  final Color receivedMessageColor;
  const ImageMessageBubble({
    Key? key,
    required this.message,
    required this.caption,
    required this.isMessageSent,
    required this.receivedMessageColor,
    required this.sentMessageColor,
  }) : super(key: key);

  @override
  State<ImageMessageBubble> createState() => _ImageMessageBubbleState();
}

class _ImageMessageBubbleState extends State<ImageMessageBubble>
    with AutomaticKeepAliveClientMixin {
  ImageMessageBubbleThemeData imageMessageBubbleThemeData = AveoChatConfig
      .instance.aveoChatOptions.chatRoomThemeData.imageMessageBubbleThemeData;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: widget.isMessageSent
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: 140,
            padding: const EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0),
            child: Visibility(
              visible: widget.message.isNotEmpty,
              replacement: const Center(
                child: CupertinoActivityIndicator(),
              ),
              child: OpenContainer(
                tappable: false,
                openColor: Colors.black,
                closedColor: Colors.transparent,
                middleColor: Colors.black,
                transitionType: ContainerTransitionType.fadeThrough,
                closedBuilder: (context, openAction) => GestureDetector(
                  onTap: openAction,
                  child: CachedNetworkImage(
                    imageUrl: widget.message,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(14),
                            topRight: const Radius.circular(14),
                            bottomRight: widget.isMessageSent
                                ? Radius.zero
                                : const Radius.circular(14),
                            bottomLeft: widget.isMessageSent
                                ? const Radius.circular(14)
                                : Radius.zero,
                          ),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    },
                  ),
                ),
                openBuilder: (context, closeAction) => ImageViewer(
                    tag: widget.message,
                    url: widget.message,
                    closeAction: closeAction),
              ),
            ),
          ),
          widget.caption.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    widget.caption,
                    // textAlign: isMessageSent ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                      color: widget.isMessageSent
                          ? widget.sentMessageColor
                          : widget.receivedMessageColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive =>
      imageMessageBubbleThemeData.keepImageAliveWhenScrolled;
}
