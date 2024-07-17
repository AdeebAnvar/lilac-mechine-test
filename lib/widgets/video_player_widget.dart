import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final File? image;
  VideoPlayerWidget({required this.videoUrl, this.image});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  // late VideoPlayerController _controller;
  late PodPlayerController _controller;

  @override
  void initState() {
    super.initState();
    try {
      _controller.dispose();
    } catch (e) {}
    _controller = PodPlayerController(
      podPlayerConfig: const PodPlayerConfig(autoPlay: true),
      playVideoFrom: PlayVideoFrom.network(widget.videoUrl.toString()),
    )..initialise().then((dynamic value) {
        setState(() {});
      }).catchError((dynamic onError, dynamic stackTrace) {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PodVideoPlayer(
      alwaysShowProgressBar: true,
      controller: _controller,
      matchFrameAspectRatioToVideo: true,
      matchVideoAspectRatioToFrame: true,
    );
  }
}
