import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:y_videos/components/video_item/video_item.dart';
import 'package:y_videos/models/video.dart';
import 'package:y_videos/screens/video_item_screen/video_item_screen.dart';

import '../../models/account.dart';
import '../../servieces/account_services.dart';

class ThumbnailVideo extends StatefulWidget {
  final Video video;

  ThumbnailVideo({required this.video});

  @override
  State<ThumbnailVideo> createState() => _ThumbnailVideoState();
}

class _ThumbnailVideoState extends State<ThumbnailVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(widget.video.videoUrl);
    _controller.initialize().then((_) {
      // Đảm bảo rằng sau khi khởi tạo xong, video sẽ không tự động chạy.
      _controller.setLooping(
          true); // Nếu bạn muốn video tự động lặp lại, sử dụng true.
      setState(() {}); // Cập nhật trạng thái sau khi khởi tạo.
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideoItemScreen(video: widget.video),
                    ));
              },
              child: VideoPlayer(_controller),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
