import 'dart:developer';

import 'package:aveochat/aveochat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioMessageBubble extends StatefulWidget {
  final String message;
  final String caption;
  final bool isMessageSent;
  final Color sentMessageColor;
  final Color receivedMessageColor;
  const AudioMessageBubble({
    super.key,
    required this.message,
    required this.caption,
    required this.isMessageSent,
    required this.receivedMessageColor,
    required this.sentMessageColor,
  });

  @override
  State<AudioMessageBubble> createState() => _AudioMessageBubbleState();
}

class _AudioMessageBubbleState extends State<AudioMessageBubble>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AudioMessageBubbleThemeData audioMessageBubbleThemeData = AveoChatConfig
      .instance.aveoChatOptions.chatRoomThemeData.audioMessageBubbleThemeData;
  late AudioPlayer _audioPlayer;
  late final ValueNotifier<Duration?> _duration = ValueNotifier(Duration.zero);
  late AnimationController _animationController;
  late ValueNotifier<bool?> hasLoaded = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: widget.isMessageSent
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(
              maxHeight: 52, minHeight: 52, maxWidth: 180, minWidth: 180),
          padding: const EdgeInsets.only(top: 3.0, left: 3.0, right: 3.0),
          child: ValueListenableBuilder<bool?>(
              valueListenable: hasLoaded,
              builder: (context, loaded, w) {
                return loaded == null
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Failed to load audio",
                            style: TextStyle(
                              color: widget.isMessageSent
                                  ? widget.sentMessageColor
                                  : widget.receivedMessageColor,
                            ),
                          ),
                        ],
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: audioMessageBubbleThemeData.bgTintColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0)),
                        ),
                        child: Visibility(
                          visible: widget.message.isNotEmpty && loaded,
                          replacement: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (_audioPlayer.playing) {
                                    _audioPlayer.pause();
                                  } else {
                                    _audioPlayer.play();
                                  }
                                },
                                icon: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: _animationController,
                                  color: widget.isMessageSent
                                      ? widget.sentMessageColor
                                      : widget.receivedMessageColor,
                                ),
                              ),
                              Expanded(
                                child: ValueListenableBuilder<Duration?>(
                                  valueListenable: _duration,
                                  builder: (context, value, child) {
                                    return value == null ||
                                            value.inSeconds.toDouble() == 0.0
                                        ? const Center(
                                            child: CupertinoActivityIndicator(),
                                          )
                                        : StreamBuilder<Duration>(
                                            stream: _audioPlayer.positionStream,
                                            builder: (context, snapshot) {
                                              return Slider(
                                                min: Duration.zero.inSeconds
                                                    .toDouble(),
                                                max: _duration.value?.inSeconds
                                                        .toDouble() ??
                                                    Duration.zero.inSeconds
                                                        .toDouble(),
                                                value: snapshot.data?.inSeconds
                                                        .toDouble() ??
                                                    Duration.zero.inSeconds
                                                        .toDouble(),
                                                activeColor: widget
                                                        .isMessageSent
                                                    ? widget.sentMessageColor
                                                    : widget
                                                        .receivedMessageColor,
                                                onChanged: (value) {
                                                  _audioPlayer.seek(Duration(
                                                      seconds: value.toInt()));
                                                },
                                              );
                                            },
                                          );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      );
              }),
        ),
        widget.caption.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  widget.caption,
                  style: TextStyle(
                    color: widget.isMessageSent
                        ? widget.sentMessageColor
                        : widget.receivedMessageColor,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _audioPlayer = AudioPlayer();
    loadAudio();

    super.initState();
  }

  loadAudio() async {
    try {
      _duration.value = await _audioPlayer.setUrl(widget.message);
      _duration.value ??= Duration.zero;
      hasLoaded.value = true;

      _audioPlayer.playerStateStream.listen((event) {
        if (event.processingState == ProcessingState.completed) {
          _audioPlayer.pause();
          _audioPlayer.seek(Duration.zero);
          _animationController.reverse();
        }
      });

      _audioPlayer.playingStream.listen((isPlaying) {
        if (isPlaying) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    } catch (e) {
      log("URL : ${widget.message}");
      log(e.toString());
      hasLoaded.value = null; // null due to error
    }

    log(_duration.toString());
  }

  @override
  bool get wantKeepAlive =>
      audioMessageBubbleThemeData.keepAudioAliveWhenScrolled;
}
