import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/models/video.dart';
import 'package:y_videos/servieces/account_services.dart';

import '../../../components/thumbnail_video/thumbnail_video.dart';

class ProfileVideos extends StatefulWidget{
  String userID;

  ProfileVideos({super.key, required this.userID});

  @override
  State<ProfileVideos> createState() => _ProfileVideosState();
}

class _ProfileVideosState extends State<ProfileVideos> {
  List<Video> _lstVideo = [];
  String? userLoginID;

  @override
  void initState() {
    _getUserLoginID();
    fetchProfileVideo();
    super.initState();
  }

  _getUserLoginID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userLoginID = prefs.getString('user_id') ?? "";
  }



  fetchProfileVideo() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Videos')
          .where('user_id', isEqualTo: widget.userID)
          .get();

      List<Video> videoList = [];

      for (var doc in querySnapshot.docs) {
        Video video = Video(
          doc.id,
          doc['video_url'],
          doc['content_video'],
          doc['date_upload'].toDate(),
          doc['privacy_viewer'],
          doc['user_id'],
        );

        videoList.add(video);
      }

      setState(() {
        _lstVideo = videoList;
      });
    } catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      child: Column(
        children: [
          Divider(thickness: 0.2,),
          Icon(Icons.video_collection_outlined, size: 30,),
          Container(
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.7
              ),
              itemCount: _lstVideo.length, // Số lượng item trong GridView
              itemBuilder: (BuildContext context, int index) {
                if (userLoginID != _lstVideo[index].userID && _lstVideo[index].privacyViewer == 1)
                  return  Container(
                    decoration: BoxDecoration(

                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline_rounded),
                        Text("Đây là video riêng tư"),
                      ],
                    ),
                  );
                else
                  return ThumbnailVideo(
                    video: _lstVideo[index],
                  );
              },
            ),
          )
        ],
      ),
    );
  }
}