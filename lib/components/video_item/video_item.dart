
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:y_videos/components/video_item/comments/comments.dart';
import 'package:y_videos/models/account.dart';
import 'package:y_videos/models/video.dart';
import 'package:y_videos/models/video_likes.dart';
import 'package:y_videos/screens/fragments/search/search_results/tabs/account_results/account_results.dart';
import 'package:y_videos/screens/profile/personal_profile/personal_profile.dart';
import 'package:y_videos/servieces/comment_services.dart';
import 'package:y_videos/servieces/video_sevices.dart';

import '../../servieces/account_services.dart';

class VideoItem extends StatefulWidget {
  final Video video;

  VideoItem({Key? key, required this.video}) : super(key: key);

  @override
  _VideoItemState createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;
  bool showHeartIcon = false;
  bool isPlaying = true;
  bool isMuted = false;
  bool isLiked = false;

  bool isLoadLikesCount = true;
  int commentsCount = 0;
  int likesCount = 0;

  VideoLikesByUser? likesByUserLogin;

  Account userLogin = Account.empty();
  Account? _userUpload;


  @override
  void initState() {
    playVideo();
    _getCommentCount();
    _getUserUpload();
    _getUserLogin().then((_) {
      // _getLikedByUserLogin();
      _getVideoLikesByID();
    });

    super.initState();
  }

  playVideo(){
    _controller = VideoPlayerController.network(widget.video.videoUrl)
      ..initialize().then((_) {
        _controller.setLooping(true);
        if (isPlaying) {
          _controller.play();
        }
        setState(() {

        });
      });
  }

  _getVideoLikesByID()async{
    VideoServices().getVideoLikesByVideoID(widget.video.id).then((lstLikedVideo) {
      likesCount = lstLikedVideo.length;
      isLoadLikesCount = false;
      if (lstLikedVideo.any((item) {
        if (item.userID == userLogin.userID) {
          likesByUserLogin = item;
          return true;
        }
        return false;
      })) {
        // Gọi hàm ở đây
        isLiked = true;
      }

      setState(() {

      });

      print('count liked : ' + lstLikedVideo.length.toString());
    });
  }

  _getCommentCount() async {
    commentsCount = await CommentServices().getCommentCountByVideoID(widget.video.id);
  }


  _getUserLogin()  async {
    userLogin = await AccountServices.getUserLogin();
  }


  _handleLikeVideo(int currentLikesCount)  {
      if(isLiked == false){
        setState(() {
          isLiked = true;
          likesCount ++;
        });
         VideoServices().likeVideo(userLogin.userID, widget.video.id).then((likeByUser) => {
          likesByUserLogin = likeByUser
        });
      }
  }

  _handleUnLikeVideo(currentLikesCount) {
    setState(() {
      isLiked = false;
      likesCount  --;


    });
    try {
      VideoServices().unLikeVideo(likesByUserLogin!.id);
    } catch (error) {
      print('Lỗi khi thích video: $error');
    }
  }

  _getUserUpload() {
    AccountServices().getAccountByUserID(widget.video.userID).then((value){
      _userUpload = value;
    });
  }



  @override
  Widget build(BuildContext context) {

    return isLoadLikesCount == true ? const Center(
      child: CircularProgressIndicator(),
    ) :

      Container(
      width: double.infinity,
      color: Colors.black,
      child:
      Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: GestureDetector(
              onTap: () {
                if (isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                }
                setState(() {
                  isPlaying = !isPlaying;
                });
              },
              onDoubleTap: (){
                _handleLikeVideo(likesCount!).then((_){
                  setState(() {
                    this.showHeartIcon = true;
                    // if(!this.isLiked)
                    // {
                    //   // this.isLiked = true;
                    //   this.widget.video.numberOfLikes++;
                    // }
                  });
                  Future.delayed(Duration(seconds: 1), () {
                    setState(() {
                      this.showHeartIcon = false;
                      // if(!this.isLiked)
                      //   this.isLiked = true;
                    });
                  });
                });


              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayerScreen(
                      videoUrls: widget.video.videoUrl, controller: _controller),
                  if (!isPlaying)
                    Icon(
                      Icons.play_arrow,
                      size: 80,
                      color: Colors.white,
                    ),
                  if (showHeartIcon)
                    TweenAnimationBuilder(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 5),
                      builder: (BuildContext context, double value, Widget? child) {
                        return Transform.scale(
                          scale: value, // Hiệu ứng zoom
                          child: Opacity(
                            opacity: value, // Hiệu ứng fade-in
                            child: Icon(
                              Icons.favorite,
                              size: 100,
                              color: Colors.redAccent,
                            ),
                          ),
                        );
                      },
                    ),

                ],
              ),
            ),
          ),
          Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 9),
                          child: InkWell(
                              onTap: ()  {
                                _controller.pause();
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonalProfile(userID: widget.video.userID),
                                  ),
                                ).then((value) {
                                  // Xử lý sau khi màn hình PersonalProfile được đóng
                                  _controller.play();
                                  isPlaying = true;
                                });
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  // color: Service.primaryColor,
                                  color: Colors.white,
                                  // borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      width: 2, color: Colors.black12),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      _userUpload!.avatarUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                print("follow profile");
                              },
                              child: CircleAvatar(
                                backgroundColor: Color(0xffff2100),
                                radius: 12, // Đặt bán kính mong muốn ở đây
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(

                          child: Icon(
                            Icons.favorite_outlined,
                            size: 50,
                            color: this.isLiked ? Colors.redAccent : Colors.white,
                          ),
                          onTap: () {
                            isLiked ? _handleUnLikeVideo(likesCount) : _handleLikeVideo(likesCount);
                          },
                        ),
                        Text(
                          likesCount.toString(),
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.message_rounded,
                            size: 50,
                            color: Colors.white,
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return CommentsList(videoID: widget.video.id,userID: _userUpload!.userID,);
                              },
                            );
                          },
                        ),
                        Text(
                          commentsCount.toString(),
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.share,
                            size: 50,
                            color: Colors.white,
                          ),
                          onTap: () {

                          },
                        ),
                        Text(
                          "Chia sẽ",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),


                  IconButton(
                    iconSize: 40,
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: isMuted
                          ? Icon(Icons.volume_off, color: Colors.black)
                          : Icon(Icons.volume_up, color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {
                        isMuted = !isMuted;
                        _controller.setVolume(isMuted ? 0.0 : 1.0);
                      });
                    },
                    color: Colors.white,
                  )
                ],
              )),

          Positioned(
              bottom: 10.0,
              left: 10.0,
              child: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){},
                      child: Text(_userUpload!.userID, style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                    Text(widget.video.contentVideo,
                      maxLines: 80,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                      ),
                    )
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrls;
  final VideoPlayerController controller;

  VideoPlayerScreen({required this.videoUrls, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }
}

