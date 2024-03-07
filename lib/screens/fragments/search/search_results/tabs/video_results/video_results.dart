import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/video_results/video_result_item.dart';
import 'package:y_videos/screens/video_item_screen/video_item_screen.dart';

import '../../../../../../components/video_item/video_item.dart';
import '../../../../../../models/video.dart';

class VideoResults extends StatefulWidget{

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
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Videos')
          .where('user.user_id', isEqualTo: 'ngc_knh')
          .get();

      List<Video> videoList = [];

      for (var doc in querySnapshot.docs) {
        Video video = Video(
          doc.id,
          doc['video_url'],
          doc['content_video'],
          doc['date_upload'].toDate(),
          doc['privacy_viewer'],
          doc['user_id']
        );

        videoList.add(video);
      }

      setState(() {
        lstVideo = videoList;
      });
    } catch (e) {
      print('$e');
    }
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