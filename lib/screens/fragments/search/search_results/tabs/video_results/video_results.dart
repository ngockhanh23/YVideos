import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/video_results/video_result_item.dart';
import 'package:y_videos/screens/video_item_screen/video_item_screen.dart';
import 'package:y_videos/servieces/video_sevices.dart';

import '../../../../../../components/video_item/video_item.dart';
import '../../../../../../models/video.dart';

class VideoResults extends StatefulWidget{

  String searchKey;
  VideoResults({super.key, required this.searchKey});

  @override
  State<VideoResults> createState() => _VideoResultsState();
}

class _VideoResultsState extends State<VideoResults> {
  List<Video> lstVideo = [];

  @override
  void initState() {
    // TODO: implement initState
    fetchProfileVideo();
    super.initState();
  }

  fetchProfileVideo() async {
    VideoServices().getVideosBySearchKey(widget.searchKey).then((result) {
      setState(() {
        lstVideo = result;
      });

    });

  }

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
        itemCount: lstVideo.length, // Số lượng item trong GridView
        itemBuilder: (BuildContext context, int index) {
          return VideoResultItem(video: lstVideo[index],);
        },

    );
  }
}