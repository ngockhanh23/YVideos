import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe/flutter_swipe.dart';
import 'package:y_videos/components/video_item/video_item.dart';
import 'package:y_videos/data/data.dart';

import '../../../models/video.dart';

class HomeFragment extends StatefulWidget{

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}



class _HomeFragmentState extends State<HomeFragment> {



  //list video widget
  List<Widget> _lstVideo = [];
  // List<Video> videoList = Data.getVideoList();


  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Data data = Data();
    // data.fetchDataVideo();
    // data.getVideoData().forEach((item){
    //   _lstVideo.add(VideoItem(video: item));
    // });
    fetchDataVideo();


  }

  Future<void> fetchDataVideo() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Videos').get();
    List<VideoItem> videoList = [];

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> userUpload = doc['user'] as Map<String, dynamic>;

      Video video = Video(
        doc.id,
        doc['video_url'],
        doc['content_video'],
        doc['date_upload'].toDate(),
        userUpload,
      );

      videoList.add(VideoItem(video: video));
    });

    setState(() {
      _lstVideo = videoList;
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,

      body: Container(

       height: double.infinity,

          child: Stack(
            children: [

              Container(
                height: double.infinity,
                child: PageView(

                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _lstVideo.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : Swiper(
                      itemCount: _lstVideo.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return _lstVideo[index];
                      },
                    ),
                    Center(child: Text("page2",style: TextStyle(color: Colors.white),),),


                  ],
                ),
              ),

                Container(

                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          child: InkWell(
                            highlightColor: Colors.black,
                            onTap: () {
                              _pageController.animateToPage(
                                0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(

                              padding:
                              EdgeInsets.symmetric(horizontal: 16.0),


                                child: Text("Dành cho bạn", style: TextStyle(
                                    color: _currentPage==0 ? Colors.white : Colors.white70,
                                    fontSize: 18
                                ),
                              ),
                            ),

                          )
                      ),
                      Container(
                          child: InkWell(
                            onTap: () {
                              _pageController.animateToPage(
                                1,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(

                              padding:
                              EdgeInsets.symmetric(horizontal: 16.0),


                                child: Text("Đang theo dõi", style: TextStyle(
                                    color: _currentPage==1 ? Colors.white : Colors.white70,
                                    fontSize: 18
                                ),
                              ),
                            ),

                          )
                      ),
                    ],
                  ),
                ),
            ],
          ),
        )

    );
  }
}