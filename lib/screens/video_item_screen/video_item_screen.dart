import 'package:flutter/material.dart';
import 'package:y_videos/components/video_item/video_item.dart';

import '../../models/video.dart';

class VideoItemScreen extends StatelessWidget{
  Video video;

  VideoItemScreen({super.key, required this.video});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [

          Padding(
            padding: const EdgeInsets.only(bottom: 65),
            child: VideoItem(video: video),
          ),
          Positioned(
            top: 30,
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,size: 40,),
              )
          ),
        ],
      ),
    );
  }
}