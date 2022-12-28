import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final String tag;
  final String url;
  const ImageViewer({Key? key, required this.tag, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity ||
              details.delta.dy < -sensitivity) {
            // Down / Up Swipe
            Navigator.pop(context);
          }
        },
        child: Visibility(
          visible: url.contains('http'),
          replacement: Image.file(File(url)),
          child: CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
