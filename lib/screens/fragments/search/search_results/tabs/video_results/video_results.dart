import 'package:flutter/material.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/video_results/video_result_item.dart';
import 'package:y_videos/screens/video_item_screen/video_item_screen.dart';

import '../../../../../../models/video.dart';

class VideoResults extends StatelessWidget{

  List<Video> lstVideo = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  GridView.builder(

        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: 0.5
        ),
        itemCount: 3, // Số lượng item trong GridView
        itemBuilder: (BuildContext context, int index) {
          return VideoItemScreen(video: lstVideo[index],);
        },

    );
  }
}