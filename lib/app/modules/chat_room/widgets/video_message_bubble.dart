import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:aveochat/aveochat.dart';
import 'package:aveochat/core/image_viewer.dart';
import 'package:aveoplayer/aveoplayer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoMessageBubble extends StatefulWidget {
  final String message;
  final String caption;
  final bool isMessageSent;
  final Color sentMessageColor;
  final Color receivedMessageColor;
  const VideoMessageBubble({
    Key? key,
    required this.message,
    required this.caption,
    required this.isMessageSent,
    required this.receivedMessageColor,
    required this.sentMessageColor,
  }) : super(key: key);

  @override
  State<VideoMessageBubble> createState() => _VideoMessageBubbleState();
}

class _VideoMessageBubbleState extends State<VideoMessageBubble>
    with AutomaticKeepAliveClientMixin {
  ImageMessageBubbleThemeData imageMessageBubbleThemeData = AveoChatConfig
      .instance.aveoChatOptions.chatRoomThemeData.imageMessageBubbleThemeData;
  Completer<String?> filePath = Completer();

  getVideoFile() async {
    var _filePath = VideoThumbnail.thumbnailFile(
      video: widget.message,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      // maxWidth:
      //     128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      // quality: 80,
    );
    filePath.complete(_filePath);
  }

  @override
  void initState() {
    getVideoFile();
    super.initState();
  }

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
              child:
                  //  OpenContainer(
                  //     tappable: false,
                  //     openColor: Colors.black,
                  //     closedColor: Colors.transparent,
                  //     middleColor: Colors.black,
                  //     transitionType: ContainerTransitionType.fadeThrough,
                  //     closedBuilder: (context, openAction) =>
                  GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) => AveoVideoPlayer.network(
                        uri: widget.message,
                        autoplay: true,
                        topActions: (videoplayerController) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if ((videoplayerController
                                          ?.isFullScreen.value) ??
                                      false) {
                                    videoplayerController
                                        ?.toggleFullScreen(context);
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                        builder: (context, player, videoPlayerController) {
                          return Scaffold(
                            backgroundColor: Colors.black,
                            body: GestureDetector(
                              onVerticalDragUpdate: (details) {
                                int sensitivity = 8;
                                if (details.delta.dy > sensitivity ||
                                    details.delta.dy < -sensitivity) {
                                  Navigator.pop(context);
                                }
                              },
                              child: Center(
                                  child: AspectRatio(
                                      aspectRatio: videoPlayerController
                                          .value.aspectRatio,
                                      child: Hero(
                                          tag: widget.message, child: player))),
                            ),
                          );
                        }))),
                child: FutureBuilder<String?>(
                    future: filePath.future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return snapshot.data != null
                            ? Hero(
                                tag: widget.message,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.file(
                                      File(snapshot.data!),
                                      width: 80.0,
                                      height: 80.0,
                                      fit: BoxFit.cover,
                                    ),
                                    ColoredBox(
                                      color: Colors.black.withOpacity(.3),
                                      child: Center(
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.black.withOpacity(.2),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const Center(
                                child: Text('Failed to load video Thumbnail'),
                              );
                      } else {
                        return const Center(
                          child: Text('Failed to load video Thumbnail'),
                        );
                      }
                    }),
              ),
              // openBuilder: (context, closeAction) =>
              //     AveoVideoPlayer.network(
              //         uri: widget.message,
              //         builder: (context, player, videoPlayerController) {
              //           return Scaffold(
              //             body: Center(
              //                 child: AspectRatio(
              //                     aspectRatio: videoPlayerController
              //                         .value.aspectRatio,
              //                     child: player)),
              //           );
              //         }),
              // ),
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
